//
//  MinigameOne.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 26/04/23.
//

import Foundation
import SpriteKit

class MinigameOne : SKScene {
    var pontuation : Int?
    var win : Bool?
    var lives : Int?
    
    
    override func didMove(to view: SKView) {
        let winButton = SKButtonNode(text: "Win", clickAction: {[weak self] in
            self?.win = true
            self?.pontuation! += 1
            
            let transition = SKTransition.push(with: .right, duration: 0.5)
            let newScene = TransitionScene()
            newScene.size = CGSize(width: self?.size.width ?? 0,
                                   height: self?.size.height ?? 0)
            newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            newScene.scaleMode = .fill
            
            newScene.pontuation = self?.pontuation
            newScene.win = self?.win
            newScene.lives = self?.lives
            
            self?.view?.presentScene(newScene, transition: transition)
        })
        let looseButton = SKButtonNode(text: "Loose", clickAction: {[weak self] in
            self?.win = false
            self?.lives! -= 1
            
            let transition = SKTransition.push(with: .right, duration: 0.5)
            let newScene = TransitionScene()
            newScene.size = CGSize(width: self?.size.width ?? 0,
                                   height: self?.size.height ?? 0)
            newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            newScene.scaleMode = .fill
            
            newScene.pontuation = self?.pontuation
            newScene.win = self?.win
            newScene.lives = self?.lives
            
            self?.view?.presentScene(newScene, transition: transition)
        })
        
        winButton.text.fontColor = .white
        winButton.text.fontSize = 30
        looseButton.text.fontColor = .white
        looseButton.text.fontSize = 30
        looseButton.position.y -= 25
        
        self.addChild(winButton)
        self.addChild(looseButton)
    }
    
}
