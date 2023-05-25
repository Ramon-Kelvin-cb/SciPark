//
//  FloorNode.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 05/05/23.
//

import Foundation
import SpriteKit

class FloorNode : SKNode {
    override init() {
        super.init()
    }
    
    func setup() {
        let shape = SKSpriteNode(imageNamed: "Lua.png")
        shape.zPosition = 0
        self.addChild(shape)
        self.physicsBody = SKPhysicsBody(rectangleOf: .init(width: (self.scene?.size.width)! - 20, height: 50))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = .enemy
        self.physicsBody?.contactTestBitMask = .player
        self.physicsBody?.collisionBitMask = .contactWithAllCategories()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
