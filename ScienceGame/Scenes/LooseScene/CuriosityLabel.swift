//
//  CuriosityLabel.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 12/05/23.
//

import Foundation
import SpriteKit

class CuriosityLabel : SKNode {
    var text : SKLabelNode
    var background : SKSpriteNode
    
    init(text: String) {
        self.text = SKLabelNode(text: text)
        self.background = SKSpriteNode(imageNamed: "curiosity.png")
        
        super.init()
        
        self.text.fontName = "PatrickHandSC-Regular"
        self.text.fontColor = .black
        self.text.preferredMaxLayoutWidth = self.background.size.width - 50
        self.text.lineBreakMode = .byWordWrapping
        self.text.numberOfLines = .max
        self.text.fontSize = 20
        self.text.verticalAlignmentMode = .center
        
        self.background.zPosition -= 1
        
        self.addChild(self.background)
        self.addChild(self.text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
