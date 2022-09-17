//
//  Monkey.swift
//  MonkeysWar
//
//  Created by Alberto Saltarelli on 15/09/22.
//

import SpriteKit

class MonkeySpriteNode: SKSpriteNode {
    enum Velocity {
        case slow
        case normale
        case fast
    }
    
    let isGrabEnabled: Bool
    private(set) var hasArmor: Bool
    let velocity: Velocity
    
    init(isGrabEnabled: Bool, hasArmor: Bool, velocity: Velocity, imageName: String) {
        self.isGrabEnabled = isGrabEnabled
        self.hasArmor = hasArmor
        self.velocity = velocity
        super.init(texture: SKTexture(imageNamed: imageName))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
