//
//  GameScene.swift
//  FlappyClone
//
//  Created by Marcos Texeira on 4/15/16.
//  Copyright (c) 2016 Marcos Texeira. All rights reserved.
//

import SpriteKit


struct PhysicsCategory {
    static let Ghost  : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall   : UInt32 = 0x1 << 3
}


class GameScene: SKScene {
    
    // creating the ground
    var Ground = SKSpriteNode()
    var Ghost  = SKSpriteNode()
    
    var wallPair = SKNode()
    var gameStarted = Bool()
    var moveAndRemove = SKAction()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        Ground = SKSpriteNode(imageNamed: "Ground")
        // dimentions
        Ground.setScale(0.5)
        
        
        // postion of ground (middle of the scene)
        Ground.position = CGPoint(x: self.frame.width / 2, y: 0)
        
        // physics options
        Ground.physicsBody = SKPhysicsBody(rectangleOfSize: Ground.size)
        //  is a number defining the type of object this is for considering collisions
        Ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        // is a number defining what categories of object this node should collide with
        Ground.physicsBody?.collisionBitMask = PhysicsCategory.Ghost
        // is a number defining which collisions we want to be notified about
        Ground.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
        
        
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.dynamic = false
        Ground.zPosition = 3
        
        self.addChild(Ground)
        
        
        Ghost = SKSpriteNode(imageNamed: "Ghost")
        Ghost.size = CGSize(width: 60, height: 70)
        Ghost.position = CGPoint(x: self.frame.width / 2 - Ghost.frame.width, y: self.frame.height / 2)
        
        Ghost.physicsBody = SKPhysicsBody(circleOfRadius: Ghost.frame.height / 2)
        //  is a number defining the type of object this is for considering collisions
        Ghost.physicsBody?.categoryBitMask = PhysicsCategory.Ghost
        // is a number defining what categories of object this node should collide with
        Ghost.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall
        // is a number defining which collisions we want to be notified about
        Ghost.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall
        
        
        Ghost.physicsBody?.affectedByGravity = false
        Ghost.physicsBody?.dynamic = true
        Ghost.zPosition = 2
    
        
        self.addChild(Ghost)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if gameStarted == false {
            // loop
            gameStarted = true
            Ghost.physicsBody?.affectedByGravity = true
            
            let spawn = SKAction.runBlock({
                () in
                
                self.createWalls()
            })
            
            let interval = SKAction.waitForDuration(2.0)
            let spawDelay = SKAction.sequence([spawn,interval])
            
            let spawDelayForever = SKAction.repeatActionForever(spawDelay)
            self.runAction(spawDelayForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            // moving the pipes
            let movePipes = SKAction.moveByX(-distance, y: 0, duration: NSTimeInterval(0.01 * distance))
            let removePipes = SKAction.removeFromParent()
            
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
            Ghost.physicsBody?.velocity = CGVectorMake(0, 0)
            Ghost.physicsBody?.applyImpulse(CGVectorMake(0, 90))
            
        } else {
            Ghost.physicsBody?.velocity = CGVectorMake(0, 0)
            Ghost.physicsBody?.applyImpulse(CGVectorMake(0, 90))
        }
        
        
    }
   
    
    func createWalls(){
        
        wallPair = SKNode()
        
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let bottomWall = SKSpriteNode(imageNamed: "Wall")
        
        topWall.position = CGPoint(x: self.frame.width, y: self.frame.height / 2 + 350)
        bottomWall.position = CGPoint(x: self.frame.width, y: self.frame.height / 2 - 350)
        
        topWall.setScale(0.5)
        // flipping
        topWall.zRotation = CGFloat(M_PI)
        
        // physics options
        topWall.physicsBody = SKPhysicsBody(rectangleOfSize: topWall.size)
        //  is a number defining the type of object this is for considering collisions
        topWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        // is a number defining what categories of object this node should collide with
        topWall.physicsBody?.collisionBitMask = PhysicsCategory.Ghost
        // is a number defining which collisions we want to be notified about
        topWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
        topWall.physicsBody?.dynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        bottomWall.physicsBody = SKPhysicsBody(rectangleOfSize: bottomWall.size)
        bottomWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        bottomWall.physicsBody?.collisionBitMask = PhysicsCategory.Ghost
        bottomWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
        bottomWall.physicsBody?.dynamic = false
        bottomWall.physicsBody?.affectedByGravity = false

        
        bottomWall.setScale(0.5)
        
        wallPair.addChild(topWall)
        wallPair.addChild(bottomWall)
        
        var randomPosition = CGFloat.random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y + randomPosition
        
        wallPair.zPosition = 1
        wallPair.runAction(moveAndRemove)
        
        self.addChild(wallPair)
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
