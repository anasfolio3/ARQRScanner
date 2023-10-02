//
//  ARScene.swift
//  arqrscanner
//
//  Created by Yasuhito Nagatomo on 2022/05/26.
//

import ARKit
import RealityKit
import Combine

final class ARScene {
    enum State { case stop, scanning }
    private var state: State = .stop
    private var accumulativeTime: Double = 0.0
    private let detectionIntervalTime: Double = 5.0 // scanning interval [sec]
    private var renderLoopSubscription: Cancellable?

    private var arView: ARView!
    private var baseEntity = Entity()

    private var qrCodeCollection = QRCodeCollection()
        
    private var baseCode: QRCode? = nil;
    private var mobileCode: QRCode? = nil;
    private var viewMode:Bool = false;
    private var dirVector: SIMD3<Float> = .zero
    var distanceMeter = ""
    var distanceCM = ""
    private var backButton : UIButton? = nil
    private var scanButton : UIButton? = nil
    
    func setBackButton(btn : UIButton){
        backButton = btn
        btn.addTarget(self, action: #selector(resetCodes), for: .touchUpInside)
    }
    
    func setScanButton(btn : UIButton){
        scanButton = btn
        btn.addTarget(self, action: #selector(scanCode), for: .touchUpInside)
    }
    
    @objc
    func resetCodes(){
        backButton?.isHidden = true
        scanButton?.isHidden = false
        viewMode = false;
        qrCodeCollection = QRCodeCollection();
        baseCode = nil;
        mobileCode = nil;
        removeAllChildEntities(from: baseEntity)
    }
    
    @objc
    func scanCode(){
        guard let frame = self.arView.session.currentFrame else { return }
        Task{
            // scan the QR code
            let qrcodes = self.scan(frame: frame)
            // place virtual objects in the AR scene
            if !qrcodes.isEmpty {
                await MainActor.run {
                    for qrcode in qrcodes {
                        NotificationCenter.default.post(name: Notification.Name("QR"), object: nil, userInfo: ["message" : "Scanned: \(qrcode.payload!)"])
                        // when view mode is true
                        if (self.viewMode == true){
                            if(qrcode.payload == self.baseCode?.payload){
                                self.placeQRCodeModel(at: qrcode)
                                self.placeModelRelativeToBase()
                                self.viewMode = false;
                            }
                        }
                        else if !self.qrCodeCollection.isIncluded(qrcode) {
                            self.qrCodeCollection.add(qrcode)
                            self.placeQRCodeModel(at: qrcode)
                            print("LOG: payload = \(qrcode.payload ?? "")")
                            //                                    NotificationCenter.default.post(name: Notification.Name("QR"), object: nil, userInfo: ["message" : qrcode.payload])
                            
                            if(self.baseCode == nil){
                                self.baseCode = qrcode
                            }
                            else{
                                self.mobileCode = qrcode
                                self.calculateDistance()
                                let alert = UIAlertController(title: "Do you want to switch to view mode?", message: "Calculated distance is \(self.distanceMeter) \(self.distanceCM)", preferredStyle:.alert)
                                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { _ in
                                    self.triggerViewMode()
                                }))
                                alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { _ in
                                    self.resetCodes()
                                }))
                                
                                if let window = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first
                                {
                                    window.rootViewController?.present(alert, animated: true)
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func triggerViewMode(){
        self.backButton?.isHidden = false
        //scanButton?.isHidden = true
        viewMode = true;
        removeAllChildEntities(from: baseEntity)
    }

    init(arView: ARView, anchor: AnchorEntity) {
        self.arView = arView
        anchor.addChild(baseEntity)
    }

    func startSession() {
        startScanning()
    }

    func stopSession() {
        stopScanning()
    }
}

extension ARScene {
    private func startScanning() {
        guard state == .stop else { return }
        state = .scanning
        renderLoopSubscription = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
            // This closure will be called on the Main Thread.
            // print("LOG: render subscription runs on \(Thread.isMainThread ? "(m)" : "(-)")")

            // Scan QR code periodically
            self.accumulativeTime += event.deltaTime
            if self.accumulativeTime > self.detectionIntervalTime {
                guard let frame = self.arView.session.currentFrame else { return }
                self.accumulativeTime = 0 // clear after confirmation of frame existence
                
            }
        }
    }

    private func stopScanning() {
        guard state == .scanning else { return }
        state = .stop
        renderLoopSubscription?.cancel()
        renderLoopSubscription = nil
    }

    // Scans multiple QR code in the ARFrame
    // and calculates their positions in the AR scene.
    private func scan(frame: ARFrame) -> [QRCode] {
        var codes: [QRCode] = []

        // Scan QR code with Vision

        let request = VNDetectBarcodesRequest()
        // By default, a request scans for all symbologies of barcode.
        // Limit for QR code and micro QR code.
        request.symbologies = [VNBarcodeSymbology.qr, VNBarcodeSymbology.microQR]

        // [Note] VNRequest.preferBackgroundProcessing is false by default.
        // print("LOG: VNRequest.preferBackgroundProcessing = \(request.preferBackgroundProcessing)")

        let handler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage)
        do {
            try handler.perform([request])
        } catch {
            return []   // error occurred.
        }

        guard let results = request.results  //  [VNBarcodeObservation]?
        else {
            return [] // VNRequest produced no result.
        }

        // Convert detected QR code's 2d-positions to 3d-positionss in the AR scene
        for result in results {
            // [Note] VNBarcodeObservation.barcodeDescriptor can be used
            //        to regenerate the barcode with CoreImage.
            // [Note] VNBarcodeObservation.symbology can be used
            //        to identify the barcode type.
            // [Note] VNObservation.confidence [0, 1] can be used
            //        to check the level of confidence.

            // project four 2d-points to the closest 3d-points
            let vertices: [matrix_float4x4] = [
                result.topLeft,     // CGPoint - 2d point [0.0...1.0]
                result.topRight,
                result.bottomLeft,
                result.bottomRight
            ].compactMap {
                // convert Vision coordinate (+Y up) to UIKit coordinate (+Y down)
                let pos2d = CGPoint(x: $0.x, y: 1.0 - $0.y)
                // project the 2d-point onto any plane in the 3d scene
                let query = frame.raycastQuery(from: pos2d, allowing: .estimatedPlane,
                                   alignment: .any)
                // take the nearest 3d-point of projected points
                guard let hitPoint3d = self.arView.session.raycast(query).first
                else {
                    return nil // no projected point
                }

                // [Note] hitTest(_:types:) API is deprecated
                //    guard let hitFeature = frame.hitTest($0, // CGPoint
                //              types: .featurePoint) // .existingPlane or .featurePoint

                // [Note] ARRaycastResult.targetAlignment can be used
                //        to know the surface alignment, any | horizontal | vertical.
                return hitPoint3d.worldTransform
            }

            // check the vertices of the QR code
            if QRCode.isValid(vertices: vertices) {
                codes.append(QRCode(vertices: vertices,
                                    payload: result.payloadStringValue))
            }
        } // for
        return codes
    }
}

extension ARScene {
    // Places virtual objects of the QR code in the AR scene
    private func placeQRCodeModel(at qrcode: QRCode) {
        assert(qrcode.vertices.count == 4)
        var positions: [SIMD3<Float>] = []

        // place a polygon on top of the QR code

        for vertex in qrcode.vertices { // 0:top-left, 1:-right, 2:bottom-left, 3:-right
            positions.append(SIMD3<Float>(vertex[3].x,
                                          vertex[3].y, vertex[3].z))
        }
        let counts: [UInt8] = [4] // four vertices for one polygon
        let indices: [UInt32] = [0, 2, 3, 1] // one polygon

        var descriptor = MeshDescriptor()
        descriptor.positions = MeshBuffers.Positions(positions)
        descriptor.primitives = .polygons(counts, indices) // counts, indices
        descriptor.materials = .allFaces(0)

        let matPolygon = SimpleMaterial(color: UIColor.randomColor(alpha: 0.8),
                                      isMetallic: false)
        if let meshPolygon = try? MeshResource.generate(from: [descriptor]) {
            let model = ModelEntity(mesh: meshPolygon,
                                    materials: [matPolygon])
            model.name = "plane"
            baseEntity.addChild(model)
        } else {
            fatalError("failed to generate mesh-resource.")
        }
        
//        /* Place a sphere on top of the QR code plane */
//        let meshSphere = MeshResource.generateSphere(radius: 0.01)
//        let matSphere = SimpleMaterial(color: UIColor.randomColor(alpha: 1.0),
//                                      isMetallic: false)
//        let model = ModelEntity(mesh: meshSphere, materials: [matSphere])
//        model.transform.translation = qrcode.center
//        baseEntity.addChild(model)
//        model.name = "ball"
    }
    
    func calculateDistance() {
        
        let start = baseCode.unsafelyUnwrapped.center
        let end = mobileCode.unsafelyUnwrapped.center
        
        let distance = sqrt(pow(start.x - end.x, 2) +
                           pow(start.y - end.y, 2) +
                           pow(start.z - end.z, 2))
                
        distanceMeter = String(format: "%.3f m", abs(distance))
        distanceCM = String(format: "%.3f cm", (abs(distance) * 100))

//        NotificationCenter.default.post(name: Notification.Name("QR"), object: nil, userInfo: ["message" : "\(distanceMeter), \(distanceCM)"])
        
        // calculating the dir vector
        dirVector = end - start;
    }
    
    func createTextEntity(text: String) -> Entity {
        let textMesh = MeshResource.generateText(text, extrusionDepth: 0.01, font: .systemFont(ofSize: 0.1), containerFrame: CGRect.zero, alignment: .left, lineBreakMode: .byTruncatingTail)
        
        let textModelComponent = ModelComponent(mesh: textMesh, materials: [SimpleMaterial(color: UIColor.black, isMetallic: false)]);
        let textEntity = Entity()
        textEntity.components.set(textModelComponent)
        textEntity.scale = SIMD3<Float>(x: 0.12, y: 0.12, z: 0.12);
        return textEntity
    }

    
    func placeGenericModel(v: SIMD3<Float>){
        
        let matGeo = SimpleMaterial(color: UIColor.randomColor(alpha: 1.0), isMetallic: false)
        
        /* Plane mesh creation */
        let meshGeo = MeshResource.generateBox(width: 0.06, height: 0.06, depth: 0.06, cornerRadius: 0.005)
        let model = ModelEntity(mesh: meshGeo, materials: [matGeo])
        
        let rotationAngle: Float = 40.0
        let rotation = simd_quatf(angle: rotationAngle * .pi / 180, axis: [0, 1, 0])
//        model.transform.rotation = rotation
        //        /* Sphere mesh creation */
        //        let meshGeo = MeshResource.generateSphere(radius: 0.04)
        //        let model = ModelEntity(mesh: meshGeo, materials: [matGeo])
        //
        //        let scaleY: Float = 0.03
        //        model.transform.scale.y = scaleY
        if let basePosition = baseCode?.center, let mobileCodePayload = mobileCode?.payload {
            let modelPosition = basePosition + v;
            model.transform.translation = modelPosition;
            let length =  simd_precise_length(v);
            let currentLine = generateLineMesh(to: modelPosition, from: basePosition, wide: length);
                
            let vectorString = "Install router here (\(mobileCodePayload)) \nX: \(String(format: "%.2f", modelPosition.x)) \nY: \(String(format: "%.2f", modelPosition.y))\nZ: \(String(format: "%.2f", modelPosition.z))";
            let textEntity = createTextEntity(text: vectorString);
            
            textEntity.position = modelPosition;
            textEntity.position.y += 0.06;
            
            baseEntity.addChild(currentLine);
            baseEntity.addChild(textEntity);
            
        }
        
        baseEntity.addChild(model)
        model.name = "ball"
    }
    
    func generateLineMesh(to: SIMD3<Float>, from: SIMD3<Float>, wide: Float) -> ModelEntity
    {
        var mat = PhysicallyBasedMaterial()
        mat.baseColor = .init(tint: .black)
        mat.sheen = .init(tint: .black)
        mat.emissiveIntensity = 3
        mat.emissiveColor = .init(texture: MaterialParameters.Texture(try! .load(named: "Stripe")))
        
        //mat.emissiveColor = .init(color: .systemBlue)
        
        let rectangle = ModelEntity(mesh: .generateBox(width: 0.003, height: 0.003, depth: wide), materials: [mat])
        let middlePoint : simd_float3 = simd_float3((from.x + to.x)/2, (from.y + to.y)/2, (from.z + to.z)/2);
        rectangle.position = middlePoint;
        rectangle.look(at: from, from: middlePoint, relativeTo: nil);
        
        return rectangle;
    }
            
    func placeModelRelativeToBase(){
        placeGenericModel(v: dirVector)
    }
    
    func removeAllChildEntities(from entity: Entity) {
        for i in (0..<entity.children.count).reversed() {
            let childEntity = entity.children[i]
            childEntity.removeFromParent()
        }
    }

}
