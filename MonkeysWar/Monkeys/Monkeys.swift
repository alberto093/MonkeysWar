//
//  Monkeys.swift
//  MonkeysWar
//
//  Created by Alberto Saltarelli on 17/09/22.
//

import Foundation
import SpriteKit

enum Monkeys {
    static func flo(withArmor: Bool = false) -> MonkeySpriteNode {
        let node = MonkeySpriteNode(imageNamed: "m1idle1")
        node.size = CGSize(width: 40, height: 40)
        node.isGrabEnabled = true
        node.hasArmor = withArmor
        node.idleTextures = (1...5).map { SKTexture(imageNamed: "m1idle\($0)") }
        node.walkTextures = (1...9).reversed().map { SKTexture(imageNamed: "m1walk\($0)") }
        node.hitTextures = (1...6).map { SKTexture(imageNamed: "m1hit\($0)") }
        node.hurtTextures = (1...6).map { SKTexture(imageNamed: "m1hurt\($0)") }
        node.hitPoints = 2
        node.lifePoints = 275
        node.velocity = .normal
        return node
    }
    
    static func gaga(withArmor: Bool = false) -> MonkeySpriteNode {
        let node = MonkeySpriteNode(imageNamed: "m2idle1")
        node.size = CGSize(width: 40, height: 40)
        node.isGrabEnabled = true
        node.hasArmor = withArmor
        node.idleTextures = (1...5).map { SKTexture(imageNamed: "m2idle\($0)") }
        node.walkTextures = (1...9).reversed().map { SKTexture(imageNamed: "m2walk\($0)") }
        node.hitTextures = (1...6).map { SKTexture(imageNamed: "m2hit\($0)") }
        node.hurtTextures = (1...6).map { SKTexture(imageNamed: "m2hurt\($0)") }
        node.hitPoints = 2
        node.lifePoints = 275
        node.velocity = .fast
        return node
    }
    
    static func momba(withArmor: Bool = false) -> MonkeySpriteNode {
        let node = MonkeySpriteNode(imageNamed: "m3idle1")
        node.hasArmor = withArmor
        node.velocity = .slow
        return node
    }
    
    static var loco: MonkeySpriteNode {
        let node = MonkeySpriteNode(imageNamed: "m2idle1")
        node.isGrabEnabled = true
        node.canJump = true
        node.velocity = .normal
        return node
    }
    
    static var nanny: MonkeySpriteNode {
        let node = MonkeySpriteNode(imageNamed: "m1idle1")
        node.isGrabEnabled = true
        node.canThrow = true
        node.velocity = .fast
        return node
    }
}
