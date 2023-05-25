//
//  TransitionScene.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 26/04/23.
//

import Foundation
import SpriteKit


class TransitionScene : SKScene {
    
    var pontuation : Int?
    var win : Bool?
    var lives : Int?
    
    var lastMinigame : Minigames? = nil
    var time: Double?
    var minigames : [MinigameProtocol] = [ElectronsScene(), EquilibriumScene(), InertiaScene(), ShakeScene()]
    
    
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .white
        let backgroundImage = SKSpriteNode(imageNamed: "fundinho.png")
        self.addChild(backgroundImage)
        
        let heartManager = HeartManager()
        heartManager.position.y -= heartManager.life1.container.size.height
        self.addChild(heartManager)
        heartManager.setupLives(lives: self.lives!, win: self.win ?? true)
        
        let score = ScoreNode()
        score.position = heartManager.position + .init(x: 0, y: score.pontuationFrame.size.height + 5)
        self.addChild(score)
        score.setPontuation(pontuation: self.pontuation!, win: self.win ?? true)
        
        let pontuationLabel = SKLabelNode(text: "PONTUAÇÃO")
        pontuationLabel.fontName = "PatrickHandSC-Regular"
        pontuationLabel.fontSize = 53
        pontuationLabel.fontColor = .black
        pontuationLabel.position.y = score.position.y + score.pontuationFrame.size.height/2 + 22
        self.addChild(pontuationLabel)

        
        if let livesNow = self.lives {
            //Aqui é onde rola a animação caso ele ainda tenha vidas
            if livesNow > 0 {
                self.run(.sequence([
                    .wait(forDuration: 1.5),
                    .run {[weak self] in
                        let transition = SKTransition.push(with: .left, duration: 0.5)
 
                        let newScene = self?.minigames.filter({$0.ID != self?.lastMinigame}).randomElement() as! SKScene //Pega um minigame diferente do último
                        newScene.size = CGSize(width: self?.size.width ?? 0,
                                               height: self?.size.height ?? 0)
                        newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                        newScene.scaleMode = .fill
                        
                        var refScene = newScene as! MinigameProtocol
                        
                        refScene.pontuation = self?.pontuation
                        refScene.lives = self?.lives
                        if let time = self?.time {
                            refScene.time = time
                        }
                        
                        
                        self?.view?.presentScene(newScene, transition: transition)
                    }
                ]))
            } else {
                //Aqui é a animação caso as vidas zeraram
                self.run(.sequence([
                    .wait(forDuration: 1.5),
                    .run {[weak self] in
                        let transition = SKTransition.push(with: .left, duration: 0.5)
                        let newScene = LooseScene()
                        newScene.size = CGSize(width: self?.size.width ?? 0,
                                               height: self?.size.height ?? 0)
                        newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                        newScene.scaleMode = .fill
                        
                        newScene.pontuation = self?.pontuation
                        newScene.looseMinigame = self?.lastMinigame
                        
                        self?.view?.presentScene(newScene, transition: transition)
                    }
                ]))
            }
        }
        
        
    }
}
