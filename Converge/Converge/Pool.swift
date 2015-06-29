//
//  Pool.swift
//  Converge
//
//  Created by Andrew Perrault on 2015-06-24.
//  Copyright (c) 2015 Andrew Perrault. All rights reserved.
//

import SpriteKit

class Pool: SKSpriteNode {
    private weak var next: Pool! = nil
    private weak var prev: Pool! = nil
    private var bitCount : Int = 0
    private var bitSize : CGFloat = 0
    private var bitTex = SKTexture(imageNamed: "bit")
    private var playerOwned = false
    
    init(origin: CGPoint, width: CGFloat, height: CGFloat, bitSize: CGFloat) {
        self.bitSize = bitSize
        var texture = SKTexture(imageNamed: "pool")
        var color = UIColor(white: CGFloat(1), alpha: CGFloat(1))
        var size = CGSize(width: width, height: height)
        super.init(texture: texture, color: color, size: size)
        anchorPoint = CGPoint.zeroPoint
        position = CGPoint(x: origin.x, y: origin.y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        [super.init(coder: aDecoder)]
    }
    
    func calculateBitPositions() {
        var bitPosition: [CGPoint] = []
        var xHalf = CGFloat(self.frame.width / 2.0)
        var yHalf = CGFloat(self.frame.height / 2.0)
        var xThird = CGFloat(self.frame.width / 3.0)
        var yThird = CGFloat(self.frame.height / 3.0)
        var xForth = CGFloat(self.frame.width / 4.0)
        var yForth = CGFloat(self.frame.height / 4.0)
        var xFifth = CGFloat(self.frame.width / 5.0)
        var yFifth = CGFloat(self.frame.height / 5.0)
        var xSixth = CGFloat(self.frame.width / 6.0)
        var ySixth = CGFloat(self.frame.height / 6.0)
        var yNinth = CGFloat(self.frame.height / 9.0)
        switch bitCount {
        case 1...5:
            switch bitCount {
            case 5:
                drawBit(x: xHalf, y: yHalf)
                fallthrough
            case 4:
                drawBit(x: 2 * xThird, y: yThird)
                fallthrough
            case 3:
                drawBit(x: xThird, y: 2 * yThird)
                fallthrough
            case 2:
                drawBit(x: 2 * xThird, y: 2 * yThird)
                fallthrough
            case 1:
                drawBit(x: xThird, y: yThird)
            default:
                break
            }
        case 6...8:
            switch bitCount {
            case 8:
                drawBit(x: xHalf, y: 2 * yThird)
                fallthrough
            case 7:
                drawBit(x: xHalf, y: yThird)
                fallthrough
            case 6:
                drawBit(x: xThird, y: yForth)
                drawBit(x: xThird, y: 2 * yForth)
                drawBit(x: xThird, y: 3 * yForth)
                drawBit(x: 2 * xThird, y: yForth)
                drawBit(x: 2 * xThird, y: 2 * yForth)
                drawBit(x: 2 * xThird, y: 3 * yForth)
                fallthrough
            default:
                break
            }
            break //DELETEME
        case 9...12:
            switch bitCount {
            case 12:
                drawBit(x: 3 * xForth, y: yFifth)
                fallthrough
            case 11:
                drawBit(x: 2 * xForth, y: yFifth)
                fallthrough
            case 10:
                drawBit(x: xForth, y: yFifth)
                fallthrough
            case 9:
                for(var r = CGFloat(4); r > 1; --r) {
                    for (var c = CGFloat(1); c < 4; ++c) {
                        drawBit(x: c * xForth, y: r * yFifth)
                    }
                }
            default:
                break
            }
        case 13...16:
            switch bitCount {
            case 16:
                drawBit(x: 4 * xFifth, y: yFifth)
                fallthrough
            case 15:
                drawBit(x: 3 * xFifth, y: yFifth)
                fallthrough
            case 14:
                drawBit(x: 2 * xFifth, y: yFifth)
                fallthrough
            case 13:
                drawBit(x: xFifth, y: yFifth)
                fallthrough
            default:
                for(var r = CGFloat(4); r > 1; --r) {
                    for (var c = CGFloat(1); c < 5; ++c) {
                        drawBit(x: c * xFifth, y: r * yFifth)
                    }
                }
                break
            }
        case 17...30:
            switch bitCount {
            case 30:
                drawBit(x: 2 * xThird, y: 4 * yFifth, z: 10)
                fallthrough
            case 29:
                drawBit(x: xThird, y: 4 * yFifth, z: 10)
                fallthrough
            case 28:
                drawBit(x: 2 * xThird, y: 2 * yForth, z: 10)
                fallthrough
            case 27:
                drawBit(x: xThird, y: 2 * yForth, z: 10)
                fallthrough
            case 26:
                drawBit(x: 2 * xThird, y: yFifth, z: 10)
                fallthrough
            case 25:
                drawBit(x: xThird, y: yFifth, z: 10)
                fallthrough
            case 24:
                drawBit(x: 4 * xFifth, y: 8 * yNinth)
                fallthrough
            case 23:
                drawBit(x: 3 * xFifth, y: 8 * yNinth)
                fallthrough
            case 22:
                drawBit(x: 2 * xFifth, y: 8 * yNinth)
                fallthrough
            case 21:
                drawBit(x: xFifth, y: 8 * yNinth)
                fallthrough
            case 20:
                drawBit(x: 4 * xFifth, y: 7 * yNinth)
                fallthrough
            case 19:
                drawBit(x: 3 * xFifth, y: 7 * yNinth)
                fallthrough
            case 18:
                drawBit(x: 2 * xFifth, y: 7 * yNinth)
                fallthrough
            case 17:
                drawBit(x: xFifth, y: 7 * yNinth)
                fallthrough
            default:
                for ( var r = CGFloat(1); r < 5	; ++r) {
                    for (var c = CGFloat(1); c < 5; ++c) {
                        switch r {
                        case 1...2:
                            drawBit(x: c * xFifth, y: r * yNinth)
                        case 3...4:
                            drawBit(x: c * xFifth, y: (r + 1) * yNinth)
                        default:
                            break
                        }
                    }
                }
            }
        default:
            
            break
        }
    }
    
    func drawBit(#x: CGFloat, y: CGFloat, z: CGFloat = CGFloat(0)) {
        var bit = SKSpriteNode(texture: bitTex, size: CGSize(width: bitSize, height: bitSize))
        bit.position = CGPoint(x: x, y: y)
        bit.zPosition = z
        self.addChild(bit)
    }
    
    internal func redraw() {
        removeAllChildren()
        calculateBitPositions()
    }
    
    internal func incBit() {
        ++bitCount
        redraw()
    }
    
    internal func decBit() {
        if bitCount > 0 {
            --bitCount
        }
        redraw()
    }
    
    internal func setBit(value: Int) {
        bitCount = value
        redraw()
    }
    
    internal func setPlayerOwned(value: Bool) {
        playerOwned = value
    }
    
    internal func isPlayerOwned() -> Bool {
        return playerOwned
    }
    
    internal func setNext(value: Pool) {
        next = value
    }
    
    internal func getNext() -> Pool {
        return next
    }
    
    internal func setPrev(value: Pool) {
        prev = value
    }
    
    internal func getPrev() -> Pool {
        return prev
    }
}