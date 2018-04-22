//
//  GameScene.swift
//  airhawkey
//
//  Created by Danny Peng on 4/21/18.
//  Copyright © 2018 Danny Peng. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

struct Category {
    static let TopBorder: UInt32 = 0
    static let Paddle: UInt32 = 0b1
    static let Puck: UInt32 = 0b10
    static let Goal: UInt32 = 0b100
}

class GameScene: SKScene, SKPhysicsContactDelegate, Scene {
    var controller : GameProtocol!
    let motion = CMMotionManager()
    
    private var puck = SKSpriteNode(imageNamed: "Airhawkey1.png")
    private var paddle = SKSpriteNode(imageNamed: "Paddle.png")
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.white
        
        self.physicsWorld.contactDelegate = self
        
        puck.physicsBody = SKPhysicsBody(circleOfRadius: 75)
        puck.size = CGSize(width: 150, height: 150)
        puck.physicsBody?.isDynamic = true
        puck.physicsBody?.mass = 0.002
        puck.physicsBody?.affectedByGravity = false // CHANGE TO FALSE LATER ONCE WE FIGURE OUT FRICTION AND PADDLE PHYSICS
        puck.physicsBody?.categoryBitMask = Category.Puck // WAS 1
        puck.physicsBody?.collisionBitMask = Category.Paddle // Was 2
//        puck.physicsBody?.fieldBitMask = 1
        puck.physicsBody?.contactTestBitMask = Category.Puck // WAS 2
        puck.physicsBody?.restitution = 0.995
        puck.physicsBody?.friction = 0.1
        
        paddle.physicsBody = SKPhysicsBody(circleOfRadius: 75)
        paddle.size = CGSize(width: 150, height: 150)
        paddle.physicsBody?.isDynamic = true
        paddle.physicsBody?.affectedByGravity = true // WAS FALSE
        paddle.physicsBody?.categoryBitMask = Category.Paddle // WAS 2
        paddle.physicsBody?.collisionBitMask = Category.Puck // WAS 1
//        paddle.physicsBody?.fieldBitMask = 2
        paddle.physicsBody?.contactTestBitMask = Category.Paddle // WAS 1
        paddle.physicsBody?.friction = 0.2
        paddle.physicsBody?.restitution = 1
        
//        if paddle.physicsBody?.categoryBitMask == puck.physicsBody?.collisionBitMask {
//            self.paddle.physicsBody?.applyForce(CGVector(dx: 1000 * 1000, dy: 1000 * 1000))
//        }
//        
//        if puck.physicsBody?.categoryBitMask == paddle.physicsBody?.collisionBitMask {
//             self.paddle.physicsBody?.applyForce(CGVector(dx: 1000 * 1000, dy: 1000 * 1000))
//        }
        
        puck.position = CGPoint(x: 0, y: 640)
        paddle.position = CGPoint(x: 0, y: 0)
        
        addChild(puck)
        addChild(paddle)
        
        startAccelerometers()
        
        
    }
    
    func setController(_ controller: GameProtocol) {
        self.controller = controller
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
    
    func startAccelerometers() {
        // Make sure the accelerometer hardware is available.
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
            self.motion.startAccelerometerUpdates()
            
            // Configure a timer to fetch the data.
            let timer = Timer(fire: Date(), interval: (1.0/60.0),
                               repeats: true, block: { (timer) in
                                // Get the accelerometer data.
                                if let data = self.motion.accelerometerData {
                                    let px = data.acceleration.x
                                    let py = data.acceleration.y
//                                    let pz = data.acceleration.z
                                    
//                                    print("x is: ", px, "y is: ", py )
                                    
                                    var currentX = self.paddle.position.x
                                    var currentY = self.paddle.position.y
                                    
                                    if px < 0 {
                                        if (currentX + CGFloat(px * 100) < -415 || currentX <= -415) {
                                            self.paddle.position.x = -415
                                        }
                                        else {
                                            self.paddle.position.x = currentX + CGFloat(px * 100)
                                        }
                                    }
                                    else if px > 0 {
                                        if (currentX + CGFloat(px * 100) > 415 || currentX >= 415) {
                                            self.paddle.position.x = 415
                                        }
                                        else {
                                            self.paddle.position.x = currentX + CGFloat(px * 100)
                                        }
                                    }
                                    if py < 0 {
                                        if (currentY + CGFloat(py * 100) < -85 || currentY <= -85) {
                                            self.paddle.position.y = -85
                                        }
                                        else {
                                            self.paddle.position.y = currentY + CGFloat(py * 100)
                                        }
                                    }
                                    else if py > 0 {
                                        if (currentY + CGFloat(py * 100) > 800 || currentY >= 800) {
                                            self.paddle.position.y = 800
                                        }
                                        else {
                                            self.paddle.position.y = currentY + CGFloat(py * 100)
                                        }
                                    }
                                    
//                                    // Use the accelerometer data in your app.
//                                    var setx = CGFloat(120 * px) + (self.size.width * 0.1)
//                                    var sety = CGFloat(120 * py) + (self.size.height * 0.1)
////                                    self.paddle.physicsBody?.applyForce(CGVector(dx: CGFloat(px), dy: CGFloat(sety)))
//                                    self.paddle.position = CGPoint(x: setx, y: sety)
                                    self.physicsWorld.gravity = CGVector(dx: CGFloat(px) * 10, dy: CGFloat(py) * 10)
    
                                    
                                }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
        }
    }
    
    
}

extension GameScene {
    func didBegin (_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == Category.TopBorder | Category.Puck {
            print("Puck ran into TopBorder")
        }
        else if collision == Category.Goal {
            // Initialize player who got scored on (or who scored)
            //  to increase the other player's score
            
            if contact.bodyA.node!.name == "puck" {
                
            }
            else {
                // contact.bodyA is the goal for the player who got scored on
            }
            // Call function to increment score for player who scored,
            // and restart a round of play
            //
            
        }
    }
}
