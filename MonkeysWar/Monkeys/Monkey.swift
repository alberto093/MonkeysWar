//
//  Monkey.swift
//  MonkeysWar
//
//  Created by Alberto Saltarelli on 17/09/22.
//

import Foundation

struct Monkey {
    let node: MonkeySpriteNode
    let delay: TimeInterval
    let spawn: SpawnSide
}

extension Monkey {
    enum SpawnSide {
        case left
        case right
    }
}
