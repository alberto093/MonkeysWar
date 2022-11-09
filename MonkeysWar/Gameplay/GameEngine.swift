//
//  GameEngine.swift
//  MonkeysWar
//
//  Created by Alberto Saltarelli on 17/09/22.
//

import Foundation
import SpriteKit

class GameEngine: NSObject {
    private struct CategoryBitMask: OptionSet {
        let rawValue: UInt32
        
        static let ground = CategoryBitMask(rawValue: 1 << 0)
        static let monkey = CategoryBitMask(rawValue: 1 << 1)
    }
    
    private enum Constants {
        static let pointsInMeter: CGFloat = 40
        static let houseHPMaxWidth: CGFloat = 48
    }
    
    let scene: SKScene
    let groundY: CGFloat
    let towerFrame: CGRect
    let level: Level
    private let houseHPMax: Int
    
    private let houseHPNode = SKSpriteNode(color: UIColor(red: 200.0 / 255, green: 130.0 / 255, blue: 85.0 / 255, alpha: 1), size: CGSize(width: Constants.houseHPMaxWidth, height: 8))
    private let progressCount = SKLabelNode(text: "0")
    private let endGameLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    
    private var grabbingMonkeys: [UITouch: MonkeySpriteNode] = [:]
    private var gameIsEnd = false
    
    init(scene: SKScene, groundY: CGFloat, towerFrame: CGRect, level: Level) {
        self.scene = scene
        self.groundY = groundY
        self.towerFrame = towerFrame
        self.level = level
        self.houseHPMax = level.houseHP
        super.init()
        setupBoundaries()
        setupBackground()
    }
    
    // MARK: - Public
    func start() {
        var delay: TimeInterval = 0
        for (index, monkey) in level.monkeys.enumerated() {
            delay += monkey.delay
            monkey.node.zPosition = CGFloat(level.monkeys.count - index)
            spawn(monkey: monkey, spawnDelay: delay)
        }
    }
    
    func handle(touch: UITouch) {
        guard !gameIsEnd else { return }
        
        let position = touch.location(in: scene)
        let previousPosition = touch.previousLocation(in: scene)
        let dx = position.x - previousPosition.x
        let dy = position.y - previousPosition.y
        
        switch touch.phase {
        case .began:
            if let monkey = scene.nodes(at: position).first(where: { ($0 as? MonkeySpriteNode)?.isGrabEnabled == true }) as? MonkeySpriteNode {
                grabbingMonkeys[touch] = monkey
                grab(monkey: monkey)
            }
        case .moved:
            guard let monkey = grabbingMonkeys[touch] else { return }
            monkey.position.x += position.x - previousPosition.x
            let preferredY = monkey.position.y + position.y - previousPosition.y
            monkey.position.y = max(preferredY, groundY + monkey.size.height / 2)
            if position.y < groundY {
                grabbingMonkeys.removeValue(forKey: touch)
                drop(
                    monkey: monkey,
                    vector: CGVector(dx: dx * 20, dy: dy * 35),
                    angle: atan2(dy, dx) * 180 / .pi)
            }
        case .ended:
            guard let monkey = grabbingMonkeys[touch] else { return }
            grabbingMonkeys.removeValue(forKey: touch)
            
            drop(
                monkey: monkey,
                vector: CGVector(dx: dx * 20, dy: dy * 35),
                angle: atan2(dy, dx) * 180 / .pi)
        default:
            break
        }
    }
    
