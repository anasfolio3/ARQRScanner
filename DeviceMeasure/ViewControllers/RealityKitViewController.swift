//
//  RealityKitViewController.swift
//  DeviceMeasure
//
//  Created by anas ur rehman on 23/10/2023.
//

import UIKit
import RealityKit
import ARKit

class RealityKitViewController: BaseViewController {
    @IBOutlet weak var realityKitView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Reality kit view loaded")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
