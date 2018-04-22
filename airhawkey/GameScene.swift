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

class GameScene: SKScene {
    
    let motion = CMMotionManager()
    
    private var puck = SKSpriteNode(imageNamed: "Airhawkey1.png")
    private var paddle = SKSpriteNode(imageNamed: "Paddle.png")
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.white
        
        puck.physicsBody = SKPhysicsBody(circleOfRadius: 75)
        puck.size = CGSize(width: 150, height: 150)
        puck.physicsBody?.isDynamic = true
        puck.physicsBody?.affectedByGravity = true
        puck.physicsBody?.categoryBitMask = 1
        puck.physicsBody?.collisionBitMask = 2
        puck.physicsBody?.fieldBitMask = 1
        puck.physicsBody?.contactTestBitMask = 2
        puck.physicsBody?.restitution = 1.05
        puck.physicsBody?.friction = 0.2
        
        paddle.physicsBody = SKPhysicsBody(circleOfRadius: 75)
        paddle.size = CGSize(width: 150, height: 150)
        paddle.physicsBody?.isDynamic = true
        paddle.physicsBody?.affectedByGravity = false
        paddle.physicsBody?.categoryBitMask = 2
        paddle.physicsBody?.collisionBitMask = 1
        paddle.physicsBody?.fieldBitMask = 2
        paddle.physicsBody?.contactTestBitMask = 1
        paddle.physicsBody?.friction = 0.2
        //paddle.physicsBody?.restitution = 1
        
//        if paddle.physicsBody?.categoryBitMask == puck.physicsBody?.collisionBitMask {
//            self.paddle.physicsBody?.applyForce(CGVector(dx: 1000 * 1000, dy: 1000 * 1000))
//        }
//        
//        if puck.physicsBody?.categoryBitMask == paddle.physicsBody?.collisionBitMask {
//             self.paddle.physicsBody?.applyForce(CGVector(dx: 1000 * 1000, dy: 1000 * 1000))
//        }
        
        puck.position = CGPoint(x: size.width * 0.4, y: size.height * 0.3)
        paddle.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        
        addChild(puck)
        addChild(paddle)
        
        startAccelerometers()
        
        
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
                                    
                                    
                                    // Use the accelerometer data in your app.
                                    var setx = CGFloat(120 * px) + (self.size.width * 0.1)
                                    var sety = CGFloat(120 * py) + (self.size.height * 0.1)
//                                    self.paddle.physicsBody?.applyForce(CGVector(dx: CGFloat(px), dy: CGFloat(sety)))
                                    self.paddle.position = CGPoint(x: setx, y: sety)
                                    self.physicsWorld.gravity = CGVector(dx: CGFloat(px) * 10, dy: CGFloat(py) * 10)
    
                                    
                                }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
        }
    }
    
    
}
