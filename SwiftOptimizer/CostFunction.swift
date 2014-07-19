//
//  CostFunction.swift
//  SwiftOptimizer
//
//  Created by Helin Gai on 7/19/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation

class CostFunction {
    
    func finiteDifferenceEpsilon() -> Double {
        return 1e-8
    }
    
    // must subclass
    func value(parameters : matrix) -> Double {
        return 0
    }
    
    // must subclass
    func values(parameters : matrix) -> matrix {
        return zeros(parameters.count)
    }
    
    func gradient(inout grad : matrix, parameters : matrix) {
        var eps = finiteDifferenceEpsilon()
        var fp : Double, fm : Double
        var xx = parameters
        
        for i in 0..<(parameters.count) {
            xx[i] += eps
            fp = value(xx)
            xx[i] -= eps
            fm = value(xx)
            grad[i] = 0.5 * (fp - fm) / eps
            xx[i] = parameters[i]
        }
    }
    
    func valueAndGradient(inout grad : matrix, parameters : matrix) -> Double {
        gradient(&grad, parameters : parameters)
        return value(parameters)
    }
    
}