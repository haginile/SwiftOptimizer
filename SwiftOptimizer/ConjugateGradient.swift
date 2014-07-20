//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//
//  ConjugateGradient.swift
//  SwiftOptimizer
//
//  Created by Helin Gai on 7/19/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation

class ConjugateGradient : LineSearchBasedMethod {
    init(lineSearch : LineSearch = ArmijoLineSearch()) {
        super.init(lineSearch: lineSearch)
    }
    
    override func getUpdatedDirection(inout problem: Problem, gold2: Double, gradient: matrix) -> matrix {
        var dir = (problem.squaredNorm / gold2) * lineSearch.searchDirection
        return lineSearch.lastGradient() * -1 + dir
    }
}