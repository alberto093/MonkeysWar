//
//  ProgressBarNode.swift
//  MonkeysWar
//
//  Created by Alberto Saltarelli on 20/09/22.
//

import SpriteKit

class ProgressBarNode: SKNode {
    
    private var progress: CGFloat = 0
    private var maxProgress: CGFloat = 100
    
    private var progressBar = SKSpriteNode(color: UIColor(red: 200 / 255, green: 130 / 255, blue: 85 / 255, alpha: 1), size: .zero)
    private var container = SKSpriteNode(color: UIColor(red: 47 / 255, green: 50 / 255, blue: 58 / 255, alpha: 1), size: .zero)

    
    override init() {
        super.init()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addChild(container)
        container.addChild(progressBar)
    }
}
