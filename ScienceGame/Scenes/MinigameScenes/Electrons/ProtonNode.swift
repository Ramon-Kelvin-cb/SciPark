//
//  ElectronNode.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 03/05/23.
//

import Foundation
import SpriteKit

class ProtonNode : SKNode {
    var shape : SKSpriteNode
    
    override init() {
        
        self.shape = SKSpriteNode(imageNamed: "proton.png")
        super.init()
        
        self.isUserInteractionEnabled = true
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.shape.size.width/2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = .player
        self.physicsBody?.contactTestBitMask = .enemy
        self.physicsBody?.collisionBitMask = ~(.contactWithAllCategories())
        
        
        self.addChild(self.shape)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in:self.scene!){
            self.run(.move(to: location, duration: 0.05))
        }
    }
}
