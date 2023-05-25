//
//  ElectronNode.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 03/05/23.
//

import Foundation
import SpriteKit

class ElectronNode : SKNode {
    var shape : SKSpriteNode
    
    override init() {
        self.shape = SKSpriteNode(imageNamed: "eletron.png")
        super.init()
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.shape.size.width/2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = .enemy
        self.physicsBody?.contactTestBitMask = .player
        self.physicsBody?.collisionBitMask = ~(.contactWithAllCategories())
        
        self.addChild(self.shape)
        
        self.waveMove()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func waveMove() {
        let start = SKAction.moveBy(x: 15, y: 0, duration: 0.25)
        let back = SKAction.moveBy(x: -30, y: 0, duration: 0.5)
        
        let oscilationSequence = [start, back, start]
        
        self.run(.repeatForever(.sequence(oscilationSequence)))
    }
}
