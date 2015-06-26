//
//  GameScene.swift
//  Converge
//
//  Created by Andrew Perrault on 2015-06-22.
//  Copyright (c) 2015 Andrew Perrault. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let poolLayer : SKNode = SKNode()
    var pools : [Pool] = []
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        self.addChild(myLabel)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = CGSize(width: frame.width, height: frame.height)
        background.anchorPoint = CGPoint.zeroPoint
        background.zPosition = 25
        addChild(background)
            
        poolLayer.zPosition = 100
        self.addChild(poolLayer)
        
        //pools = []
        
        buildBoard()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func buildBoard() {
        let size = CGSize(width: 2048, height: 1536)
        let poolWidth = 300 / size.width * frame.width
        let gapX = 36 / size.width * frame.width
        let borderLandR = 34 / size.width * frame.width
        let poolHeight = 400 / size.height * frame.height
        let gapY = 36 / size.height * frame.height
        let borderTandB = 350 / size.height * frame.height
        
        //var pool = Pool(origin: CGPoint(x: 400, y: 400), width: poolWidth, height: poolHeight)
        
        var posX: CGFloat = 0
        var posY: CGFloat = 0
        for (var i = 0; i < 12; i++) {
            if (i < 6) {
                posY = borderTandB
            } else {
                posY = borderTandB + poolHeight + gapY
            }
            if (i == 0 || i == 6) {
                posX = borderLandR
            } else {
                posX = borderLandR + CGFloat(i%6) * (poolWidth + gapX)
            }
            var pool = Pool(origin: CGPoint(x: posX, y:posY), width: poolWidth, height: poolHeight)
            poolLayer.addChild(pool)
            pools.append(pool)
        }
    }
}
