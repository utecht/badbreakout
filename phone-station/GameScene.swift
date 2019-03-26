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
    private var paddle: SKSpriteNode?
    private var ball: SKSpriteNode?
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = borderBody
        
        self.paddle = self.childNode(withName: "//paddle") as? SKSpriteNode
        self.ball = self.childNode(withName: "//ball") as? SKSpriteNode
        if let ball = self.ball {
            ball.physicsBody!.applyImpulse(CGVector(dx: 2, dy: -2))
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

}
