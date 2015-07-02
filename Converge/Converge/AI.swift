//
//  AI.swift
//  Converge
//
//  Created by Andrew Perrault on 2015-07-02.
//  Copyright (c) 2015 Andrew Perrault. All rights reserved.
//

import Foundation

enum AI_TYPE {
    case GARBAGE
    case EASY
    case HARD
}

class AI {
    let type: AI_TYPE?
    
    init(type: AI_TYPE) {
        self.type = type
    }
    
    internal func getMove(pools: [Pool]) -> Int {
        switch self.type! {
        case .GARBAGE:
            return getGarbageMove(pools)
        case .EASY:
            break
        case .HARD:
            break
        }
        return 0
    }
    
    func getGarbageMove(pools: [Pool]) -> Int {
        var poolIndex: Int
        do {
            poolIndex = Int(arc4random_uniform(12 - 6) + 6)
        } while(pools[poolIndex].getBit() == 0)
        return poolIndex
    }
}