//
//  GameScene.swift
//  SKTask
//
//  Created by admin on 2016-04-01.
//  Copyright (c) 2016 axu. All rights reserved.
//

import SpriteKit

let wallMask:UInt32 = 0x1 << 0 // 1
let ballMask:UInt32 = 0x1 << 1 // 2
let pegMask:UInt32 = 0x1 << 2 // 4
let squareMask:UInt32 = 0x1 << 3 // 8




class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var cannon: SKSpriteNode!
    var touchLocation: CGPoint = CGPointZero
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        cannon = self.childNodeWithName("cannon1") as! SKSpriteNode
        
        self.physicsWorld.contactDelegate = self
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        touchLocation = touches.first!.locationInNode(self)
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch moves */
        touchLocation = touches.first!.locationInNode(self)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let ball:SKSpriteNode = SKScene(fileNamed: "ball")?.childNodeWithName("ball")! as! SKSpriteNode
        
        ball.removeFromParent()
        self.addChild(ball)
        ball.zPosition = 0
        ball.position = cannon.position
        
        let angleInRadians = Float(cannon.zRotation)
        let speed = CGFloat(125.0)
        let vx:CGFloat = CGFloat(cosf(angleInRadians)) * speed
        let vy:CGFloat = CGFloat(sinf(angleInRadians)) * speed
        ball.physicsBody?.applyImpulse(CGVectorMake(vx, vy))
        ball.physicsBody?.collisionBitMask = wallMask | ballMask | pegMask
        
        //reacting to collisions
        ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask | squareMask
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let percent = touchLocation.x / size.width
        let newAngle = percent * 180 - 180
        cannon.zRotation = CGFloat(newAngle) * CGFloat(M_PI) / 180
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let ball = (contact.bodyA.categoryBitMask == ballMask) ? contact.bodyA : contact.bodyB
        
        let other = (ball == contact.bodyA) ? contact.bodyB : contact.bodyA
        
        if(other.categoryBitMask == pegMask){
            print("Hit Peg!")
        }
        else if(other.categoryBitMask == squareMask){
            print("Hit Square!")
        }
        else if(other.categoryBitMask == wallMask){
            print("Hit Wall!")
        }
        else if(other.categoryBitMask == ballMask){
            print("Hit ball!")
        }
    }
}
