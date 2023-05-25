//
//  PressureScene.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 08/05/23.
//

import Foundation
import CoreMotion
import SpriteKit

class ShakeScene : SKScene, MinigameProtocol {
    var lives: Int?
    var win: Bool?
    var pontuation: Int?
    var time: Double = 5
    var ID: Minigames? = .shake
    var curiosity: String = "NÃO SUBESTIME O PODER DA PRESSÃO! AO BALANÇAR UM O REFRIGERANTE O GÁS CARBÔNICO QUE ANTES ESTAVA DISSOLVIDO NO LÍQUIDO É LIBERADO EM FORMA DE GÁS SÓ QUE COM A GARRAFA FECHADA, OU SEJA, MUITA COISA OCUPADO UM ESPAÇO PEQUENO PRA ELA. ASSIM, A TENDÊNCIA É QUANDO ABRIR A GARRAFA SAIR TUDO DE UMA VEZ PARA EQUILIBRAR COM A PRESSÃO DA ATMOSFERA ACIMA DE NÓS (QUE NÃO É POUCA TAMBÉM)."
    
    let manager = CMMotionManager()
    var soda: SKSpriteNode?
    override func didMove(to view: SKView) {
        self.backgroundColor = .white
        let background = SKSpriteNode(imageNamed: "fundinho.png")
        background.zPosition = -5
        self.addChild(background)
        
        self.setupScene()
        
        self.run(.sequence([
            .run {
                self.showInstructions()
            },
            .wait(forDuration: 1.5),
            .run {
                self.setupTimer()
                self.run(.sequence([
                    .wait(forDuration: self.time + self.time/5),
                    .run {
                        self.looseNext()
                    }
                ]))
                self.manager.startAccelerometerUpdates()
            }
        ]))
    }
    
    func setupScene(){
        self.soda = SKSpriteNode(imageNamed: "coke.png")
        self.soda?.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.soda?.physicsBody?.affectedByGravity = false
        self.soda?.physicsBody?.velocity = .init(dx: 0, dy: 10)
        
        soda?.position -= .init(x: 0, y: self.size.height - 50)
        
        if let rectangle = self.soda {
            self.addChild(rectangle)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accData = manager.accelerometerData {
            if abs(accData.acceleration.x) > 1.5 || abs(accData.acceleration.y) > 1.5 || abs(accData.acceleration.z) > 1.5 {
                self.soda!.physicsBody?.velocity.dy *= 1.08
            }
        }
        
        if self.checkWinCondition() {
            self.winNext()
        }
        
    }
    
    func checkWinCondition() -> Bool {
        if let sodaPosition = self.soda?.position.y {
            if sodaPosition >= self.position.y {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func setupTimer() {
        let bomb = SKSpriteNode(imageNamed: "bomba.png")
        bomb.position = .init(x: -self.size.width/2 + bomb.size.width/2, y: -self.size.height/2 + bomb.size.height/2)
        bomb.zPosition = 10
        self.addChild(bomb)
        
        let timeInterval = self.time/5
        
        let timer = SKSpriteNode(imageNamed: "corda.png")
        timer.zPosition = 5
        
        let fogo = SKSpriteNode(imageNamed: "foguinho.png")
        fogo.position.x += timer.size.width/2
        timer.addChild(fogo)
        
        
        timer.position -= .init(x: 0, y: self.size.height/2 - bomb.size.height/2)
        self.addChild(timer)
        
        var actionArray : [SKAction] = []
        
        for _ in 0...4 {
            let waitTimer = SKAction.wait(forDuration: timeInterval)
            let action = SKAction.run {
                timer.position.x -= self.size.width/self.time
            }
            actionArray.append(waitTimer)
            actionArray.append(.playSoundFileNamed("clockTickFinal.wav", waitForCompletion: true))
            actionArray.append(action)

        }
        
        self.run(.sequence(actionArray))
    }
    
    func showInstructions() {
        let image = SKSpriteNode(imageNamed: "shake.png")
        let instruction = SKLabelNode(text: "BALANCE BALANCE")
        instruction.preferredMaxLayoutWidth = self.size.width
        
        instruction.fontColor = .black
        instruction.fontName = "PatrickHandSC-Regular"
        
        instruction.position += .init(x: 0, y: 80)
        image.position -= .init(x: 0, y: instruction.frame.height * 3.5)
        instruction.addChild(image)
        self.addChild(instruction)
        
        var actionSequence : [SKAction] = []
        
        for _ in 1...4 {
            actionSequence.append( .rotate(byAngle: CGFloat.pi/6, duration: 0.15))
            actionSequence.append( .rotate(byAngle: -CGFloat.pi/6, duration: 0.15))
        }
        
        image.run(.sequence([.sequence(actionSequence), .fadeOut(withDuration: 0.2), .removeFromParent(), .run {
            instruction.run(.sequence([.fadeOut(withDuration: 0.2), .removeFromParent()]))
        }]))
    }
    
    func winNext(){
        self.win = true
        self.pontuation! += 1
        
        let transition = SKTransition.push(with: .right, duration: 0.5)
        let newScene = TransitionScene()
        newScene.size = CGSize(width: self.size.width,
                               height: self.size.height )
        newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        newScene.scaleMode = .fill
        newScene.lastMinigame = self.ID
        newScene.pontuation = self.pontuation
        newScene.win = self.win
        newScene.lives = self.lives
        newScene.time = self.time - 0.2
        
        self.view?.presentScene(newScene, transition: transition)
    }
    
    func looseNext(){
        self.win = false
        self.lives! -= 1
        
        let transition = SKTransition.push(with: .right, duration: 0.5)
        let newScene = TransitionScene()
        newScene.size = CGSize(width: self.size.width ,
                               height: self.size.height)
        newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        newScene.scaleMode = .fill
        newScene.lastMinigame = self.ID
        newScene.pontuation = self.pontuation
        newScene.win = self.win
        newScene.lives = self.lives
        
        self.view?.presentScene(newScene, transition: transition)
    }
    
}

