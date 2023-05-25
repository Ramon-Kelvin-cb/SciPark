//
//  LooseScene.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 27/04/23.
//

import Foundation
import SpriteKit

class LooseScene : SKScene {
    
    var pontuation : Int?
    var looseMinigame : Minigames?
    
    let userDefaults = UserDefaults.standard
    var minigames : [MinigameProtocol] = [ ElectronsScene(), InertiaScene(), EquilibriumScene(), ShakeScene()]
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .white
        let backgroundImage = SKSpriteNode(imageNamed: "fundinho.png")
        self.addChild(backgroundImage)
        
        
        if let highScore = userDefaults.value(forKey: "highScore") as! Int? { //Returns the integer value associated with the specified key.
            if self.pontuation! > highScore {
                userDefaults.set(self.pontuation, forKey: "highScore")
            }
                //do something here when a highscore exists
            } else {
                userDefaults.set(self.pontuation, forKey: "highScore")
        }
        
        let restartButton = ButtonNode(imageNamed: "beginAgain.png",text: "RECOMEÇAR" ,clickAction: {[weak self] in
            let transition = SKTransition.push(with: .left, duration: 0.5)
            let newScene = TransitionScene()
            newScene.size = CGSize(width: self?.size.width ?? 0,
                                   height: self?.size.height ?? 0)
            newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            newScene.scaleMode = .fill
            
            newScene.pontuation = 0
            newScene.lives = 3
            
            self?.view?.presentScene(newScene, transition: transition)
        })
        
        let homeButton = ButtonNode(imageNamed: "home.png",text: "INÍCIO" ,clickAction: {[weak self] in
            let transition = SKTransition.push(with: .left, duration: 0.5)
            let newScene = StartScene()
            newScene.size = CGSize(width: self?.size.width ?? 0,
                                   height: self?.size.height ?? 0)
            newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            newScene.scaleMode = .fill
            
            self?.view?.presentScene(newScene, transition: transition)
        })
        
        restartButton.position.y -= 230
        homeButton.position.y = restartButton.position.y - homeButton.image.size.height + 5
        
        restartButton.text.fontSize = 50
        restartButton.text.position.y -= 5
        homeButton.text.fontSize = 50
        homeButton.text.position.y += 3
        
        let score = ScoreLabel(pontuation: self.pontuation!, imageNamed: "backgroudHighscore.png")
        score.zPosition += 10
        score.setScale(0.67)
        
        let curiosityText = self.getLooseMinigameCuriosity(minigames: self.minigames, looseMinigame: self.looseMinigame ?? .shake)
        
        let curiosity = CuriosityLabel(text: curiosityText)
        curiosity.zPosition = score.zPosition - 1
        curiosity.position.y = restartButton.position.y + curiosity.background.size.height/2 + 45
        self.addChild(curiosity)
    
        score.position.y = self.size.height/2 - score.image.size.height/2 - 20
        
        
        self.addChild(score)
        self.addChild(restartButton)
        self.addChild(homeButton)
    }
    
    func getLooseMinigameCuriosity(minigames : [MinigameProtocol], looseMinigame : Minigames) -> String{
        return minigames.filter({$0.ID == looseMinigame})[0].curiosity
    }
}
