//
//  FallingBodyNode.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 05/05/23.
//

import Foundation
import SpriteKit

class FallingBodyNode : SKNode {
    var shape : SKSpriteNode
    var fire : SKSpriteNode
    
    override init() {
        self.shape = SKSpriteNode(imageNamed: "foguete.png")
        shape.zPosition = 1
        
        self.fire = SKSpriteNode(imageNamed: "fogo.png")
        self.fire.zPosition = -2
        self.shape.addChild(self.fire)
        super.init()
        
        self.fire.position.y -= self.shape.size.height/2 - self.fire.size.height
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.shape.size)
        self.physicsBody?.velocity = .init(dx: 0, dy: 10)
        self.physicsBody?.mass = 20
        
        self.physicsBody?.categoryBitMask = .player
        self.physicsBody?.contactTestBitMask = .enemy
        self.physicsBody?.collisionBitMask = .contactWithAllCategories()
        
        self.addChild(self.shape)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func releaseFire() {
        let releaseFire = SKAction.moveTo(y: self.shape.position.y - self.shape.size.height/2 - self.fire.size.height/2, duration: 0.4)
        let recoilFire = SKAction.moveTo(y: self.shape.position.y, duration: 0.4)
        
        self.fire.run(.sequence([
            releaseFire,
            recoilFire
        ]))
    }
}
