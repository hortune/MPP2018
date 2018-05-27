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
class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var score = 0
    var isPlaneSelected = false
    var changed = false
    var hoop: SCNNode?
    var ball: SCNNode?
    var anchors = [ARAnchor]()
    var isFalling = false
    
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
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        
        sceneView.scene.physicsWorld.contactDelegate = self
    }
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        if (contact.nodeA.name == "Net" || contact.nodeB.name == "Net") && !isFalling {
            isFalling = true
            score += 1
            DispatchQueue.main.async {
                self.title = "\(self.score)"
            }
            
        }
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
        
        sceneView.pointOfView?.addChildNode(ball!)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.vertical] //.horizontal
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


    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        if !changed {
            changed = true
            let planeNode = SCNNode()
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
            plane.firstMaterial?.lightingModel = .constant
            planeNode.geometry = plane
            print("Anchor",planeAnchor.transform.columns.3)
            planeNode.position = SCNVector3Make(planeAnchor.transform.columns.3.x, planeAnchor.transform.columns.3.y, planeAnchor.transform.columns.3.z);
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1.0, 0.0, 0.0);
            hoop?.worldPosition = planeNode.position
            let tangles = planeNode.eulerAngles
            hoop?.eulerAngles = SCNVector3(tangles.x + Float.pi/2,tangles.y,tangles.z)
            print("planeLoc",planeNode.position)
            node.addChildNode(planeNode)
            sceneView.scene.rootNode.addChildNode(hoop!)
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let arPlaneAnchor = anchor as? ARPlaneAnchor, let plane = node.childNodes.first, let planeGeometry = plane.geometry as? SCNPlane {

            // first, we update the extent of the plane, because it might have changed
            planeGeometry.width = CGFloat(arPlaneAnchor.extent.x)
            planeGeometry.height = CGFloat(arPlaneAnchor.extent.z)

            // now we should update the position (remember the transform applied)
            
            // I don't know why
            // 因為plane的父節點是anchor
            // 而hoop的父節點是real world
            plane.position = SCNVector3(arPlaneAnchor.center.x, arPlaneAnchor.center.y, arPlaneAnchor.center.z)
            hoop?.worldPosition = plane.worldPosition
            let tangles = plane.eulerAngles
            hoop?.eulerAngles = SCNVector3(tangles.x + Float.pi/2,tangles.y,tangles.z)

        }
    }
    
    @IBAction func pressDown(_ sender: UIButton) {
//        ball?.position = SCNVector3(0,-0.03,-0.5)
    }
    
    @IBAction func fire(_ sender: UIButton) {
        ball?.position = SCNVector3(0,-0.03,-0.15)
        ball?.physicsBody = SCNPhysicsBody.dynamic()
        ball?.physicsBody?.categoryBitMask = CollisionMask.ball.rawValue
        ball?.physicsBody?.collisionBitMask = CollisionMask.board.rawValue | CollisionMask.ring.rawValue
        ball?.physicsBody?.contactTestBitMask = CollisionMask.net.rawValue
        
        // so what is fucking transform ...
        let qq  = sceneView?.pointOfView?.transform
        isFalling = false
        ball?.physicsBody?.applyForce(SCNVector3(-6*qq!.m31,-9*qq!.m32,-6*qq!.m33), asImpulse:true)
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
