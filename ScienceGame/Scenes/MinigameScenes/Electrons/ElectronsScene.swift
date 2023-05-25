//
//  ElectronsScene.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 03/05/23.
//

import Foundation
import SpriteKit

class ElectronsScene : SKScene, MinigameProtocol {
    var pontuation : Int?
    var win : Bool?
    var lives : Int?
    var time: Double = 5
    
    var ID: Minigames? = .eletrons
    var curiosity: String = "ELÉTRONS E PRÓTONS SÃO PARTES FUNDAMENTAIS DOS ÁTOMOS, AS PEQUENAS PEÇAS QUE CONSTROEM TUDO QUE EXISTE. ELÉTRONS, QUE POSSUEM CARGA NEGATIVA E AQUI SÃO REPRESENTADOS PELAS BOLINHAS VERMELHAS, SE MOVEM MUITO E ISSO É O MOTIVO DE MUITA COISA: ELETRICIDADE, MAGNETISMO, LUZ E ATÉ MESMO TV'S DE TUBO, QUE POR ACASO SÃO MINI COLISORES DE PARTÍCULAS!"
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .white
        let background = SKSpriteNode(imageNamed: "fundinho.png")
        background.zPosition = -5
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
                ])) //Timer até acabae o tempo do minigame
                
                
                self.spawnElectrons()//Spawner de eletrons
                self.setupScene()
            }
        ]))
        self.physicsWorld.contactDelegate = self
    }
    
    func showInstructions(){
        let image = SKSpriteNode(imageNamed: "eletronInstruction.png")
        let instruction = SKLabelNode(text: "MOVA E DESVIE!")
        instruction.fontColor = .black
        instruction.fontName = "PatrickHandSC-Regular"
        image.position -= .init(x: 0, y: 140)
        instruction.position.y = image.position.y
        instruction.addChild(image)
        self.addChild(instruction)
        
        var actionSequence : [SKAction] = []
        
        actionSequence.append(.move(by: .init(dx: 40, dy: 0), duration: 0.4))
        actionSequence.append(.move(by: .init(dx: -80, dy: 0), duration: 0.8))
        actionSequence.append(.move(by: .init(dx: 40, dy: 0), duration: 0.4))
        
        image.run(.sequence([.sequence(actionSequence), .fadeOut(withDuration: 0.2), .removeFromParent(), .run {
            instruction.run(.sequence([.fadeOut(withDuration: 0.2), .removeFromParent()]))
        }]))
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
    
    func spawnElectrons() {
        self.run(.repeatForever(.sequence([
            .run {
                let electron = ElectronNode()
                electron.position += .init(x: .random(in: -(self.size.width)/2 + 50...(self.size.width)/2 - 40),
                                           y: (self.size.height)/2)
                self.addChild(electron)
                electron.run(.sequence([
                    .moveTo(y: -self.size.height/2, duration: 1),
                    .removeFromParent()
                ]))
            },
            .wait(forDuration: 0.45) //Tempo entre respawn de eletrons
        ])))
    }
    
    func setupScene() {
        let proton = ProtonNode()
        proton.position += .init(x: 0, y: -200)
        self.addChild(proton)
    }
}

extension ElectronsScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == .player && contact.bodyB.categoryBitMask == .enemy) ||
            (contact.bodyA.categoryBitMask == .enemy && contact.bodyB.categoryBitMask == .player) {
            self.looseNext()
        }
    }
}
