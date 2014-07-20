//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//
//  LineSearchBasedMethod.swift
//  SwiftOptimizer
//
//  Created by Helin Gai on 7/19/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation

class LineSearchBasedMethod : OptimizationMethod {
    var lineSearch : LineSearch
    
    init(lineSearch : LineSearch = ArmijoLineSearch()) {
        self.lineSearch = lineSearch
    }
    
    func minimize(inout problem: Problem, endCriteria: EndCriteria) -> EndCriteriaType {
        // Initializations
        var ftol = endCriteria.functionEpsilon
        var maxStationaryStateIterations_ = endCriteria.maxStationaryStateIterations
        var ecType = EndCriteriaType.None
        problem.reset()                                      // reset problem
        
        var x_ = problem.currentValue              // store the starting point
        var iterationNumber_ = 0
        
        // dimension line search
        lineSearch.searchDirection = zeros(x_.count)
        var done = false
        
        // function and squared norm of gradient values;
        var fnew : Double
        var fold : Double
        var gold2 : Double
        var fdiff : Double
        
        // classical initial value for line-search step
        var t = 1.0
        // Set gradient g at the size of the optimization problem
        // search direction
        var sz = lineSearch.searchDirection.count
        
        var prevGradient = zeros(sz)
        var d = zeros(sz)
        var sddiff = zeros(sz)
        var direction = zeros(sz)
        
        // Initialize cost function, gradient prevGradient and search direction
        problem.functionValue = problem.valueAndGradient(&prevGradient, parameters:  x_)
        problem.squaredNorm = prevGradient *! prevGradient
        lineSearch.searchDirection = prevGradient * -1
        
        var first_time = true
        // Loop over iterations
        do {
            // Linesearch
            if (!first_time) {
                prevGradient = lineSearch.lastGradient()
            }
            
            t = lineSearch.search(&problem, endCriteriaType: &ecType, endCriteria: endCriteria, initialValue: t)
            
            // don't throw: it can fail just because maxIterations exceeded
            if (lineSearch.succeed)
            {
                // Updates
                
                // New point
                x_ = lineSearch.lastX()
                // New function value
                fold = problem.functionValue
                problem.functionValue = lineSearch.lastFunctionValue()
                // New gradient and search direction vectors
                
                // orthogonalization coef
                gold2 = problem.squaredNorm
                problem.squaredNorm = lineSearch.lastGradientNorm2()
                
                // conjugate gradient search direction
                direction = getUpdatedDirection(&problem, gold2: gold2, gradient: prevGradient);
                
                sddiff = direction - lineSearch.searchDirection
                lineSearch.searchDirection = direction
                
                // Now compute accuracy and check end criteria
                // Numerical Recipes exit strategy on fx (see NR in C++, p.423)
                fnew = problem.functionValue
                fdiff = 2.0 * abs(fnew-fold) / (abs(fnew) + abs(fold)) // + 1e-100)
                if (fdiff < ftol ||
                    endCriteria.checkMaxIterations(iterationNumber_, endCriteriaType: &ecType)) {
                        endCriteria.checkStationaryFunctionValue(0.0, fxNew: 0.0,
                            stationaryStateIterations: &maxStationaryStateIterations_, endCriteriaType: &ecType);
                        endCriteria.checkMaxIterations(iterationNumber_, endCriteriaType: &ecType)
                        return ecType
                }
                problem.currentValue = x_      // update problem current value
                iterationNumber_++         // Increase iteration number
                first_time = false
            } else {
                done = true
            }
        } while (!done)
        
        problem.currentValue = x_
        return ecType
    }
    
    func getUpdatedDirection(inout problem : Problem, gold2 : Double, gradient : matrix) -> matrix {
        return matrix(n : 0)
    }
}