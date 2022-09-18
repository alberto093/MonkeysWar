//
//  GameEngine.swift
//  MonkeysWar
//
//  Created by Alberto Saltarelli on 17/09/22.
//

import Foundation
import SpriteKit

class GameEngine {
    let scene: SKScene
    let groundY: CGFloat
    let towerBounds: CGRect
    let level: Level
    
    init(scene: SKScene, groundY: CGFloat, towerBounds: CGRect, level: Level) {
        self.scene = scene
        self.groundY = groundY
        self.towerBounds = towerBounds
        self.level = level
        setup()
    }
    
    func start() {
        var delay: TimeInterval = 0
        for monkey in level.monkeys {
            delay += monkey.delay
            spawn(monkey: monkey, spawnDelay: delay)
        }
    }
    
    func stop() {
        // game over
        print("game over")
    }
    
    private func setup() {
        let ground = SKNode()
        ground.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -100, y: groundY), to: CGPoint(x: scene.size.width + 100, y: groundY))
        ground.physicsBody?.restitution = 0.4
        scene.addChild(ground)
        scene.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
    }
    
    private func spawn(monkey: Monkey, spawnDelay: TimeInterval) {
        let halfMonkeyWidth = monkey.node.size.width / 2
        let destinationX: CGFloat = .random(in: towerBounds.minX...(towerBounds.maxX - halfMonkeyWidth))

        switch monkey.spawn {
        case .left:
            monkey.node.position.x = -halfMonkeyWidth
        case .right:
            monkey.node.position.x = scene.size.width + halfMonkeyWidth
            monkey.node.xScale = -1
        }
        
        monkey.node.position.y = groundY + monkey.node.size.height / 2
        monkey.node.physicsBody = SKPhysicsBody(rectangleOf: monkey.node.size)
        scene.addChild(monkey.node)
                
        let walkDuration = (abs(monkey.node.position.x - destinationX)) / monkey.node.velocity.pointsPerSec
       
        let delayAction = SKAction.wait(forDuration: spawnDelay)
        let walkAnimation = SKAction.repeatForever(SKAction.animate(with: monkey.node.walkTextures, timePerFrame: 0.075))
        let moveAction = SKAction.moveTo(x: destinationX, duration: walkDuration)
        let hitAction = SKAction.animate(with: monkey.node.hitTextures, timePerFrame: 0.075)
        let hitBlock = SKAction.repeatForever(
            .sequence([
                .wait(forDuration: 0.5),
                .run { [weak self] in
                    guard let self = self else { return }
                    if self.level.houseHP > 0 {
                        self.level.houseHP -= monkey.node.hitPoints
                    } else {
                        self.stop()
                    }
                }
            ]))
        
        let startHitAction = SKAction.run {
            monkey.node.removeAllActions()
            monkey.node.run(.repeatForever(.sequence([hitAction, hitAction.reversed()])))
            monkey.node.run(hitBlock)
        }
        
        monkey.node.run(walkAnimation)
        monkey.node.run(.sequence([
            delayAction,
            .sequence([moveAction, startHitAction])
        ]))
    }
}
