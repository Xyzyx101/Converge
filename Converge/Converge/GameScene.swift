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
    let distributeLayer : SKNode = SKNode()
    var pools : [Pool] = []
    
    override func didMoveToView(view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = CGSize(width: frame.width, height: frame.height)
        background.anchorPoint = CGPoint.zeroPoint
        background.zPosition = 25
        addChild(background)
            
        poolLayer.zPosition = 100
        self.addChild(poolLayer)
        
        buildBoard()
        
        distributeLayer.zPosition = 200
        self.addChild(distributeLayer)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            let nodes = self.nodesAtPoint(location) as! [SKNode]
            for node in nodes
            {
                if let nodeName = node.name {
                    if nodeName == "pool" {
                        let pool = node as! Pool
                        if pool.isPlayerOwned() {
                            distribute(pool);
                        }
                    }
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func buildBoard() {
        let size = CGSize(width: 2048, height: 1536)
        let poolWidth = 300 / size.width * frame.width
        let gapX = 36 / size.width * frame.width
        let borderLR = 34 / size.width * frame.width
        let poolHeight = 400 / size.height * frame.height
        let gapY = 36 / size.height * frame.height
        let borderTB = 350 / size.height * frame.height
        let bitSize = 60 / size.height * frame.height
        
        var posX: CGFloat = 0
        var posY: CGFloat = 0
        var prevPool: Pool!
        for (var i = 0; i < 12; i++) {
            if (i < 6) {
                posY = borderTB
            } else {
                posY = borderTB + poolHeight + gapY
            }
            if (i == 0 || i == 11) {
                posX = borderLR
            } else if (i > 5){
                posX = borderLR + (5 - CGFloat(i%6)) * (poolWidth + gapX)
            } else {
                posX = borderLR + CGFloat(i%6) * (poolWidth + gapX)
            }
            var pool = Pool(origin: CGPoint(x: posX, y:posY), width: poolWidth, height: poolHeight, bitSize: bitSize)
            
            if (prevPool != nil) { //special case first pool
                pool.setPrev(prevPool)
                prevPool.setNext(pool)
            } else if (i == 11) {   // special case last pool
                pool.setNext(pools[0])
                pools[0].setPrev(pool)
            }
            prevPool = pool
            pool.name = "pool"
            pool.setBit(4)
            if (i < 6) {
                pool.setPlayerOwned(true)
            }
            pools.append(pool)
            poolLayer.addChild(pool)
            pool.redraw()
        }
    }
    
    func distribute(pool: Pool) {
        print(pool)
        var bitCount: Int = pool.children.count
        distributeLayer.position = pool.position
        distributeLayer.setScale(1.25)
        for node in pool.children {
            node.removeFromParent()
            //distributeLayer.addChild(node as! SKNode)
        }
        pool.setBit(0)
        var targetPool = pool.getNext()
        while(bitCount > 0) {
            targetPool.incBit()
            bitCount--
            targetPool = targetPool.getNext()
        }
        distributeLayer.setScale(1)
    }
}
