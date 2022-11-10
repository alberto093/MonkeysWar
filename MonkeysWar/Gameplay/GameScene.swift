//
//  GameScene.swift
//  MonkeysWar
//
//  Created by Alberto Saltarelli on 15/09/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private enum Constants {
        static let groundYMultiplier: CGFloat = 0.1845
        static let towerXMultiplier: CGFloat = 0.5
    }
    
    private let background = SKSpriteNode(imageNamed: "background")

    private var engine: GameEngine!

    override func didMove(to view: SKView) {
        background.scale(to: size)
        background.anchorPoint = .zero
        insertChild(background, at: 0)

        let groundY = Constants.groundYMultiplier * background.size.height
        let towerSize = size.width * 0.2
        engine = GameEngine(
            scene: self,
            groundY: groundY,
            towerFrame: CGRect(
                x: Constants.towerXMultiplier * background.size.width,
                y: groundY,
                width: towerSize,
                height: towerSize),
            level: Levels.day1)

        engine.start()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach(engine.handle)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach(engine.handle)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach(engine.handle)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach(engine.handle)
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
