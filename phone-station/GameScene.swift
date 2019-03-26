//
//  GameScene.swift
//  phone-station
//
//  Created by Joseph Utecht on 3/25/19.
//  Copyright © 2019 9volt. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var bouncingBox: SKShapeNode?
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        self.bouncingBox = self.childNode(withName: "//BouncingBox") as? SKShapeNode
        if let bouncingBox = self.bouncingBox {
            bouncingBox.physicsBody = SKPhysicsBody.init()
            if let physicsBody = bouncingBox.physicsBody {
                physicsBody.linearDamping = 0.9
                physicsBody.affectedByGravity = false
            }
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func addSquare(atPoint pos : CGPoint, color col : UIColor) {
        if let bouncingBox = self.bouncingBox {
            var dx = bouncingBox.position.x - pos.x
            var dy = bouncingBox.position.y - pos.y
            
            let magnitude = sqrt(dx*dx+dy*dy)
            dx /= magnitude
            dy /= magnitude
            
            if let speed = bouncingBox.userData?.value(forKey: "speed") as? CGFloat {
                dx *= -speed
                dy *= -speed
            }
            let force = CGVector(dx: dx, dy: dy)
            
            bouncingBox.run(SKAction.applyForce(force, duration: 1))
        }
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = col
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.addSquare(atPoint: t.location(in: self), color: SKColor.green) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.addSquare(atPoint: t.location(in: self), color: SKColor.blue) }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.addSquare(atPoint: t.location(in: self), color: SKColor.red) }

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.addSquare(atPoint: t.location(in: self), color: SKColor.red) }

    }
    
    /*
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    */
}
