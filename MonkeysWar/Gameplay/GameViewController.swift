//
//  GameViewController.swift
//  MonkeysWar
//
//  Created by Alberto Saltarelli on 15/09/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    private var skView: SKView {
        view as! SKView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene()
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
}
