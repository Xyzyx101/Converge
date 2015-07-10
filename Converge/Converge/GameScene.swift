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
    
    let label = SKLabelNode(fontNamed: "CFSpaceship-Regular")
    let playerScoreLabel = SKLabelNode(fontNamed: "Orbitron-Regular")
    let aiScoreLabel = SKLabelNode(fontNamed: "Orbitron-Regular")
    var poolOffset = CGPoint.zeroPoint
    var readyForNextTurn = false
    var willGoNext = PLAYER.HUMAN
    
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
        let fragShader = SKShader(fileNamed: "backgroundBlur")
        background.shader = fragShader

        addChild(background)
        
        setupScoreLabels()
        
        poolLayer.zPosition = 100
        self.addChild(poolLayer)
        
        distributeLayer.zPosition = 200
        self.addChild(distributeLayer)
        
        labelLayer.zPosition = 1000
        self.addChild(labelLayer)
        
        buildBoard()
        
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
                        prepareNextTurn(PLAYER.AI)
                        distribute(pool);
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
            readyForNextTurn = false
            displayGameOverMessage()
        } else if (AIScore) >= 24 {
            playerWon = false
            gameOver = true
            readyForNextTurn = false
            displayGameOverMessage()
        }
        
        if readyForNextTurn {
            nextTurn(willGoNext)
            readyForNextTurn = false
        }
    }
    
    func nextTurn(newTurn: PLAYER) {
        // Check if there are no available moves and end the game
        var totalBits = 0
        switch newTurn {
        case .HUMAN:
            for i in 0...5 {
                totalBits = totalBits + pools[i].getBit()
            }
            if totalBits == 0 {
                playerWon = true
                gameOver = true
                readyForNextTurn = false
                displayGameOverMessage()
                for i in 6...11 {
                    animateScore(pools[i], player: PLAYER.HUMAN)
                    playerScore += pools[i].getBit()
                    playerScoreLabel.text = "You: " + String(playerScore)
                    pools[i].setBit(0)
                }
                return
            }
        case .AI:
            for i in 6...11 {
                totalBits = totalBits + pools[i].getBit()
            }
            if totalBits == 0 {
                playerWon = false
                gameOver = true
                readyForNextTurn = false
                displayGameOverMessage()
                for i in 0...5 {
                    animateScore(pools[i], player: PLAYER.AI)
                    AIScore += pools[i].getBit()
                    aiScoreLabel.text = "You: " + String(AIScore)
                    pools[i].setBit(0)
                }
                return
            }
        }
        
        currentPlayer = newTurn
        switch newTurn {
        case PLAYER.HUMAN:
            displayMessage("Your Turn",  duration: 1)
            break
        case PLAYER.AI:
            displayMessage("AI Turn", duration: 1)
            let pretendImThinking = SKAction.waitForDuration(1.5)
            self.runAction(SKAction.sequence([pretendImThinking, SKAction.runBlock({
                self.prepareNextTurn(PLAYER.HUMAN)
                let move = self.ai.getMove(self.pools)
                self.distribute(self.pools[move])
                })]))
            break
        }
    }
    
    func prepareNextTurn(newTurn : PLAYER) {
        willGoNext = newTurn
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
        
        poolOffset = CGPoint(x:poolWidth * 0.5, y:poolHeight * 0.5)
        
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
        Audio.instance().play(Audio.Sound.SELECT_POOL)
        var bitCount: Int = pool.children.count
        distributeLayer.position = CGPoint(x : pool.position.x + poolOffset.x, y: pool.position.y + poolOffset.y)
        for node in pool.children {
            var otherNode = node as! SKNode
            otherNode.position = pool.convertPoint(node.position, toNode: distributeLayer)
            node.removeFromParent()
            distributeLayer.addChild(node as! SKNode)
        }
        var choosePoolAction = SKAction.group([
                SKAction.repeatActionForever(
                    SKAction.rotateByAngle(CGFloat(360 * M_PI / 180.0), duration: 0.5)
                    ),
                SKAction.scaleTo(1.5, duration: 0.2)
            ])
        distributeLayer.runAction(choosePoolAction)
        
        pool.setBit(0)
        var completeBits = 0
        var animCount = bitCount
        var targetPool = pool.getNext()
        while(bitCount > 0) {
            var targetCopy = targetPool
            //targetCopy.position =
            var bit = distributeLayer.children[bitCount - 1] as! SKSpriteNode
            var bitAction = SKAction.sequence(
                [
                    SKAction.waitForDuration(0.3 * Double(animCount - bitCount)),
                    SKAction.scaleTo(1.5, duration: 0),
                    SKAction.runBlock({
                        let newPos = CGPoint(x: bit.position.x + self.distributeLayer.position.x ,
                                y: bit.position.y + self.distributeLayer.position.y)
                        bit.position = newPos
                        bit.removeFromParent()
                        self.poolLayer.addChild(bit)
                    }),
                    SKAction.group([
                        SKAction.moveTo(CGPoint(x : targetCopy.position.x + poolOffset.x, y: targetCopy.position.y + poolOffset.y), duration: 0.5),
                        SKAction.scaleTo(1.0, duration: 0.75)
                    ]),
                    SKAction.runBlock({
                        Audio.instance().play(Audio.Sound.COUNT_BIT)
                        completeBits++
                        targetCopy.incBit()
                    }),
                    SKAction.removeFromParent()
                ])
            bit.runAction(bitAction)
            bitCount--
            targetPool = targetPool.getNext()
            if targetPool == pool {
                targetPool = targetPool.getNext() // skip original pool
            }
        }
        
        var animCompleteAction = SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock({
                    if completeBits >= animCount {
                        self.distributeLayer.zRotation = 0
                        self.distributeLayer.setScale(1)
                        self.distributeLayer.removeAllActions()
                        self.distributeLayer.removeAllChildren()
                        self.checkScore(targetPool.getPrev())
                    }
                }),
                SKAction.waitForDuration(0)]
            )
        )
        distributeLayer.runAction(animCompleteAction)
    }
    
    func checkScore(var lastPool: Pool) {
        readyForNextTurn = true
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
            animateScore(lastPool, player: currentPlayer)
            lastPool.setBit(0)
            lastPool = lastPool.getPrev()
        }
    }
    
    func animateScore(var pool: Pool, player: PLAYER) {
        var targetPoint = CGPoint.zeroPoint
        if player == PLAYER.HUMAN {
            targetPoint = playerScoreLabel.position
            Audio.instance().play(Audio.Sound.PLAYER_SCORE)
            
        } else {
            targetPoint = aiScoreLabel.position
            Audio.instance().play(Audio.Sound.AI_SCORE)
        }
        for node in pool.children {
            var otherNode = node as! SKNode
            otherNode.position = pool.convertPoint(node.position, toNode: labelLayer)
            node.removeFromParent()
            labelLayer.addChild(otherNode)
            let scoreAction = SKAction.sequence([
                SKAction.moveTo(targetPoint, duration: 0.65),
                SKAction.removeFromParent()
                ])
            otherNode.runAction(scoreAction)
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
