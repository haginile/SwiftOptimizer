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
        return pow(1.0 - parameters[0], 2) + 100 * pow(parameters[1] - pow(parameters[0], 2), 2.0)
    }

    override func values(parameters: matrix) -> matrix {
        var res = zeros(1)
        res[0] = value(parameters)
        return res
    }
}

var myEndCriteria = EndCriteria(maxIterations: 1000, maxStationaryStateIterations: 100, rootEpsilon: 1.0e-8, functionEpsilon: 1.0e-9, gradientNormEpsilon: 1.0e-5)
var myFunc = RosenBrockFunction()
var constraint = NoConstraint()
var initialValue = zeros(2)
initialValue[0] = 2.0
initialValue[1] = 0.1

var problem = Problem(costFunction: myFunc, constraint: constraint, initialValue: initialValue)

var solver = Simplex(lambda: 0.1)
var solved = solver.minimize(&problem, endCriteria: myEndCriteria)

println(problem.currentValue)


var problem2 = Problem(costFunction: myFunc, constraint: constraint, initialValue: initialValue)
var bfgsSolver = BFGS()
var bfgsSolved = bfgsSolver.minimize(&problem2, endCriteria: myEndCriteria)
println(problem2.currentValue)


var problem3 = Problem(costFunction: myFunc, constraint: constraint, initialValue: initialValue)
var conjSolver = ConjugateGradient()
var conjSolved = conjSolver.minimize(&problem3, endCriteria: myEndCriteria)
println(problem3.currentValue)