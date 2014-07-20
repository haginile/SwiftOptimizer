//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//
//  LeastSquare.swift
//  SwiftOptimizer
//
//  Created by Helin Gai on 7/19/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation

protocol LeastSquareProblem {
    
    /**
    *  size of the target vector
    */
    func size() -> Int
    
    /**
    *  compute the target vetor and the values of the function to fit
    */
    func targetAndValue(parameters : matrix, inout target : matrix, inout fct2fit : matrix)
    
    func targetValueAndGradient(parameters : matrix, inout grad_fct2fit : matrix2d, inout target : matrix, inout fct2fit : matrix)
}


class LeastSquareFunction : CostFunction {
    var leastSquareProblem : LeastSquareProblem
    
    init(leastSquareProblem : LeastSquareProblem) {
        self.leastSquareProblem = leastSquareProblem
    }
    
    override func value(parameters : matrix) -> Double {
        var target = zeros(leastSquareProblem.size())
        var fct2fit = zeros(leastSquareProblem.size())
        
        leastSquareProblem.targetAndValue(parameters, target: &target, fct2fit: &fct2fit)
        var diff = target - fct2fit
        return diff *! diff
    }
    
    override func values(parameters : matrix) -> matrix {
        var target = zeros(leastSquareProblem.size())
        var fct2fit = zeros(leastSquareProblem.size())
        
        leastSquareProblem.targetAndValue(parameters, target: &target, fct2fit: &fct2fit)
        var diff = target - fct2fit
        return diff * diff //@ need to check this

    }
    
    override func gradient(inout grad : matrix, parameters : matrix) {
        var target = zeros(leastSquareProblem.size())
        var fct2fit = zeros(leastSquareProblem.size())
        var grad_fct2fit = matrix2d(columns: parameters.count, rows: leastSquareProblem.size())
        
        leastSquareProblem.targetValueAndGradient(parameters, grad_fct2fit: &grad_fct2fit, target: &target, fct2fit: &fct2fit)
        
        var diff = target - fct2fit

    }
    
}