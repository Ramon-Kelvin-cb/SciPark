//
//  HeartManager.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 11/05/23.
//

import Foundation
import SpriteKit

class HeartManager : SKNode {
    var livesBefore : Int = 3
    
    let life1 = HeartCell()
    let life2 = HeartCell()
    let life3 = HeartCell()
    
    var hearts : [HeartCell] = []
    
    override init() {
        super.init()
        self.hearts.append(self.life1)
        self.hearts.append(self.life2)
        self.hearts.append(self.life3)
        for i in 0...2 {
            self.addChild(hearts[i])
        }
        
        life3.position = life2.position + .init(x: life3.container.size.width + 7, y: 0)
        life1.position = life2.position - .init(x: life3.container.size.width + 7, y: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLives(lives : Int, win : Bool) {
        self.livesBefore = lives
        
        if win {
            if lives == 2 {
                hearts.last?.heratCell.removeFromParent()
            } else if lives == 1{
                hearts.last?.heratCell.removeFromParent()
                hearts[1].heratCell.removeFromParent()
            } else {
                return
            }
        } else {
            self.livesBefore += 1
            if livesBefore == 3{
                hearts.last?.looseLife()
            } else if livesBefore == 2 {
                hearts.last?.heratCell.removeFromParent()
                hearts[1].looseLife()
            } else {
                hearts.last?.heratCell.removeFromParent()
                hearts[1].heratCell.removeFromParent()
                hearts[0].looseLife()
            }
        }
    }
    
    
    
}
