//
//  Pool.swift
//  Converge
//
//  Created by Andrew Perrault on 2015-06-24.
//  Copyright (c) 2015 Andrew Perrault. All rights reserved.
//

import SpriteKit

class Pool: SKSpriteNode {
    weak var next: Pool! = nil
    weak var prev: Pool! = nil
    
    init(origin: CGPoint, width: CGFloat, height: CGFloat) {
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
}