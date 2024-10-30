//
//  GameSceneView.swift
//  PPE-TEST-SPRITEKIT
//
//  Created by Youssef Ait Elourf on 10/30/24.
//

import SwiftUI
import SpriteKit

struct GameSceneView: View {
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 400, height: 800)
        scene.scaleMode = .aspectFill
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .frame(width: 400, height: 800)
            .ignoresSafeArea()
    }
}
struct GameSceneView_Previews: PreviewProvider {
    static var previews: some View {
        GameSceneView()
    }
}
