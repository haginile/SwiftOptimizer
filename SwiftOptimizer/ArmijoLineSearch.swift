//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//
//  ArmijoLineSearch.swift
//  SwiftOptimizer
//
//  Created by Helin Gai on 7/19/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation

class ArmijoLineSearch : LineSearch {
    
    var alpha : Double
    var beta : Double

    init(eps : Double = 1e-8, alpha : Double = 0.05, beta : Double = 0.65) {
        self.alpha = alpha
        self.beta = beta
        
        super.init()
    }
    
    override func search(inout problem: Problem, inout endCriteriaType: EndCriteriaType, endCriteria: EndCriteria, initialValue: Double) -> Double {
        var constraint = problem.constraint
        succeed = true
        
        var maxIter = false
        var qtold : Double
        var t = initialValue
        var loopNumber = 0
        
        var q0 : Double = problem.functionValue
        var qp0 : Double = problem.squaredNorm
        
        qt = q0
        
        //@
        qpt = qp0
        
        gradient = zeros(problem.currentValue.count)
        xtd = problem.currentValue
        t = update(&xtd, direction: searchDirection, beta: t, constraint: constraint)
        qt = problem.value(xtd)
        
        if qt - q0 > (-alpha * t * qpt) {
            
            do {
                loopNumber++
                t *= beta
                qtold = qt
                xtd = problem.currentValue
                t = update(&xtd, direction: searchDirection, beta: t, constraint: constraint)
                
                qt = problem.value(xtd)
                problem.gradient(&gradient, parameters: xtd)
                maxIter = endCriteria.checkMaxIterations(loopNumber, endCriteriaType: &endCriteriaType)
                
            } while ((((qt - q0) > (-alpha * t * qpt)) || ((qtold - q0) <= (-alpha * t * qpt / beta))) &&
                (!maxIter))
            
        }
        
        if maxIter {
            succeed = false
        }
        
        problem.gradient(&gradient, parameters: xtd)
        qpt = gradient *! gradient
        return t
        
    }
    
    
}