    // MARK: - Private
    private func setupBoundaries() {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -100, y: scene.size.height * 5))
        path.addLine(to: CGPoint(x: -100, y: groundY))
        path.addLine(to: CGPoint(x: scene.size.width + 200, y: groundY))
        path.addLine(to: CGPoint(x: scene.size.width + 200, y: scene.size.height * 5))
        
        scene.physicsWorld.contactDelegate = self
        
        scene.physicsBody = SKPhysicsBody(edgeChainFrom: path.cgPath)
        scene.physicsBody?.restitution = 0.3
        scene.physicsBody?.categoryBitMask = CategoryBitMask.ground.rawValue
        scene.physicsBody?.contactTestBitMask = CategoryBitMask.monkey.rawValue
    }
    
    private func setupBackground() {
        let houseNode = SKSpriteNode(imageNamed: "house")
        houseNode.scale(to: CGSize(width: towerFrame.width, height: towerFrame.height))
        houseNode.position = CGPoint(x: towerFrame.midX, y: towerFrame.midY)
        scene.addChild(houseNode)
        
        let topRightBox = SKSpriteNode(color: UIColor(red: 30 / 255, green: 29 / 255, blue: 40 / 255, alpha: 1), size: CGSize(width: 100, height: 35))
        
        let monkeyIconNode = SKSpriteNode(imageNamed: "monkeyIcon")
        monkeyIconNode.size = CGSize(width: 10, height: 10)
        monkeyIconNode.anchorPoint = CGPoint(x: 0, y: 1)
        monkeyIconNode.position = CGPoint(x: 5, y: topRightBox.size.height - 5)
        
        progressCount.fontColor = SKColor(white: 1, alpha: 1)
        progressCount.fontSize = 10
        progressCount.fontName = "AvenirNext-Medium"
        progressCount.position = CGPoint(x: 25, y: topRightBox.size.height - 15)
        
        let houseIconNode = SKSpriteNode(imageNamed: "houseIcon")
        houseIconNode.size = CGSize(width: 10, height: 10)
        houseIconNode.anchorPoint = .zero
        houseIconNode.position = CGPoint(x: 5, y: 5)
        let progressContainer = SKSpriteNode(color: UIColor(red: 47 / 255, green: 50 / 255, blue: 58 / 255, alpha: 1), size: CGSize(width: 50, height: 10))
        progressContainer.anchorPoint = .zero
        progressContainer.position = CGPoint(x: 25, y: 5)
        houseHPNode.anchorPoint = .zero
        houseHPNode.position = CGPoint(x: 1, y: 1)
        progressContainer.addChild(houseHPNode)
        
        topRightBox.addChild(monkeyIconNode)
        topRightBox.addChild(progressCount)
        topRightBox.addChild(houseIconNode)
        topRightBox.addChild(progressContainer)
        
        topRightBox.position = CGPoint(x: scene.size.width - topRightBox.size.width, y: scene.size.height - topRightBox.size.height)
        topRightBox.anchorPoint = .zero
        topRightBox.zPosition = CGFloat(level.monkeys.count + 1)
        scene.addChild(topRightBox)
        
        endGameLabel.fontSize = 50
        endGameLabel.verticalAlignmentMode = .center
        endGameLabel.horizontalAlignmentMode = .center
        endGameLabel.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
    }
    
    private func stopIfNeeded() {
        guard !gameIsEnd else { return }
        
        if level.houseHP <= 0 {
            endGameLabel.fontColor = UIColor(red: 240 / 255, green: 95 / 255, blue: 90 / 255, alpha: 1)
            endGameLabel.text = "GAME OVER"
            scene.addChild(endGameLabel)
            gameIsEnd = true
        } else if !scene.children.contains(where: { $0 is MonkeySpriteNode }) {
            endGameLabel.fontColor = UIColor(red: 15 / 255, green: 50 / 255, blue: 30 / 255, alpha: 1)
            endGameLabel.text = "WIN!"
            scene.addChild(endGameLabel)
            gameIsEnd = true
        }
    }
    
    private func spawn(monkey: Monkey, spawnDelay: TimeInterval) {
        let halfMonkeyWidth = monkey.node.size.width / 2

        switch monkey.spawn {
        case .left:
            monkey.node.position.x = -halfMonkeyWidth
        case .right:
            monkey.node.position.x = scene.size.width + halfMonkeyWidth
        }
        
        monkey.node.position.y = groundY + monkey.node.size.height / 2
        monkey.node.physicsBody = SKPhysicsBody(rectangleOf: monkey.node.size)
        monkey.node.physicsBody?.categoryBitMask = CategoryBitMask.monkey.rawValue
        monkey.node.physicsBody?.collisionBitMask = CategoryBitMask.ground.rawValue
        monkey.node.physicsBody?.mass = 4
        scene.addChild(monkey.node)
        activate(monkey: monkey.node, delay: spawnDelay)
    }
    
    private func grab(monkey: MonkeySpriteNode) {
        monkey.removeAllActions()
        monkey.physicsBody?.isResting = true
        monkey.physicsBody?.affectedByGravity = false
        monkey.run(.repeatForever(.animate(with: monkey.idleTextures, timePerFrame: 0.075)))
    }
    
    private func drop(monkey: MonkeySpriteNode, vector: CGVector, angle: CGFloat) {
        monkey.removeAllActions()
        monkey.physicsBody?.isResting = false
        monkey.physicsBody?.affectedByGravity = true
        monkey.physicsBody?.applyImpulse(vector)
        
        // Time of flight formula
        // t = [V₀ * sin(α) + √((V₀ * sin(α))² + 2 * g * h)] / g
        let fallDuration: TimeInterval = sqrt((2 * (monkey.position.y - groundY) / Constants.pointsInMeter) / -scene.physicsWorld.gravity.dy)
        
        if monkey.position.y < (groundY + monkey.size.height) {
            activate(monkey: monkey, delay: 0.5)
        } else {
            monkey.run(.sequence([
                .animate(with: monkey.hurtTextures, timePerFrame: fallDuration / Double(monkey.hurtTextures.count)),
                .run { [weak self] in self?.activate(monkey: monkey, delay: 0.75) }
            ]))
        }
    }
    
    private func activate(monkey: MonkeySpriteNode, delay: TimeInterval) {
        let destinationX: CGFloat = .random(in: towerFrame.minX...(towerFrame.maxX - monkey.size.width / 2))
        monkey.xScale = monkey.position.x < destinationX ? 1 : -1
        
        let walkDuration = (abs(monkey.position.x - destinationX)) / monkey.velocity.pointsPerSec
        let delayAction = SKAction.wait(forDuration: delay)
        let walkAnimation = SKAction.repeatForever(SKAction.animate(with: monkey.walkTextures, timePerFrame: 0.075))
        let moveAction = SKAction.moveTo(x: destinationX, duration: walkDuration)
        let hitAction = SKAction.animate(with: monkey.hitTextures, timePerFrame: 0.075)
        let hitBlock = SKAction.repeatForever(
            .sequence([
                .wait(forDuration: 0.5),
                .run { [weak self] in
                    guard let self = self else { return }
                    self.level.houseHP -= monkey.hitPoints
                    self.houseHPNode.size.width = max(Constants.houseHPMaxWidth * CGFloat(self.level.houseHP) / CGFloat(self.houseHPMax), 0)
                    self.stopIfNeeded()
                }
            ]))
        
        let startHitAction = SKAction.run {
            monkey.removeAllActions()
            monkey.run(.repeatForever(.sequence([hitAction, hitAction.reversed()])))
            monkey.run(hitBlock)
        }
        
        monkey.run(.sequence([
            delayAction,
            .run({
                monkey.run(walkAnimation)
                monkey.run(.sequence([moveAction, startHitAction]))
            })]))
    }
}

extension GameEngine: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let monkey = contact.bodyA.node as? MonkeySpriteNode ?? contact.bodyB.node as? MonkeySpriteNode else { return }
        // 10 can be modified in order to increase difficuly (higher values means more difficult)
        monkey.lifePoints -= Int(contact.collisionImpulse) / 10
        
        if monkey.lifePoints <= 0 {
            monkey.isGrabEnabled = false
            monkey.texture = monkey.hurtTextures.last
            monkey.removeAllActions()
            monkey.run(
                .sequence([
                    .wait(forDuration: 0.5),
                    .fadeOut(withDuration: 0.5),
                    .run { [weak self] in
                        monkey.removeFromParent()
                        if let self = self {
                            let progress = Int(self.progressCount.text!)!
                            self.progressCount.text = "\(progress + 1)"
                            self.stopIfNeeded()
                        }
                    }
                ])
            )
        }
    }
}
