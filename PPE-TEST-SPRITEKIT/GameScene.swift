//
//  GameScene.swift
//  PPE-TEST-SPRITEKIT
//
//  Created by Youssef Ait Elourf on 10/30/24.
//
import SpriteKit
import HealthKit

class GameScene: SKScene {
    
    // Player and NPC nodes
    let player = SKSpriteNode(imageNamed: "player")
    let npc1 = SKSpriteNode(imageNamed: "npc1")
    let npc2 = SKSpriteNode(imageNamed: "npc2")
    
    // Buttons
    let interactButton = SKLabelNode(text: "Interact")
    let fightButton = SKLabelNode(text: "Fight")
    
    // Labels to display step counts
    let stepsLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    
    // Player Movement
    var touchLocation: CGPoint = CGPoint.zero
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        // Set up steps label
        setupStepsLabel()
        
        // Desired sprite size
        let spriteSize = CGSize(width: 64, height: 64)
        
        // Set up player
        player.size = spriteSize
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        player.name = "player"
        addChild(player)
        
        // Set up NPC 1
        npc1.size = spriteSize
        npc1.position = CGPoint(x: size.width * 0.7, y: size.height * 0.5)
        npc1.name = "npc1"
        addChild(npc1)
        
        // Set up NPC 2
        npc2.size = spriteSize
        npc2.position = CGPoint(x: size.width * 0.3, y: size.height * 0.5)
        npc2.name = "npc2"
        addChild(npc2)
        
        // Set up buttons but keep them hidden
        setupButton(interactButton)
        setupButton(fightButton)
    }
    
    func setupStepsLabel() {
        stepsLabel.fontSize = 24
        stepsLabel.fontColor = SKColor.black
        stepsLabel.horizontalAlignmentMode = .center
        stepsLabel.verticalAlignmentMode = .top
        stepsLabel.text = "Steps: Fetching..."
        stepsLabel.zPosition = 1000 // Ensure it's on top
        
        // Adjust the position to be lower on the screen
        let topSafeAreaInset = self.view?.safeAreaInsets.top ?? 0
        stepsLabel.position = CGPoint(x: size.width * 0.5, y: size.height - topSafeAreaInset - 50)
        
        addChild(stepsLabel)
    }
    
    func setupButton(_ button: SKLabelNode) {
        button.fontName = "AvenirNext-Bold"
        button.fontSize = 24
        button.fontColor = SKColor.black
        button.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        button.isHidden = true
        button.name = button.text?.lowercased() // Set the name for touch detection
        addChild(button)
    }
    
    // Function to update the steps label with fetched data
    func updateStepCounts(_ stepsData: [Date: Double]) {
        if stepsData.isEmpty {
            stepsLabel.text = "Steps: No data available"
            return
        }
        
        var totalSteps: Double = 0
        for (_, steps) in stepsData {
            totalSteps += steps
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let stepsString = formatter.string(from: NSNumber(value: totalSteps)) ?? "\(Int(totalSteps))"
        
        stepsLabel.text = "Steps (Last 2 Days): \(stepsString)"
    }
    
    // Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchLocation = touch.location(in: self)
        
        // Check if buttons are tapped
        if !interactButton.isHidden && interactButton.contains(touchLocation) {
            showInteractionPrompt()
        } else if !fightButton.isHidden && fightButton.contains(touchLocation) {
            startFight()
        } else {
            movePlayerToward(location: touchLocation)
        }
    }
    
    func movePlayerToward(location: CGPoint) {
        let actionDuration = TimeInterval(player.position.distance(to: location) / 200)
        let moveAction = SKAction.move(to: location, duration: actionDuration)
        player.run(moveAction)
    }
    
    // Proximity Check
    override func update(_ currentTime: TimeInterval) {
        let interactionDistance: CGFloat = 80
        let distanceToNPC1 = player.position.distance(to: npc1.position)
        let distanceToNPC2 = player.position.distance(to: npc2.position)
        
        interactButton.isHidden = distanceToNPC1 > interactionDistance
        fightButton.isHidden = distanceToNPC2 > interactionDistance
    }
    
    func showInteractionPrompt() {
        let alert = UIAlertController(title: "Interaction", message: "Interaction successful.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func startFight() {
        if let view = self.view {
            let transition = SKTransition.crossFade(withDuration: 0.5)
            let fightScene = FightScene(size: self.size)
            fightScene.scaleMode = .aspectFill
            view.presentScene(fightScene, transition: transition)
        }
    }
}

// Helper extension for calculating distance
extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(x - point.x, y - point.y)
    }
}
