//
//  FightScene.swift
//  PPE-TEST-SPRITEKIT
//
//  Created by Youssef Ait Elourf on 10/30/24.
//

import SpriteKit

class FightScene: SKScene {
    
    // Characters
    let player = SKSpriteNode(imageNamed: "player")
    let enemy = SKSpriteNode(imageNamed: "npc2")
    
    // Buttons
    let attackButton = SKLabelNode(text: "Attack")
    let defendButton = SKLabelNode(text: "Defend")
    let returnButton = SKLabelNode(text: "Return")
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.gray
        
        // Set up player character
        player.size = CGSize(width: 150, height: 150)
        player.position = CGPoint(x: size.width * 0.25, y: size.height * 0.5)
        player.name = "player"
        addChild(player)
        
        // Set up enemy character
        enemy.size = CGSize(width: 150, height: 150)
        enemy.position = CGPoint(x: size.width * 0.75, y: size.height * 0.5)
        enemy.name = "enemy"
        addChild(enemy)
        
        // Set up buttons
        setupButton(attackButton, position: CGPoint(x: size.width * 0.3, y: size.height * 0.2))
        setupButton(defendButton, position: CGPoint(x: size.width * 0.7, y: size.height * 0.2))
        setupButton(returnButton, position: CGPoint(x: size.width * 0.5, y: size.height * 0.9))
    }
    
    func setupButton(_ button: SKLabelNode, position: CGPoint) {
        button.fontName = "AvenirNext-Bold"
        button.fontSize = 32
        button.fontColor = SKColor.white
        button.position = position
        button.name = button.text?.lowercased() // Set the name for touch detection
        addChild(button)
    }
    
    // Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if let nodeName = node.name {
                switch nodeName {
                case "attack":
                    // Placeholder action for attack
                    print("Attack button tapped")
                case "defend":
                    // Placeholder action for defend
                    print("Defend button tapped")
                case "return":
                    // Return to the main game scene
                    returnToGameScene()
                default:
                    break
                }
            }
        }
    }
    
    func returnToGameScene() {
        if let view = self.view {
            let transition = SKTransition.crossFade(withDuration: 0.5)
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = .aspectFill
            view.presentScene(gameScene, transition: transition)
        }
    }
}
