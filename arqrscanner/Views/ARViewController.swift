//
//  ARViewController.swift
//  arqrscanner
//
//  Created by Yasuhito Nagatomo on 2022/05/26.
//

import UIKit
import ARKit
import RealityKit

final class ARViewController: UIViewController {
    private var arView: ARView!
    private var arScene: ARScene!
    let bottomLabel = UILabel()
    let backButton = UIButton()
    let scanButton = UIButton()

    override func viewDidLoad() {
        #if targetEnvironment(simulator)
        arView = ARView(frame: .zero)
        #else
        if ProcessInfo.processInfo.isiOSAppOnMac {
            arView = ARView(frame: .zero, cameraMode: .nonAR,
                            automaticallyConfigureSession: true)
        } else {
            arView = ARView(frame: .zero, cameraMode: .ar,
                            automaticallyConfigureSession: true)
        }
        #endif
        // arView.session.delegate = self

        #if DEBUG
        arView.debugOptions = [.showFeaturePoints]
        #endif

        view = arView
        let anchorEntity = AnchorEntity()
        arView.scene.addAnchor(anchorEntity)
        arScene = ARScene(arView: arView, anchor: anchorEntity)
        
        #if !targetEnvironment(simulator)
        if !ProcessInfo.processInfo.isiOSAppOnMac {
            let config = ARWorldTrackingConfiguration()
            // RayCasting uses detected planes.
            config.planeDetection = [.horizontal, .vertical]
            arView.session.run(config)
        }
        #endif

        NotificationCenter.default.addObserver(self, selector: #selector(onQRPayload(_:)), name: Notification.Name("QR"), object: nil)
        addLabel(text: "Scanning..")
        addBackButton()
        addScanButton()
        arScene.startSession()
    }
    
    @objc func onQRPayload(_ not: Notification) {
        if let userInfo = not.userInfo, let text = userInfo["message"] as? String {
            DispatchQueue.main.async {
                self.bottomLabel.text = text
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("QR"), object: nil)
        arScene.stopSession()
    }
    
    private func addLabel(text: String) {
        
        // Create a UILabel
        bottomLabel.text = text
        bottomLabel.textAlignment = .center
        bottomLabel.backgroundColor = .black
        bottomLabel.textColor = .white
        
        // Add the label to the view
        arView.addSubview(bottomLabel)
        
        // Enable auto layout for the label
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Set constraints for the label
        NSLayoutConstraint.activate([
            bottomLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomLabel.heightAnchor.constraint(equalToConstant: 50) // Adjust the height as needed
        ])
    
    }
    
    private func addBackButton() {
        
        backButton.setTitle("Back", for: .normal)
        backButton.frame = CGRect.init(x: 0, y: 0, width: 100, height: 50)
        
        // Add the label to the view
        arView.addSubview(backButton)
        
        arScene.setBackButton(btn: backButton)
        
        backButton.isHidden = true
        
        // Enable auto layout for the label
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Set constraints for the label
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 50), // Adjust the height as needed
            backButton.widthAnchor.constraint(equalToConstant: 100) // Adjust the height as needed
        ])
    
    }
    
    private func addScanButton() {
        
        scanButton.setTitle("Scan", for: .normal)
        scanButton.frame = CGRect.init(x: 0, y: 0, width: 100, height: 50)
        
        // Add the label to the view
        arView.addSubview(scanButton)
        
        arScene.setScanButton(btn: scanButton)
        
        scanButton.isHidden = false
        
        // Enable auto layout for the label
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Set constraints for the label
        NSLayoutConstraint.activate([
            scanButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scanButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -50),
            scanButton.heightAnchor.constraint(equalToConstant: 50), // Adjust the height as needed
            scanButton.widthAnchor.constraint(equalToConstant: 100) // Adjust the height as needed
        ])
    
    }
}
