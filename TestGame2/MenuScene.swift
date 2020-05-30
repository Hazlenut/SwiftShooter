//
//  MenuScene.swift
//  TestGame2
//
//  Created by William Wung on 5/29/20.
//  Copyright © 2020 William Wung. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    var playButton = SKSpriteNode();
    let playButtonText = SKTexture(imageNamed: "start.png");
    override func didMove(to view: SKView) {
        playButton = SKSpriteNode(texture: playButtonText)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(playButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)

            if node == playButton {
                if let view = view {
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene:SKScene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
}
