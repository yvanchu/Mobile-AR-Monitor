//
//  ViewController.swift
//  CARP 0.0
//
//  Created by Yvan Chu on 12/7/20.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    // Parametres
    let viewBackgroundColor : UIColor = UIColor.black // UIColor.white
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // App Setup
        UIApplication.shared.isIdleTimerDisabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()

        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "carp", bundle: nil) else {
            fatalError("couldn't load tracking images.")
        }
        // Run the view's session
        configuration.videoFormat = ARImageTrackingConfiguration.supportedVideoFormats[0]
        configuration.trackingImages = trackingImages
        configuration.maximumNumberOfTrackedImages = 4
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        // make sure this is an image anchor, otherwise bail out
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }

        // create a plane at the exact physical width and height of our reference image
        let plane = SCNPlane(width: 0.31, height: 0.21)

        let myView = UIImage(named:"GoogleCalendar")
        
        if imageAnchor.referenceImage.name == "choco" {
            // make the plane have a transparent blue color
            plane.firstMaterial?.diffuse.contents = myView
        } else {
            plane.firstMaterial?.diffuse.contents = UIImage(named:"notion")
        }
        

        // wrap the plane in a node and rotate it so it's facing us
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2

        // now wrap that in another node and send it back
        let node = SCNNode()
        node.addChildNode(planeNode)
        return node
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
