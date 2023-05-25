//
//  EquilibriumScene.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 06/05/23.
//

import Foundation
import SpriteKit
import CoreMotion

class EquilibriumScene : SKScene, MinigameProtocol {
    var lives: Int?
    var win: Bool?
    var pontuation: Int?
    var time: Double = 5
    var ID: Minigames? = .equilibrium
    var curiosity: String = "EQUILÍBRIO NÃO É SÓ O QUE ACROBATAS FAZEM NO CIRCO. FÍSICAMENTE FALANDO, UM CORPO ESTÁ EM EQUILÍBRIO QUANDO A SOMA DAS FORÇAS NELE É ZERO. PARECE ALGO QUE SÓ USAM NO CIRCO, MAS É UM PRINCÍPIO UTILIZADO EM TODOS OS LUGARES, DESDE MEDIR MASSAS COM AS BALANÇAS ATÉ CONSTRUIR PRÉDIOS E PONTES SEM DEPENDER SÓ DA RESISTÊNCIA DOS MATERIAIS DOS MESMOS, MAS COMPENSANDO O PESO COM OUTRAS FORÇAS."
    
    let manager = CMMotionManager()
    var ball = SKSpriteNode(imageNamed: "ball.png")
        
    override func didMove(to view: SKView) {
        
        self.backgroundColor = .white
        let background = SKSpriteNode(imageNamed: "fundinho.png")
        background.zPosition = -1
        background.addChild(SKSpriteNode(imageNamed: "boundary.png"))
        self.addChild(background)
        
        self.run(.sequence([
            .run {
                self.showInstructions()
            },
            .wait(forDuration: 1.8),
            .run {
                self.setupTimer()
                
                self.run(.sequence([
                    .wait(forDuration: self.time + self.time/5),
                    .run {
                        self.winNext()
                    }
                ]))
                
                self.setupScene()
            },
            .run {
                self.manager.startAccelerometerUpdates()
            }
        ]))
        

        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accData = manager.accelerometerData {
            physicsWorld.gravity = .init(dx: accData.acceleration.x * 7.5, dy: accData.acceleration.y * 7.5)
        }
        
        if self.checkLooseCondition() {
            looseNext()
        }
        
    }
    
    func showInstructions() {
        let image = SKSpriteNode(imageNamed: "equilibrium.png")
        let instruction = SKLabelNode(text: "DEITE O TELEFONE")
        
        instruction.fontColor = .black
        instruction.fontName = "PatrickHandSC-Regular"
        instruction.position += .init(x: 0, y: 50)
        image.position -= .init(x: 0, y: instruction.frame.height * 3.5 + 40)
        instruction.addChild(image)
        self.addChild(instruction)
        
        var actionSequence : [SKAction] = []
        
        actionSequence.append(.scaleX(to: 0.6, duration: 0.4))
        actionSequence.append(.scaleX(to: 1, duration: 0.4))
        actionSequence.append(.scaleY(to: 0.6, duration: 0.4))
        actionSequence.append(.scaleY(to: 1, duration: 0.4))
        
        image.run(.sequence([.sequence(actionSequence), .fadeOut(withDuration: 0.2), .removeFromParent(), .run {
            instruction.run(.sequence([.fadeOut(withDuration: 0.2), .removeFromParent()]))
        }]))
    }
    
    func setupScene(){
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = .enemy
        self.physicsBody?.collisionBitMask = .contactWithAllCategories(less: [.player])
                
        self.ball.physicsBody = SKPhysicsBody(circleOfRadius: self.ball.size.width/2)
        self.ball.physicsBody?.collisionBitMask = .contactWithAllCategories(less: [.enemy])
        self.ball.physicsBody?.velocity = .init(dx: .random(in: -1...1) * 180, dy: .random(in: -1...1) * 180)
        self.addChild(self.ball)
    }
    
    func checkLooseCondition() -> Bool {
        if self.ball.position.x > self.frame.width/2 ||
            self.ball.position.x < -self.frame.width/2 ||
            self.ball.position.y > self.frame.height/2 ||
            self.ball.position.y < -self.frame.height/2
        {
            return true
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


