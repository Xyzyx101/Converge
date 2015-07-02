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
    let labelLayer : SKNode = SKNode()
    var pools : [Pool] = []
    var gameOver = false
    var playerWon = false
    var AIScore = 0
    var playerScore = 0
    var playerTurn = true
    var ai: AI!
    
    let label = SKLabelNode(fontNamed: "Arial")
    let playerScoreLabel = SKLabelNode(fontNamed: "Arial")
    let aiScoreLabel = SKLabelNode(fontNamed: "Arial")
    
    enum PLAYER {
        case HUMAN
        case AI
    }
    var currentPlayer = PLAYER.HUMAN
    
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = CGSize(width: frame.width, height: frame.height)
        background.anchorPoint = CGPoint.zeroPoint
        background.zPosition = 25
        addChild(background)
        
        setupScoreLabels()
        
        poolLayer.zPosition = 100
        self.addChild(poolLayer)
        
        labelLayer.zPosition = 1000
        self.addChild(labelLayer)
        
        buildBoard()
        
        distributeLayer.zPosition = 200
        self.addChild(distributeLayer)
        nextTurn(PLAYER.HUMAN)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if (currentPlayer == PLAYER.AI){
            return
        }
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            let nodes = self.nodesAtPoint(location) as! [SKNode]
            for node in nodes
            {
                if let pool = node as? Pool {
                    if pool.isPlayerOwned() && pool.getBit() != 0 {
                        distribute(pool);
                        nextTurn(PLAYER.AI)
                    }
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        if (gameOver == true) {
            return
        }
        
        if (playerScore >= 24) {
            playerWon = true
            gameOver = true
            displayGameOverMessage()
        } else if (AIScore) >= 24 {
            playerWon = false
            gameOver = true
            displayGameOverMessage()
        }
    }
    
    func nextTurn(newTurn: PLAYER) {
        currentPlayer = newTurn
        switch newTurn {
        case PLAYER.HUMAN:
            displayMessage("Your Turn",  duration: 1)
            break
        case PLAYER.AI:
            displayMessage("AI Turn", duration: 1)
            let pretendImThinking = SKAction.waitForDuration(1.5)
            self.runAction(SKAction.sequence([pretendImThinking, SKAction.runBlock({
                let move = self.ai.getMove(self.pools)
                self.distribute(self.pools[move])
                self.nextTurn(PLAYER.HUMAN)
                })]))
            break
        }
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
        
        aiScoreLabel.position = CGPoint(x: frame.width - borderLR, y: frame.height - (borderTB * 3 / 4 ))
        playerScoreLabel.position = CGPoint(x: borderLR, y: borderTB * 3 / 4)
        
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
            
            if (prevPool != nil) {
                pool.setPrev(prevPool)
                prevPool.setNext(pool)
            }
            if (i == 11) {   // special case last pool
                pool.setNext(pools[0])
                pools[0].setPrev(pool)
            }
            
            prevPool = pool
            pool.name = "pool"
            pool.setBit(4)
            if (i < 6) {
                pool.setPlayerOwned(true)
            }
            pool.poolID = i
            pools.append(pool)
            poolLayer.addChild(pool)
            pool.redraw()
        }
    }
    
    func distribute(pool: Pool) {
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
        checkScore(targetPool.getPrev())
    }
    
    func checkScore(var lastPool: Pool) {
        while(mayScore(lastPool.getBit())) {
            switch currentPlayer {
            case .HUMAN:
                if (lastPool.isPlayerOwned()) {
                    return
                }
                playerScore += lastPool.getBit()
                playerScoreLabel.text = "You: " + String(playerScore)
            case .AI:
                if (!lastPool.isPlayerOwned()) {
                    return
                }
                AIScore += lastPool.getBit()
                aiScoreLabel.text = "AI: " + String(AIScore)
            }
            lastPool.setBit(0)
            lastPool = lastPool.getPrev()
        }
    }
    
    func mayScore(value: Int) -> Bool {
        return value == 2 || value == 4 || value == 8 || value == 16
    }
    
    func displayGameOverMessage() {
        let restartTime = 3.5
        if (playerWon) {
            displayMessage("You Won!", duration: restartTime)
        } else {
            displayMessage("You Lose!", duration: restartTime)
        }
        let gameOverAction = SKAction.sequence([SKAction.waitForDuration(restartTime), SKAction.runBlock(returnToMenu)])
        self.runAction(gameOverAction)
    }
    
    func displayMessage(message: String, duration: NSTimeInterval) {
        // cleanup in case the previous label is still running
        label.removeActionForKey("labelAction")
        if label.parent != nil {
            label.removeFromParent()
        }
        
        label.text = message
        label.fontSize = 50
        label.fontColor = SKColor(red: 21/255, green: 73/255, blue: 151/255, alpha: 1)
        label.verticalAlignmentMode = .Center
        label.horizontalAlignmentMode = .Center
        label.position = CGPoint(
            x: self.frame.width / 2,
            y: self.frame.height / 2)
        
        labelLayer.addChild(label)
        
        let labelAction = SKAction.sequence([
            SKAction.scaleTo(2.5, duration: duration * 3 / 5),
            SKAction.scaleTo(2.25, duration: duration * 2 / 5),
            SKAction.removeFromParent()
            ])
        label.runAction(labelAction, withKey: "labelAction")
    }
    
    func returnToMenu() {
        NSNotificationCenter.defaultCenter().postNotificationName("gameOver", object: nil)
    }
    
    func setAI(type: AI_TYPE) {
        ai = AI(type: type)
    }
    
    func setupScoreLabels() {
        playerScoreLabel.fontSize = 32
        playerScoreLabel.fontColor = SKColor(red: 21/255, green: 73/255, blue: 151/255, alpha: 1)
        playerScoreLabel.verticalAlignmentMode = .Center
        playerScoreLabel.horizontalAlignmentMode = .Left
        playerScoreLabel.text = "You: 0"
        labelLayer.addChild(playerScoreLabel)
        
        aiScoreLabel.fontSize = 32
        aiScoreLabel.fontColor = SKColor(red: 21/255, green: 73/255, blue: 151/255, alpha: 1)
        aiScoreLabel.verticalAlignmentMode = .Center
        aiScoreLabel.horizontalAlignmentMode = .Right
        aiScoreLabel.text = "AI: 0"
        labelLayer.addChild(aiScoreLabel)
    }
}
