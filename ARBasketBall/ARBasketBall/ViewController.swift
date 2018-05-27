//
//  ViewController.swift
//  ARBasketBall
//
//  Created by hortune on 2018/5/26.
//  Copyright © 2018年 hortune. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
enum CollisionMask: Int {
    case ball = 1
    case board = 2
    case net = 4
    case ring = 8
}
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var score = 0
    var isPlaneSelected = false
    var changed = false
    var hoop: SCNNode?
    var ball: SCNNode?
    var anchors = [ARAnchor]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initSceneView()
        loadNodeObject()
        self.title = "\(score)"
    }
    
    func initSceneView(){
        sceneView.delegate = self
        
        sceneView.showsStatistics = true
        
        sceneView.scene = SCNScene()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    func loadNodeObject(){
        let tmpscene = SCNScene(named: "model/basketball_hoop.scn")!
        
        hoop = tmpscene.rootNode.childNode(withName:"Hoop", recursively: true)!
        hoop?.scale = SCNVector3(x: 0.00005, y: 0.00005, z: 0.00005)
        
        let ring = hoop?.childNode(withName: "Ring", recursively: true)
        let ringShape = SCNPhysicsShape(geometry: (ring?.geometry)!, options: [.type: SCNPhysicsShape.ShapeType.concavePolyhedron, .scale: SCNVector3(x: 0.1, y: 0.1, z: 0.1)])
        
        ring?.physicsBody? = SCNPhysicsBody(type: .kinematic, shape: ringShape)
        ring?.physicsBody?.categoryBitMask = CollisionMask.ring.rawValue
        
        
        let net = hoop?.childNode(withName: "Net", recursively: true)
        
        net?.physicsBody? = SCNPhysicsBody.kinematic()
        net?.physicsBody?.categoryBitMask = CollisionMask.net.rawValue
        net?.physicsBody?.collisionBitMask = 0
        net?.physicsBody?.contactTestBitMask = CollisionMask.ball.rawValue
        
        let board = hoop?.childNode(withName: "Board", recursively: true)
        board?.physicsBody? = SCNPhysicsBody.kinematic()
        board?.physicsBody?.categoryBitMask = CollisionMask.board.rawValue
        
        
        let basketballScene = SCNScene(named: "model/basketball.scn")
        ball = basketballScene?.rootNode.childNode(withName: "Ball", recursively: true)
        ball?.scale = SCNVector3(0.001,0.001,0.001)
        ball?.physicsBody?.type = .kinematic
        ball?.position = SCNVector3(0,-0.03,-0.15)
    }
    
//    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
//        if (contact.nodeA.name == "Net" || contact.nodeB.name == "Net") && !isFalling {
//            isFalling = true
//            score += 1
//            DispatchQueue.main.async {
//                self.title = "\(self.score)"
//            }
//
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.vertical,.horizontal] //.horizontal
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        let node = SCNNode()
//
//        return node
//    }
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        // 1
//        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
//
//        // 2
//        let width = CGFloat(planeAnchor.extent.x)
//        let height = CGFloat(planeAnchor.extent.z)
//        let plane = SCNPlane(width: width, height: height)
//
//        // 3
//        plane.materials.first?.diffuse.contents = UIColor.lightGray
//
//        // 4
//        let planeNode = SCNNode(geometry: plane)
//
//        // 5
//        let x = CGFloat(planeAnchor.center.x)
//        let y = CGFloat(planeAnchor.center.y)
//        let z = CGFloat(planeAnchor.center.z)
//        planeNode.position = SCNVector3(x,y,z)
//        planeNode.eulerAngles.x = -.pi / 2
//
//        // 6
//        node.addChildNode(planeNode)
//    } // 每次有新anchor 就會call這個

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        let planeNode = SCNNode()
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
        plane.firstMaterial?.lightingModel = .constant
        planeNode.geometry = plane
        print("Anchor",planeAnchor.transform.columns.3)
        planeNode.position = SCNVector3Make(planeAnchor.transform.columns.3.x, planeAnchor.transform.columns.3.y, planeAnchor.transform.columns.3.z);
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1.0, 0.0, 0.0);
        hoop?.position = planeNode.position
        print("planeLoc",planeNode.position)
        node.addChildNode(planeNode)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let arPlaneAnchor = anchor as? ARPlaneAnchor, let plane = node.childNodes.first, let planeGeometry = plane.geometry as? SCNPlane {

            // first, we update the extent of the plane, because it might have changed
            planeGeometry.width = CGFloat(arPlaneAnchor.extent.x)
            planeGeometry.height = CGFloat(arPlaneAnchor.extent.z)

            // now we should update the position (remember the transform applied)
            plane.position = SCNVector3(arPlaneAnchor.transform.columns.3.x, arPlaneAnchor.transform.columns.3.y, arPlaneAnchor.transform.columns.3.z)
            hoop?.position = plane.position
            print("planeLoc",plane.position)
            if !changed {
                changed = true
                sceneView.scene.rootNode.addChildNode(hoop!)
            }
        }
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("1111")
//        let touch = touches.first!
//        let location = touch.location(in: sceneView)
//        print(isPlaneSelected)
//        if !isPlaneSelected {
//            selectExistingPlane(location: location)
//        } else {
//            addNodeAtLocation(location: location)
//        }
//    }
//
//
//
//    func selectExistingPlane(location: CGPoint) {
//        // Hit test result from intersecting with an existing plane anchor, taking into account the plane’s extent.
//        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
//        print(hitResults)
//        print(location)
//        if hitResults.count > 0 {
//            let result: ARHitTestResult = hitResults.first!
//            if let planeAnchor = result.anchor as? ARPlaneAnchor {
//                // keep track of selected anchor only
//                anchors = [planeAnchor]
//                // set isPlaneSelected to true
//                isPlaneSelected = true
//            }
//        }
//    }
//
//    func addNodeAtLocation(location: CGPoint) {
//        guard anchors.count > 0 else {
//            print("anchors are not created yet")
//            return
//        }
//
//        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
//        if hitResults.count > 0 {
//            let result: ARHitTestResult = hitResults.first!
//            let newLocation = SCNVector3Make(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y/2, result.worldTransform.columns.3.z)
////            let newhoop = hoop?.clone()
//            let qq = anchors[0] as? ARPlaneAnchor
//            print("origin location",location)
//            print("new location",newLocation)
//            print("anchor center",qq!.center)
//            if !changed{
//                changed = true
//                hoop!.position = newLocation
//                sceneView.scene.rootNode.addChildNode(hoop!)
//            }
//        }
//    }
    
    
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
