//
//  ViewController.swift
//  ARLiu
//
//  Created by Mac Mini Novo on 11/04/19.
//  Copyright © 2019 LiuVasconcelos. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MainViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var timerlabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score = 0
    var player: AVAudioPlayer?
    var seconds = 10
    var timer = Timer()
    var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        //set the physics delegate
        sceneView.scene.physicsWorld.contactDelegate = self
        
        self.addTargetNodes()
        self.playBackgroundMusic()
        self.runTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
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
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    @IBAction func clickOnAxeButton(_ sender: Any) {
        self.fireMissile(type: "axe")
    }
    
    @IBAction func clickOnBananaButton(_ sender: Any) {
        self.fireMissile(type: "banana")
    }
    
    func getUserVector() -> (SCNVector3, SCNVector3) { 
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform)
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43)
            
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    
    func createMissile(type : String)->SCNNode{
        var node = SCNNode()
        
        switch type {
        case "banana":
            let scene = SCNScene(named: "art.scnassets/Orange.dae")
            node = (scene?.rootNode.childNode(withName: "Orange", recursively: true)!)!
            node.scale = SCNVector3(0.15,0.15,0.15)
            node.name = "banana"
        case "axe":
            let scene = SCNScene(named: "art.scnassets/axe.dae")
            node = (scene?.rootNode.childNode(withName: "axe", recursively: true)!)!
            node.scale = SCNVector3(0.25,0.25,0.25)
            node.name = "axe"
        default:
            node = SCNNode()
        }
        
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        node.physicsBody?.isAffectedByGravity = false
        
        node.physicsBody?.categoryBitMask = CollisionCategory.missileCategory.rawValue
        node.physicsBody?.collisionBitMask = CollisionCategory.targetCategory.rawValue
        return node
    }
    
    func fireMissile(type : String){
        var node = SCNNode()
        node = createMissile(type: type)
        
        let (direction, position) = self.getUserVector()
        node.position = position
        var nodeDirection = SCNVector3()
        switch type {
        case "banana":
            nodeDirection  = SCNVector3(direction.x*4,direction.y*4,direction.z*4)
            node.physicsBody?.applyForce(nodeDirection, at: SCNVector3(0.1,0,0), asImpulse: true)
            playSound(sound: "noise", format: "mp3")
        case "axe":
            nodeDirection  = SCNVector3(direction.x*4,direction.y*4,direction.z*4)
            node.physicsBody?.applyForce(SCNVector3(direction.x,direction.y,direction.z), at: SCNVector3(0,0,0.1), asImpulse: true)
            playSound(sound: "bomb", format: "mp3")
        default:
            nodeDirection = direction
        }
        
        node.physicsBody?.applyForce(nodeDirection , asImpulse: true)
        
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func addTargetNodes(){
        for index in 1...100 {
            
            var node = SCNNode()
            
            if (index < 50) {
                let scene = SCNScene(named: "art.scnassets/mouthshark.dae")
                node = (scene?.rootNode.childNode(withName: "shark", recursively: true)!)!
                node.scale = SCNVector3(0.5,0.5,0.5)
                node.name = "spider"
            }else{
                let scene = SCNScene(named: "art.scnassets/Golden_Fish_DAE.DAE")
                node = (scene?.rootNode.childNode(withName: "Box01", recursively: true)!)!
                node.scale = SCNVector3(0.012, 0.012, 0.012)
                node.name = "cat"
            }
            
            node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            node.physicsBody?.isAffectedByGravity = false
            
            node.position = SCNVector3(randomFloat(min: -10, max: 10),randomFloat(min: -4, max: 5),randomFloat(min: -10, max: 10))
            
            let action : SCNAction = SCNAction.rotate(by: .pi, around: SCNVector3(0, 1, 0), duration: 1.0)
            let forever = SCNAction.repeatForever(action)
            node.runAction(forever)
            
            node.physicsBody?.categoryBitMask = CollisionCategory.targetCategory.rawValue
            node.physicsBody?.contactTestBitMask = CollisionCategory.missileCategory.rawValue
            
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        print("** Collision!! " + contact.nodeA.name! + " hit " + contact.nodeB.name!)
        
        if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.targetCategory.rawValue
            || contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.targetCategory.rawValue {
            
            if (contact.nodeA.name! == "cat" && contact.nodeB.name! == "banana") {
                score+=1
            } else if (contact.nodeA.name! == "spider" && contact.nodeB.name! == "axe"){
                score+=1
            } else {
                score-=1
            }
            
            DispatchQueue.main.async {
                contact.nodeA.removeFromParentNode()
                contact.nodeB.removeFromParentNode()
                self.scoreLabel.text = String(self.score)
            }
            playSound(sound: "explosion", format: "wav")
            
            let  explosion = SCNParticleSystem(named: "Explode", inDirectory: nil)
            contact.nodeB.addParticleSystem(explosion!)
        }
    }
    
    func playSound(sound: String, format: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: format) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playBackgroundMusic(){
        let audioNode = SCNNode()
        let audioSource = SCNAudioSource(fileNamed: "babyshark.mp3")!
        let audioPlayer = SCNAudioPlayer(source: audioSource)
        
        audioNode.addAudioPlayer(audioPlayer)
        
        let play = SCNAction.playAudio(audioSource, waitForCompletion: true)
        audioNode.runAction(play)
        sceneView.scene.rootNode.addChildNode(audioNode)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds == 0 {
            timer.invalidate()
            gameOver()
        }else{
            seconds -= 1
            timerlabel.text = "\(seconds)"
        }
        
    }
    
    func resetTimer(){
        timer.invalidate()
        seconds = 10
        timerlabel.text = "\(seconds)"
    }
    
    func gameOver(){
        if let score = scoreLabel.text {
            let alertController = UIAlertController(title: "", message: "Acabou jogo! Seu score foi: \(score)", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            
            let time = DispatchTime.now() + 3
            DispatchQueue.main.asyncAfter(deadline: time) {
                alertController.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}


struct CollisionCategory: OptionSet {
    let rawValue: Int
    
    static let missileCategory  = CollisionCategory(rawValue: 1 << 0)
    static let targetCategory = CollisionCategory(rawValue: 1 << 1)
    static let otherCategory = CollisionCategory(rawValue: 1 << 2)
}
