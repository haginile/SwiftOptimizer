//
//  swixExtension.swift
//  SwiftOptimizer
//
//  Created by Helin Gai on 7/19/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation

@infix func *! (vector1 : matrix, vector2 : matrix) -> Double {
    
    // I think swix will implement this, but doesn't seem to be working right no
    // convert to accelerate?
    var res = 0.0
    for i in 0..<(vector1.count) {
        res += vector1[i] * vector2[i]
    }
    return res
}