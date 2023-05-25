//
//  MacrophageScene.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 04/05/23.
//

import Foundation
import SpriteKit

class MacrophageScene : SKScene, MinigameProtocol{
    var pontuation : Int?
    var win : Bool?
    var lives : Int?
    var time: Double = 5

    var ID: Minigames? = .macrophage
    var curiosity: String = ""
    
    var removedBodies : [SKNode?] = []
    var bodies : [ShipNode] = []
    
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
            .wait(forDuration: 1.8),
            .run {
                self.setupTimer()
            
                self.run(.sequence([
                    .wait(forDuration: self.time + self.time/5),
                    .run {
                        self.looseNext()
                    }
                ])) //Timer até acabae o tempo do minigame
                
                
            }
        ]))

        self.physicsWorld.contactDelegate = self
    }
    
    func showInstructions(){
        let image = SKSpriteNode(imageNamed: "macrophage.png")
        let instruction = SKLabelNode(text: "COLETE TODOS!")
        instruction.position += .init(x: 0, y: 50)
        image.position -= .init(x: 0, y: image.frame.height/2)
        instruction.addChild(image)
        self.addChild(instruction)
        
        var actionSequence : [SKAction] = []
        
        actionSequence.append(.move(by: .init(dx: 0, dy: -170), duration: 0.8))
        actionSequence.append(.move(by: .init(dx: -170, dy: 0), duration: 0.8))
        actionSequence.append(.move(by: .init(dx: 170, dy: 0), duration: 0.5))
        
        image.run(.sequence([.group(actionSequence),.group(actionSequence).reversed(), .fadeOut(withDuration: 0.2), .removeFromParent(), .run {
            instruction.run(.sequence([.fadeOut(withDuration: 0.2), .removeFromParent()]))
        }]))
    }
    
    override func update(_ currentTime: TimeInterval) {
        for body in bodies{
            body.edges(size: self.size)
            body.flock(bodies)
            body.updatePos()
        }
        
        if removedBodies.count == bodies.count { //Condição de vitória
            self.winNext()
        }
    }
    
    func setupScene() {
        for _ in 0...150{
            let body = ShipNode()
            body.position = .init(x: CGFloat.random(in: -self.size.width/2...self.size.width/2), y: CGFloat.random(in: -self.size.height/2...self.size.height/2))
            self.bodies.append(body)
            self.addChild(body)
        }
        
        let macrophage = MacrophageNode()
        macrophage.position += .init(x: 0, y: -200)
        self.addChild(macrophage)
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

extension MacrophageScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == .player && contact.bodyB.categoryBitMask == .enemy){
            //            self.run(.sequence(<#T##actions: [SKAction]##[SKAction]#>)) -> Aqui vai o tempinho depois que perder e talvez a animação
            
            let enemy = contact.bodyB.node
            enemy?.removeFromParent()
            self.removedBodies.append(enemy)
            
        }
        if (contact.bodyA.categoryBitMask == .enemy && contact.bodyB.categoryBitMask == .player){
            let enemy = contact.bodyA.node
            enemy?.removeFromParent()
            self.removedBodies.append(enemy)
        }
        
        
    }
}
