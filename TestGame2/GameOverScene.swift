//
//  GameOverScene.swift
//  TestGame2
//
//  Created by William Wung on 5/29/20.
//  Copyright © 2020 William Wung. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    var playButton = SKSpriteNode();
    let playButtonText = SKTexture(imageNamed: "tryagain.png");
    var homeButton = SKSpriteNode();
    let homeButtomText = SKTexture(imageNamed: "shiba.png");
    var score:UILabel?;
    override func didMove(to view: SKView) {
        view.backgroundColor = .white
        score = UILabel(frame: CGRect(x: frame.midX-25, y: frame.midY - 50, width: 50, height: 50))
        score!.textAlignment = .center
        score!.text = String(GameScene.finalScore!)
        playButton = SKSpriteNode(texture: playButtonText)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        playButton.size = CGSize(width: 100, height: 50)
        homeButton = SKSpriteNode(texture: playButtonText)
        homeButton.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        homeButton.size = CGSize(width: 100, height: 50)
        self.addChild(playButton)
        self.addChild(homeButton)
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
            }else if node == homeButton {
                if let view = view {
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene:SKScene = MenuScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
}

