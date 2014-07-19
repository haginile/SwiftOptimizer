//
//  CostFunction.swift
//  SwiftOptimizer
//
//  Created by Helin Gai on 7/19/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation

class CostFunction {
    
    init() {
        
    }
    
    func value(x : matrix) -> Double {
        return 0
    }
    
    func values(x : matrix) -> matrix {
        return zeros(1)
    }
    
    func gradient(grad : matrix, x : matrix) {
        
    }
    
    
}