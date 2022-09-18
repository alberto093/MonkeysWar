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
        case normal
        case fast
        
        var pointsPerSec: CGFloat {
            switch self {
            case .slow:
                return 15
            case .normal:
                return 30
            case .fast:
                return 45
            }
        }
    }
    
    var isGrabEnabled = false
    var canThrow = false
    var canJump = false
    var hasArmor = false
    var velocity: Velocity = .normal
    var hitPoints: Int = 0
    
    var walkTextures: [SKTexture] = []
    var jumpTextures: [SKTexture] = []
    var hitTextures: [SKTexture] = []
    var throwTextures: [SKTexture] = []
    var hurtTextures: [SKTexture] = []
}
