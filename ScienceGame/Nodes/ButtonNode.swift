//
//  ButtonNode.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 11/05/23.
//

import Foundation
import SpriteKit

class ButtonNode : SKNode{
    let image: SKSpriteNode
    let text: SKLabelNode
    
    var clickAction: () -> ()
    var unclickAction: (() -> ())?
    
    init(imageNamed name:String, text: String = "", clickAction: @escaping () -> (), unclickAction: (() -> ())? = nil) {
        self.text = SKLabelNode(text: text)
        self.image = SKSpriteNode(imageNamed: name)
        self.clickAction = clickAction
        self.unclickAction = unclickAction
        
        super.init()
        self.image.zPosition -= 1
        
        self.text.verticalAlignmentMode = .center
        self.text.fontName = "PatrickHandSC-Regular"
        self.text.fontColor = .black
        self.zPosition += 5
        
        self.addChild(self.image)
        self.addChild(self.text)
        self.isUserInteractionEnabled = true
    }
    
    func animate(action : SKAction) {
        self.run(action)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        clickAction()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        unclickAction?()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        unclickAction?()
    }
}
