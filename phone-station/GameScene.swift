//
//  GameScene.swift
//  phone-station
//
//  Created by Joseph Utecht on 3/25/19.
//  Copyright © 2019 9volt. All rights reserved.
//

import SpriteKit
import GameplayKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var paddle: SKSpriteNode?
    private var ball: SKSpriteNode?
    private var block_texture: SKTexture?
    private var broken_texture: SKTexture?
    
    let block_width = 40
    let block_height = 20
    let block_rows = 5
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        self.physicsBody = borderBody
        
        self.block_texture = SKTexture.init(imageNamed: "block")
        self.broken_texture = SKTexture.init(imageNamed: "broken_block")

        if let starter = self.childNode(withName: "//start_blocks") {
            let num_wide = (Int(self.frame.width) / block_width) - 2
            for row in 0...block_rows {
                for col in 0...num_wide {
                    let offset = row % 2 == 0 ? block_width / 2 : block_width
                    let x = CGFloat((col * block_width) + offset) + starter.position.x
                    let y = starter.position.y - CGFloat(block_height * row)
                    let size = CGSize(width: block_width, height: block_height)
                    let block = SKSpriteNode(color: UIColor.random(), size: size)
                    block.texture = block_texture
                    block.colorBlendFactor = 1.0
                    block.position = CGPoint(x: x, y: y)
                    block.physicsBody = SKPhysicsBody(rectangleOf: size)
                    block.physicsBody?.isDynamic = false
                    block.physicsBody?.collisionBitMask = 1
                    block.name = "block"
                    block.userData = NSMutableDictionary()
                    block.userData?.setValue(1, forKey: "health")
                    self.addChild(block)
                }
            }
        }
        
        self.paddle = self.childNode(withName: "//paddle") as? SKSpriteNode
        self.ball = self.childNode(withName: "//ball") as? SKSpriteNode
        if let ball = self.ball {
            ball.physicsBody!.applyImpulse(CGVector(dx: 500, dy: -500))
        }
    }
    
    
    func movePaddle(towards pos : CGPoint) {
        if let paddle = self.paddle {
            paddle.run(SKAction.moveTo(x: pos.x, duration: 0.1))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.movePaddle(towards: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.movePaddle(towards: t.location(in: self)) }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.movePaddle(towards: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.movePaddle(towards: t.location(in: self)) }
    }
    
    func checkBlock(_ blockNode: SKNode){
        if blockNode.name == "damaged_block" {
            blockNode.removeFromParent()
        }
        
        if blockNode.name == "block" {
            if let block = blockNode as? SKSpriteNode {
                block.texture = broken_texture
            }
            blockNode.name = "damaged_block"
        }
    }

    func didBegin(_ contact: SKPhysicsContact){
        if let a = contact.bodyA.node {
            checkBlock(a)
        }
        if let b = contact.bodyB.node {
            checkBlock(b)
        }
    }
}
