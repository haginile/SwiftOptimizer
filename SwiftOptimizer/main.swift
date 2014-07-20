//
//  main.swift
//  SwiftOptimizer
//
//  Created by Helin Gai on 7/19/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation

class RosenBrockFunction: CostFunction
{
    override func value(parameters: matrix) -> Double {
        var res = (1.0 - parameters[0]) * (1.0 - parameters[0])
        var a = parameters[1] - parameters[0] * parameters[0]
        var b = parameters[1] - parameters[0] * parameters[0]
        res = res + 100.0 * a * b
        return res
    }

    override func values(parameters: matrix) -> matrix {
        var res = zeros(1)
        res[0] = value(parameters)
        return res
    }
}

var myEndCrit = EndCriteria(maxIterations: 1000, maxStationaryStateIterations: 100, rootEpsilon: 1.0e-8, functionEpsilon: 1.0e-9, gradientNormEpsilon: 1.0e-5)
var myFunc = RosenBrockFunction()
var constraint = NoConstraint()
var initial = zeros(2)
var problem = Problem(costFunction: myFunc, constraint: constraint, initialValue: initial)

var solver = Simplex(lambda: 0.1)
var solved = solver.minimize(problem, endCriteria: myEndCrit)

println(problem.currentValue)