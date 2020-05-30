//
//  GameScene.swift
//  TestGame2
//
//  Created by William Wung on 5/27/20.
//  Copyright © 2020 William Wung. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    static var finalScore: Int?;
    let player = SKSpriteNode(imageNamed: "shiba.jpeg")
    let sizeHeight = UIScreen.main.bounds.height;
    let sizeWidth = UIScreen.main.bounds.width;
    var points = 0;
    var pointsLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2 - 20, y: 15, width: 40, height: 35));
    struct PhysicsCategory {
        static let none      : UInt32 = 0
        static let all       : UInt32 = UInt32.max
        static let player    : UInt32 = 0b11      // 3
        static let enemy     : UInt32 = 0b1       // 1
        static let projectile: UInt32 = 0b10      // 2
    }

    func addEnemy() {
        let enemy = SKSpriteNode(imageNamed: "bone.png")
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.projectile | PhysicsCategory.player
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        enemy.scale(to: CGSize(width: 50, height: 50))
        var enemyDirection = -1;
        if(Int.random(in:1..<3) == 1) {
            if(Int.random(in:1..<3)==1) {
                enemy.position = CGPoint(x: -10, y: Int.random(in: 0..<Int(sizeHeight)))
                enemyDirection = 1;
                //east dir
            }else{
                enemy.position = CGPoint(x: Int(sizeWidth) + 10, y: Int.random(in: 0..<Int(sizeHeight)))
                enemyDirection = 2;
                //west dir
            }
        }else{
            if(Int.random(in:1..<3) == 1) {
                enemy.position = CGPoint(x: Int.random(in: 0..<Int(sizeWidth)), y: -10)
                enemyDirection = 3;
                //south dir
            }else{
                enemy.position = CGPoint(x: Int.random(in: 0..<Int(sizeWidth)), y: Int(sizeHeight)+10)
                enemyDirection = 4;
                //north dir
            }
        }
        addChild(enemy)
        var dest:CGPoint = CGPoint(x: 0, y: 0);
        if(enemyDirection == 1) {
            dest = CGPoint(x: Int(sizeWidth) + 10, y: Int.random(in: 0..<Int(sizeHeight)))
        }else if(enemyDirection == 2) {
            dest = CGPoint(x: -10, y: Int.random(in: 0..<Int(sizeHeight)))
        }else if(enemyDirection == 3) {
            dest = CGPoint(x: Int.random(in: 0..<Int(sizeWidth)), y: Int(sizeHeight)+10)
        }else if(enemyDirection == 4) {
            dest = CGPoint(x: Int.random(in: 0..<Int(sizeWidth)), y: -10)
        }else{
            print("error")
        }
        let move = SKAction.move(to: dest, duration: Double.random(in: 1..<5))
        let done = SKAction.removeFromParent();
        enemy.run(SKAction.sequence([move,done]))
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        /*
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
 */
        backgroundColor = SKColor.white
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        player.scale(to: CGSize(width: 60, height: 60))
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        player.physicsBody?.collisionBitMask = PhysicsCategory.none
        player.physicsBody?.usesPreciseCollisionDetection = true
        
        
        pointsLabel.textAlignment = .center
        
        self.view?.addSubview(pointsLabel)
        addChild(player)
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(addEnemy),
            SKAction.wait(forDuration: 2.0)
            ])
        ))

    }
    
    func getSpeed(point: CGPoint, dest: CGPoint) -> Double {
        let distance = sqrt(pow(dest.x-point.x,2) + pow(dest.y-point.y,2))
        return Double(distance/300)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    func projectileCollideEnemy(projectile: SKSpriteNode, enemy: SKSpriteNode) {
        projectile.removeFromParent()
        enemy.removeFromParent()
        points+=1;
        pointsLabel.text = String(points)
    }
    func playerCollideEnemy(player: SKSpriteNode, enemy: SKSpriteNode) {
        GameScene.finalScore = points
        let transition:SKTransition = SKTransition.fade(withDuration: 1)
        let scene:SKScene = GameOverScene(size: self.size)
        self.view?.presentScene(scene, transition: transition)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* for t in touches { self.touchUp(atPoint: t.location(in: self)) } */
          guard let touch = touches.first else {
            return
          }
          let touchLocation = touch.location(in: self)
          
          let projectile = SKSpriteNode(imageNamed: "ball.jpeg")
        projectile.scale(to: CGSize(width: 15, height: 15))
          projectile.position = player.position
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        projectile.physicsBody?.usesPreciseCollisionDetection = true

        
          addChild(projectile)
        var ydir = sizeHeight;
        if(touchLocation.y < player.position.y) {
            ydir = 0;
        }
        let multiplier = (ydir - player.position.y)/(touchLocation.y-player.position.y)
        
        
        let realDest = CGPoint(x: multiplier*(touchLocation.x-player.position.x), y: ydir)
          
        let move = SKAction.move(to: realDest, duration: getSpeed(point: player.position,dest: realDest))
          let done = SKAction.removeFromParent()
          projectile.run(SKAction.sequence([move, done]))

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
      // 1
      var firstBody: SKPhysicsBody
      var secondBody: SKPhysicsBody
        var collision: Bool
        if (contact.bodyA.categoryBitMask == 1 || contact.bodyB.categoryBitMask == 1 ) && (contact.bodyA.categoryBitMask == 2 || contact.bodyB.categoryBitMask == 2) {
            if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
                   firstBody = contact.bodyA
                   secondBody = contact.bodyB
                 } else {
                   firstBody = contact.bodyB
                   secondBody = contact.bodyA
                 }
            collision = true;
        }else {
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
        firstBody = contact.bodyA
        secondBody = contact.bodyB
      } else {
        firstBody = contact.bodyB
        secondBody = contact.bodyA
      }
            collision = false;
        }
    
      // 2
      if ((firstBody.categoryBitMask & PhysicsCategory.enemy != 0) &&
          (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
        if let one = firstBody.node as? SKSpriteNode,
          let two = secondBody.node as? SKSpriteNode {
            if(collision) {
          projectileCollideEnemy(projectile: two, enemy: one)
            }else{
        playerCollideEnemy(player: two, enemy: one)
            }
      }
    }


}
}
