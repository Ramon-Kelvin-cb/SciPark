//
//  StartScene.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 26/04/23.
//

import Foundation
import SpriteKit

class StartScene : SKScene {
    
    let userDefaults = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        
        
        self.backgroundColor = .white
        let backgroundImage = SKSpriteNode(imageNamed: "fundinho.png")
        self.addChild(backgroundImage)
        
        
        let start = ButtonNode(imageNamed: "backgroundStart.png",text: "COMEÇAR" ,clickAction: {[weak self] in
            let transition = SKTransition.push(with: .left, duration: 0.5)
            let newScene = TransitionScene()
            newScene.size = CGSize(width: self?.size.width ?? 0,
                                   height: self?.size.height ?? 0)
            newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            newScene.scaleMode = .fill
            
            newScene.pontuation = 0
            newScene.lives = 3
            newScene.time = 5
            
            self?.view?.presentScene(newScene, transition: transition)
        })
        start.position.y -= 120
        start.text.fontSize = 55
        start.text.position.y -= 5
        
        let pontuation = ScoreLabel(pontuation: self.showHighScore(), imageNamed: "backgroudHighscore.png" )
        pontuation.position = start.position + .init(x: 0, y: pontuation.image.size.height - 40)
        self.addChild(pontuation)
        
        var actionSequence : [SKAction] = []
        
        actionSequence.append( .rotate(byAngle: CGFloat.pi/60, duration: 0.17))
        actionSequence.append( .rotate(byAngle: -CGFloat.pi/30, duration: 0.35))
        actionSequence.append( .rotate(byAngle: CGFloat.pi/60, duration: 0.17))
        
        let finalAction = SKAction.repeatForever(.sequence(actionSequence))
        
        self.addChild(start)
        start.animate(action: finalAction)
    }
    
    func showHighScore() -> Int{
        if let highScore = userDefaults.value(forKey: "highScore") as! Int?{
            return highScore
        } else {
            userDefaults.set(0, forKey: "highScore")
            return 0
        }
    }
    
}
