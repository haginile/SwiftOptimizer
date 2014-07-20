//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//
//  CostFunction.swift
//  SwiftOptimizer
//
//  Created by Helin Gai on 7/19/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation

/**
*  Base class for the cost function (i.e., objective function)
*/
class CostFunction {
    
    func finiteDifferenceEpsilon() -> Double {
        return 1.0e-8
    }
    
    // must subclass
    func value(parameters : matrix) -> Double {
        return 1.0e8
    }
    
    // must subclass
    func values(parameters : matrix) -> matrix {
        return zeros(parameters.count) + 1.0e8
    }
    
    func gradient(inout grad : matrix, parameters : matrix) {
        var eps = finiteDifferenceEpsilon()
        var fp : Double, fm : Double
        var xx = parameters
        
        for i in 0..<(parameters.count) {
            xx[i] += eps
            fp = value(xx)
            xx[i] -= 2.0 * eps
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