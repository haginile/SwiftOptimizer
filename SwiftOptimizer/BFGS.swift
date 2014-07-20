//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//
//  BFGS.swift
//  SwiftOptimizer
//
//  Created by Helin Gai on 7/19/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation

class BFGS : LineSearchBasedMethod {
    
    var inverseHessian : matrix2d
    
    init(lineSearch: LineSearch = ArmijoLineSearch()) {
        inverseHessian = matrix2d(columns: 0, rows: 0)
        super.init(lineSearch : lineSearch)
    }
    
    override func getUpdatedDirection(inout problem: Problem, gold2: Double, gradient: matrix) -> matrix {
        if (inverseHessian.rows == 0) {
            inverseHessian = zeros((problem.currentValue.count, problem.currentValue.count))
            for i in 0..<(problem.currentValue.count) {
                inverseHessian[i,i] = 1.0
            }
        }
        
        var diffGradient : matrix
        var diffGradientWithHessianApplied = zeros(problem.currentValue.count)
        
        diffGradient = lineSearch.lastGradient() - gradient
        for i in 0..<problem.currentValue.count {
            for j in 0..<problem.currentValue.count {
                diffGradientWithHessianApplied[i] += inverseHessian[i,j] * diffGradient[j]
            }
        }
        
        var fac = 0.0
        var fae = 0.0
        var fad : Double
        var sumdg = 0.0
        var sumxi = 0.0
        
        for i in 0..<(problem.currentValue.count) {
            fac += diffGradient[i] * lineSearch.searchDirection[i]
            fae += diffGradient[i] * diffGradientWithHessianApplied[i]
            sumdg += pow(diffGradient[i], 2.0)
            sumxi += pow(lineSearch.searchDirection[i], 2.0)
        }
        
        if fac > sqrt(1e-8 * sumdg * sumxi) {
            fac = 1.0 / fac
            fad = 1.0 / fae
            for i in 0..<problem.currentValue.count {
                diffGradient[i] = fac * lineSearch.searchDirection[i] - fad * diffGradientWithHessianApplied[i]
            }
            
            for i in 0..<problem.currentValue.count {
                for j in 0..<problem.currentValue.count {
                    inverseHessian[i,j] += fac * lineSearch.searchDirection[i] * lineSearch.searchDirection[j]
                    inverseHessian[i,j] -= fad * diffGradientWithHessianApplied[i] * diffGradientWithHessianApplied[j]
                    inverseHessian[i,j] += fae * diffGradient[i] * diffGradient[j]
                }
            }
        }
        
        var direction = matrix(n : problem.currentValue.count)
        for i in 0..<problem.currentValue.count {
            direction[i] = 0.0
            for j in 0..<problem.currentValue.count {
                direction[i] -= inverseHessian[i,j] * lineSearch.lastGradient()[j]
            }
        }
        
        return direction
        
    }
}