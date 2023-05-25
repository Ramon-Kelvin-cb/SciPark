//
//  InertiaScene.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 05/05/23.
//

import Foundation
import SpriteKit
import AudioToolbox

class InertiaScene : SKScene, MinigameProtocol {
    var lives: Int?
    var win: Bool?
    var pontuation: Int?
    var time: Double = 5
    var ID: Minigames? = .inertia
    
    
    
    var curiosity: String = "VOCÊ SABE O QUE É A INÉRCIA? É A PROPRIEDADE DA MATÉRIA DE BASICAMENTE CONTINUAR SE MEXENDO OU CONTINUAR PARADA DESDE QUE NÃO SE MEXA COM ELA. OU SEJA, O QUE TÁ PARADO FICA PARADO E O QUE TÁ SE MEXENDO CONTINUA EM MOVIMENTO. POR INCRÍVEL QUE PAREÇA, QUEBRAR A INÉRCIA GASTA ENERGIA DEMAIS, UM ÔNIBUS ESPACIAL POR EXEMPLO GASTA 3 MILHÕES DE LITROS DE COMBUSTÍVEL PARA QUEBRAR A INÉRCIA E VIAJAR PELO ESPAÇO!"
    
    let force = 2200
    
    let swipeUpRec: UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    let swipeDownRec: UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    
    var fallingBody = FallingBodyNode()
    var velocityLabel = SKLabelNode(text: "")
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .white
        let background = SKSpriteNode(imageNamed: "fundinho.png")
        background.zPosition = -1
        self.addChild(background)
        
        self.run(.sequence([
            .run {
                self.showInstructions()
            },
            .wait(forDuration: 1.6),
            .run {
                self.setupTimer()
                
                self.run(.sequence([
                    .wait(forDuration: self.time + self.time/5),
                    .run {
                        self.looseNext()
                    }
                ])) //Timer até acabae o tempo do minigame
                
                self.setupSwipes()
                self.setupScene()
                
                self.physicsWorld.gravity = .init(dx: 0, dy: -1.62)
            }
        ]))
        

        self.physicsWorld.contactDelegate = self
    }
    
    
    func setupSwipes() {
        swipeUpRec.addTarget(self, action: #selector(InertiaScene.swipedUp))
        swipeUpRec.direction = .up
        self.view?.addGestureRecognizer(swipeUpRec)
        
        swipeDownRec.addTarget(self, action: #selector(InertiaScene.swipedDown))
        swipeDownRec.direction = .down
        self.view?.addGestureRecognizer(swipeDownRec)
    }
    
    func showInstructions(){
        let image = SKSpriteNode(imageNamed: "inertia.png")
        let instruction = SKLabelNode(text: "DECOLE COM O SWIPE!")
        instruction.fontColor = .black
        instruction.fontName = "PatrickHandSC-Regular"
        
        instruction.preferredMaxLayoutWidth = self.size.width - 200
        instruction.position += .init(x: 0, y: 80)
        image.position -= .init(x: 0, y: image.frame.height * 2)
        instruction.addChild(image)
        self.addChild(instruction)
        
        var actionSequence : [SKAction] = []
        
        actionSequence.append(.move(by: .init(dx: 0, dy: 170), duration: 0.2))
        actionSequence.append(.move(by: .init(dx: 0, dy: -170), duration: 0.8))
        actionSequence.append(.move(by: .init(dx: 0, dy: 170), duration: 0.2))
        
        image.run(.sequence([.sequence(actionSequence), .fadeOut(withDuration: 0.2), .removeFromParent(), .run {
            instruction.run(.sequence([.fadeOut(withDuration: 0.2), .removeFromParent()]))
        }]))
    }
    
    //Aqui eu coloco o que acontece quando dá o swipe
    func setupScene(){
        let floor = FloorNode()
        floor.position -= .init(x: 0, y: self.size.height/2 - 60)
        self.addChild(floor)
        floor.setup()
        
        self.fallingBody.position.y = floor.position.y + 100
        self.fallingBody.zPosition += 5
        
        self.addChild(self.fallingBody)
    }
    
    @objc func swipedUp() {
        self.fallingBody.physicsBody?.applyImpulse(.init(dx: 0, dy: self.force))
        self.fallingBody.releaseFire()
    }
    
    @objc func swipedDown() {
        self.fallingBody.physicsBody?.applyImpulse(.init(dx: 0, dy: -self.force))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if self.fallingBody.position.y >= self.size.height/2 + 200 {
            self.winNext()
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


extension InertiaScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == .player && contact.bodyB.categoryBitMask == .enemy){
            //            self.run(.sequence(<#T##actions: [SKAction]##[SKAction]#>)) -> Aqui vai o tempinho depois que perder e talvez a animação
        }
        if (contact.bodyA.categoryBitMask == .enemy && contact.bodyB.categoryBitMask == .player){
            
        }
        
        
    }
}
