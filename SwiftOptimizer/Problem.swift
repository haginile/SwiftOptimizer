//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//
//  Problem.swift
//  SwiftOptimizer
//
//  Created by Helin Gai on 7/19/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation

class Problem {
    
    var costFunction : CostFunction
    var constraint : Constraint
    var currentValue : matrix
    
    var functionValue = 0.0
    var squaredNorm = 0.0
    var functionEvaluation = 0
    var gradientEvaluation = 0
    
    init(costFunction : CostFunction, constraint : Constraint, initialValue : matrix) {
        self.costFunction = costFunction
        self.constraint = constraint
        self.currentValue = initialValue
    }
    
    func reset() {
        functionEvaluation = 0
        gradientEvaluation = 0
        functionValue = 0.0
        squaredNorm = 0.0
    }
    
    func value(parameters : matrix) -> Double {
        functionEvaluation++
        return costFunction.value(parameters)
    }
    
    func values(parameters : matrix) -> matrix {
        functionEvaluation++
        return costFunction.values(parameters)
    }
    
    func gradient(inout grad : matrix, parameters : matrix) {
        gradientEvaluation++
        costFunction.gradient(&grad, parameters: parameters)
    }
    
    func valueAndGradient(inout grad : matrix, parameters : matrix) -> Double {
        functionEvaluation++
        gradientEvaluation++
        return costFunction.valueAndGradient(&grad, parameters: parameters)
    }
    
}