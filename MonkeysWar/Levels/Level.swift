//
//  Level.swift
//  MonkeysWar
//
//  Created by Alberto Saltarelli on 17/09/22.
//

import Foundation

class Level {
    var houseHP: Int
    let monkeys: [Monkey]
    
    internal init(houseHP: Int, monkeys: [Monkey]) {
        self.houseHP = houseHP
        self.monkeys = monkeys
    }
}
