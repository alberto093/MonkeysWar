//
//  GameScene.swift
//  MonkeysWar
//
//  Created by Alberto Saltarelli on 15/09/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private let background = SKSpriteNode(imageNamed: "background")
    
    override func didMove(to view: SKView) {
        background.scale(to: size)
        background.anchorPoint = .zero
        insertChild(background, at: 0)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
