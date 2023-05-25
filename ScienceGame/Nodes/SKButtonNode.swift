//
//  SKButtonNode.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 26/04/23.
//

import SpriteKit

class SKButtonNode : SKNode {
//    let image: SKSpriteNode
    
    let text: SKLabelNode
    
    var clickAction: () -> ()
    var unclickAction: (() -> ())?
    
    init(text: String = "", clickAction: @escaping () -> (), unclickAction: (() -> ())? = nil) {
        self.text = SKLabelNode(text: text)
//        self.image = SKSpriteNode(imageNamed: name)
//        self.image.texture?.filteringMode = .nearest
        self.clickAction = clickAction
        self.unclickAction = unclickAction
        super.init()
        
//        self.image.zPosition -= 2
        
        self.text.verticalAlignmentMode = .center
        self.text.fontColor = .black
        self.zPosition += 5
        
//        self.image.alpha = 0.6
//        self.addChild(image)
        self.addChild(self.text)
        self.isUserInteractionEnabled = true
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
