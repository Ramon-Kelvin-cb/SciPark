//
//  ScoreNode.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 11/05/23.
//

import Foundation
import SpriteKit

class ScoreNode : SKNode {
    var pontuationFrame : SKSpriteNode
    var pontuation : SKLabelNode
    var eraser : SKSpriteNode
    
    override init() {
        self.pontuationFrame = SKSpriteNode(imageNamed: "pontuationFrame.png")
        self.pontuation = SKLabelNode(text: "")
        self.eraser = SKSpriteNode(imageNamed: "eraser.png")
        super.init()
        
        self.pontuation.fontName = "PatrickHandSC-Regular"
        self.pontuation.fontColor = .black
        self.pontuation.fontSize = 64
        self.pontuation.position.y -= 20
        self.pontuationFrame.addChild(self.pontuation)
        self.addChild(self.pontuationFrame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPontuation(pontuation : Int, win : Bool) {
        if win {
            if pontuation == 0 {
                self.pontuation.text = "0"
            } else {
                self.pontuation.text =  "\(pontuation - 1)"
                
                let newPontuation = SKLabelNode(text: "\(pontuation)")
                newPontuation.fontName = "PatrickHandSC-Regular"
                newPontuation.fontColor = .black
                newPontuation.fontSize = 64
                newPontuation.position.y -= 20
                newPontuation.alpha = 0
                self.addChild(newPontuation)
                
                self.pontuation.run(.group([
                    .sequence([
                        .wait(forDuration: 0.5),
                        .fadeOut(withDuration: 0.5),
                        .removeFromParent()
                    ]),
                    .sequence([
                        .run {
                            self.eraser.position = .init(x: self.scene!.size.width/2 + self.eraser.size.width/2, y: 0)
                            self.addChild(self.eraser)
                            self.eraser.run(.sequence([
                                .move(to: self.position - .init(x: -40, y: 60), duration: 0.5),
                                .sequence([
                                    .playSoundFileNamed("erasing.wav", waitForCompletion: false),
                                    .move(by: .init(dx: 0, dy: 20), duration: 0.1),
                                    .move(by: .init(dx: 0, dy: -40), duration: 0.2),
                                    .move(by: .init(dx: 0, dy: 20), duration: 0.1),
                                    .move(to: .init(x: -(self.scene!.size.width/2 + self.eraser.size.width/2), y: 0), duration: 0.5),
                                    .removeFromParent()
                                ])
                            ]))
                        },
                        .wait(forDuration: 0.5),
                        .run {
                            self.pontuation = newPontuation
                            newPontuation.run(.fadeIn(withDuration: 0.5))
                        },
                        
                    ])
                ]))
                
            }
        } else {
            self.pontuation.text = "\(pontuation)"
        }
    }
    
    
}
