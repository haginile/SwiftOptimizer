//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//
//  LineSearch.swift
//  SwiftOptimizer
//
//  Created by Helin Gai on 7/19/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation

class LineSearch {
    var searchDirection : matrix
    var xtd : matrix
    var gradient : matrix
    var qt = 0.0
    var qpt = 0.0
    var succeed = true
    
    init() {
        searchDirection = zeros(0)
        xtd = zeros(0)
        gradient = zeros(0)
    }
    
    func lastX() -> matrix {
        return xtd
    }
    
    func lastFunctionValue() -> Double {
        return qt
    }
    
    func lastGradient() -> matrix {
        return gradient
    }
    
    func lastGradientNorm2() -> Double {
        return qpt
    }
    
    func search(inout problem : Problem, inout endCriteriaType : EndCriteriaType, endCriteria : EndCriteria, initialValue : Double) -> Double { return 0.0 }
    
    func update(inout parameters : matrix, direction : matrix, beta : Double, constraint : Constraint) -> Double {
        var diff = beta
        var newParams = parameters + diff * direction
        var valid = constraint.test(newParams)
        var icount = 0
        while !valid {
            assert (icount <= 200, "Can't update linesearch!")
            diff *= 0.5
            icount++
            newParams = parameters + diff * direction
            valid = constraint.test(newParams)
        }
        parameters = parameters + diff * direction
        return diff
    }
    
    
    
}