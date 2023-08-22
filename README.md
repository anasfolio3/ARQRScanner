# AR QR Scanner / Factory Native App

![AppIcon](https://user-images.githubusercontent.com/66309582/170818164-78551d05-b19f-4422-91b6-386d7194f3ea.png)

iOS AR app that records base and mobile QR Code, measures the distance between them and then use base QR code to place mobile QR codes relative to base

The project;

- Xcode 13.4, Swift 5.5 (Swift Concurrency)
- Target: iOS / iPadOS 15.0 and later
- Frameworks: SwiftUI, ARKit, RealityKit2, Vision

It shows;

- QR code detection in ARFrame with Vision framework
- Raycasting to locate the QR code position in the AR scene
- Displaying polygon on top of the QR code using RealityKit 2 procedural geometry

## References

- Apple Documentation: API [VNDetectBarcodesRequest](https://developer.apple.com/documentation/vision/vndetectbarcodesrequest)
- Apple Documentation: API [VNBarcodeObservation](https://developer.apple.com/documentation/vision/vnbarcodeobservation)
- Apple Documentation: API [VNBarcodeSymbology](https://developer.apple.com/documentation/vision/vnbarcodesymbology)
- Apple Documentation: API [raycastQuery(from:allowing:alignment:)
](https://developer.apple.com/documentation/arkit/arframe/3194578-raycastquery)
- Apple Documentation: API [ARRaycastResult](https://developer.apple.com/documentation/arkit/arraycastresult)

![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)
