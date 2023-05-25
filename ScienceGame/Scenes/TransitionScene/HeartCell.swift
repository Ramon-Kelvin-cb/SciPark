//
//  HeartCell.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 11/05/23.
//

import Foundation
import SpriteKit
import AudioToolbox

class HeartCell : SKNode {
    var container : SKSpriteNode
    var heratCell : SKSpriteNode
    
    override init() {
        self.container = SKSpriteNode(imageNamed: "heartFrame.png")
        self.heratCell = SKSpriteNode(imageNamed: "heartCell.png")
        self.heratCell.position += .init(x: 0, y: 3)
        
        self.container.addChild(self.heratCell)
        
        super.init()
        
        self.shakeHeart()
        self.addChild(container)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shakeHeart() {
        var actionSequence : [SKAction] = []
        
        actionSequence.append( .rotate(byAngle: CGFloat.pi/16, duration: 0.17))
        actionSequence.append( .rotate(byAngle: -CGFloat.pi/8, duration: 0.35))
        actionSequence.append( .rotate(byAngle: CGFloat.pi/16, duration: 0.17))
        
        self.heratCell.run(.repeatForever(.sequence(actionSequence)), withKey: "shaking")
    }
    
    func looseLife() {
        let dropHeart = SKAction.moveBy(x: 0, y: -((self.scene?.size.height)!/2 + self.heratCell.size.height/2) , duration: 0.8)
        self.heratCell.run(.sequence([.playSoundFileNamed("thump.mp3", waitForCompletion: false),.run {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        } ,dropHeart , .removeFromParent()]))
    }
    

}
