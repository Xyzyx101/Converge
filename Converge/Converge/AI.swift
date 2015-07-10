//
//  AI.swift
//  Converge
//
//  Created by Andrew Perrault on 2015-07-02.
//  Copyright (c) 2015 Andrew Perrault. All rights reserved.
//

import Foundation

enum AI_TYPE {
    case POTATO
    case EASY
    case MED
    case HARD
}

class AI {
    let type: AI_TYPE?
    var aiBoard: AIBoard!
    
    init(type: AI_TYPE) {
        self.type = type
    }
    
    internal func getMove(pools: [Pool]) -> Int {
        
        switch self.type! {
        case .POTATO:
            return getPotatoMove(pools)
        case .EASY:
            var doIPotato = Int(arc4random_uniform(5))
            if doIPotato < 2 {
                return getPotatoMove(pools)
            } else {
                aiBoard = AIBoard(realPools: pools, recurseDepth: 0)
                var bestScore: Int = 0
                let bestMove = aiBoard.getBestMove(&bestScore)
                if bestMove == -1 {
                    return getPotatoMove(pools)
                }
                return bestMove
            }
        case .MED:
            aiBoard = AIBoard(realPools: pools, recurseDepth: 1)
            var bestScore: Int = 0
            let bestMove = aiBoard.getBestMove(&bestScore)
            if bestMove == -1 {
                return getPotatoMove(pools)
            }
            return bestMove
        case .HARD:
            aiBoard = AIBoard(realPools: pools, recurseDepth: 5)
            var bestScore: Int = 0
            let bestMove = aiBoard.getBestMove(&bestScore)
            if bestMove == -1 {
                return getPotatoMove(pools)
            }
            return bestMove
        }
    }
    
    func getPotatoMove(pools: [Pool]) -> Int {
        var poolIndex: Int
        do {
            poolIndex = Int(arc4random_uniform(12 - 6) + 6)
        } while(pools[poolIndex].getBit() == 0)
        return poolIndex
    }
}

class AIBoard {
    var isPlayerTurn = false
    var node = BoardNode()
    var pools: [BoardNode] = []
    var children: [AIBoard] = []
    var score = 0
    var recurseDepth = 0
    
    init(realPools: [Pool], recurseDepth: Int) {
        isPlayerTurn = false
        self.recurseDepth = recurseDepth
        for realPool in realPools {
            var node = BoardNode()
            node.value = realPool.getBit()
            node.isPlayerOwned = realPool.isPlayerOwned()
            pools.append(node)
        }
        pools[0].prev = pools[11]
        pools[0].next = pools[1]
        for (var i = 1; i < 11; ++i) {
            pools[i].prev = pools[i-1]
            pools[i].next = pools[i+1]
        }
        pools[11].prev = pools[10]
        pools[11].next = pools[0]
        evaluate()
    }
    
    init(fakePools: [BoardNode], recurseDepth: Int, isPlayerTurn: Bool) {
        self.isPlayerTurn = isPlayerTurn
        self.recurseDepth = recurseDepth
        var poolIdx = 0
        for fakePool in fakePools {
            var node = BoardNode()
            node.value = fakePool.value
            node.isPlayerOwned = fakePool.isPlayerOwned
            pools.append(node)
        }
        pools[0].prev = pools[11]
        pools[0].next = pools[1]
        for (var i = 1; i < 11; ++i) {
            pools[i].prev = pools[i-1]
            pools[i].next = pools[i+1]
        }
        pools[11].prev = pools[10]
        pools[11].next = pools[0]
    }
    
    func makeMove(poolIdx: Int) {
        var bitCount: Int = pools[poolIdx].value
        if bitCount == 0 {
            score = Int.min
            return
        }
        var originalPool = pools[poolIdx]
        originalPool.value = 0
        var targetPool: BoardNode = (pools[poolIdx].next)!
        while(bitCount > 0) {
            targetPool.value++
            bitCount--
            targetPool = targetPool.next!
            if targetPool === originalPool {
                targetPool = (targetPool.next)! // skip original pool
            }
        }
        var scorePool: BoardNode = (targetPool.prev)!
        while scorePool.isPlayerOwned == isPlayerTurn {
            let value = scorePool.value
            if value == 2 || value == 4 || value == 8 || value == 16 {
                score += value
                scorePool = (scorePool.prev)!
            } else {
                break
            }
        }
    }
    
    func evaluate() {
        if score == Int.min {
            return
        }
        var first, last : Int
        if isPlayerTurn {
            first = 0
            last = 6
        } else {
            first = 6
            last = 12
        }
        for (var i = first; i<last; ++i) {
            var newBoard = AIBoard(fakePools: self.pools, recurseDepth: self.recurseDepth - 1, isPlayerTurn: !isPlayerTurn)
            children.append(newBoard)
            newBoard.makeMove(i)
            if recurseDepth > 0 {
                newBoard.evaluate()
            }
        }
    }
    
    func getBestMove(inout prevBestScore: Int) -> Int {
        if children.count == 0 {
            prevBestScore += self.score
            return -1
        }
        var bestScore: Int = Int.min
        var bestMove: Int = -1
        var evaluateScore = 0
        var evaluateBest = -1
        for var i = 0; i < children.count; ++i {
            evaluateScore = 0
            evaluateBest = children[i].getBestMove(&evaluateScore)
            if evaluateScore > bestScore {
                bestScore = evaluateScore
                if isPlayerTurn {
                    bestMove = i
                } else {
                    bestMove = i + 6
                }
            }
        }
        
        // This case should only happen when the board would be cleared resulting in a win
        if bestScore == Int.min {
            bestScore = 24
        }
        
        if isPlayerTurn {
            bestScore *= -1
        }
        prevBestScore = bestScore + self.score
        return bestMove
    }
}

class BoardNode {
    internal weak var next: BoardNode! = nil
    internal weak var prev: BoardNode! = nil
    var value: Int = 0
    var isPlayerOwned = false
}


