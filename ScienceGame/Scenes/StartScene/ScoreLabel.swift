//
//  ScoreLabel.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 11/05/23.
//

import Foundation
import SpriteKit

class ScoreLabel : SKNode {
    var pontuation : Int
    var image : SKSpriteNode
    
    init(pontuation : Int, imageNamed: String) {
        self.pontuation = pontuation
        self.image = SKSpriteNode(imageNamed: imageNamed)
        super.init()
        
        let textLabel = SKLabelNode(text:"\(self.pontuation)")
        textLabel.fontName =  "PatrickHandSC-Regular"
        textLabel.fontSize = 90
        textLabel.fontColor = .black
        textLabel.horizontalAlignmentMode = .center
        textLabel.verticalAlignmentMode = .center
        
        textLabel.position -= .init(x: 10, y: 10)
        
        self.image.addChild(textLabel)
        
        self.addChild(self.image)
        self.runAnimation()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func runAnimation() {
        var actionSequence : [SKAction] = []
        
        actionSequence.append( .rotate(byAngle: -CGFloat.pi/60, duration: 0.17))
        actionSequence.append( .rotate(byAngle: CGFloat.pi/30, duration: 0.35))
        actionSequence.append( .rotate(byAngle: -CGFloat.pi/60, duration: 0.17))
        
        let finalAction = SKAction.repeatForever(.sequence(actionSequence))
        self.run(finalAction)
    }
}
