//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//
//  Simplex.swift
//  SwiftOptimizer
//
//  Created by Helin Gai on 7/19/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation


class Simplex : OptimizationMethod {
    var lambda : Double
    var vertices : [matrix]
    var values : matrix
    var sum_ : matrix
    
    init(lambda : Double) {
        self.lambda = lambda
        self.vertices = [matrix]()
        self.values = zeros(0)
        self.sum_ = zeros(0)
    }
    
    func extrapolate(problem : Problem, iHighest : Int, inout factor : Double) -> Double {
        var pTry : matrix
        do {
            var dimensions = values.count - 1
            var factor1 = (1.0 - factor) / Double(dimensions)
            var factor2 = factor1 - factor
            pTry = sum_ * factor1 - vertices[iHighest] * factor2
            factor *= 0.5
        
        } while (!problem.constraint.test(pTry) && abs(factor) > 1e-100)
        
        if (abs(factor) <= 1e-100) {
            return values[iHighest]
        }
        
        factor *= 2.0
        var vTry : Double = problem.value(pTry)
        if (vTry < values[iHighest]) {
            values[iHighest] = vTry
            sum_ = sum_ + pTry - vertices[iHighest]
            vertices[iHighest] = pTry
        }
        
        return vTry
    }
    
    
    func minimize(inout problem: Problem, endCriteria: EndCriteria) -> EndCriteriaType {
        var xtol = endCriteria.rootEpsilon
        var maxStationaryStateIterations = endCriteria.maxStationaryStateIterations
        var ecType = EndCriteriaType.None
        problem.reset()

        var x_ = problem.currentValue
        var iterationNumber = 0
        
        var end = false
        var n = x_.count
        var i : Int
        
        vertices = [matrix](count : n + 1, repeatedValue : x_)
        for i in 0..<n {
            var direction = zeros(n)
            direction[i] = 1.0
            problem.constraint.update(&vertices[i+1], direction: direction, beta: lambda)
        }
        

        values = zeros(n + 1)
        for i in 0...n {
            values[i] = problem.value(vertices[i])
        }
        
        do {
            sum_ = zeros(n);
            for i in 0...n {
                sum_ = sum_ + vertices[i];
            }

            // Determine the best (iLowest), worst (iHighest)
            // and 2nd worst (iNextHighest) vertices
            var iLowest = 0;
            var iHighest : Int
            var iNextHighest : Int
            
            if values[0] < values[1] {
                iHighest = 1;
                iNextHighest = 0;
            } else {
                iHighest = 0;
                iNextHighest = 1;
            }

            for i in 1...n {
                if values[i] > values[iHighest] {
                    iNextHighest = iHighest;
                    iHighest = i;
                } else {
                    if values[i] > values[iNextHighest] && i != iHighest {
                        iNextHighest = i;
                    }
                    
                }
                if values[i] < values[iLowest] {
                    iLowest = i;
                }
            }

            var simplexSize = computeSimplexSize(vertices)
            iterationNumber++

            if (simplexSize < xtol || endCriteria.checkMaxIterations(iterationNumber, endCriteriaType: &ecType)) {
                endCriteria.checkStationaryPoint(0.0, xNew: 0.0, stationaryStateIterations: &maxStationaryStateIterations, endCriteriaType: &ecType)
                    endCriteria.checkMaxIterations(iterationNumber, endCriteriaType: &ecType)
                    x_ = vertices[iLowest]
                    var low = values[iLowest]
                    problem.functionValue = low
                    problem.currentValue = x_
                    return ecType;
                
            }
            // If end criteria is not met, continue
            var factor = -1.0
            var vTry = extrapolate(problem, iHighest: iHighest, factor: &factor)
            
            if (vTry <= values[iLowest]) && (factor == -1.0) {
                factor = 2.0;
                extrapolate(problem, iHighest: iHighest, factor: &factor);
            }
            else if (abs(factor) > 1e-100) {
                if (vTry >= values[iNextHighest]) {
                    var vSave = values[iHighest];
                    factor = 0.5
                    vTry = extrapolate(problem, iHighest: iHighest, factor: &factor);
                    if vTry >= vSave && abs(factor) > 1e-100 {
                        for i in 0...n {
                            if i != iLowest {

                                vertices[i] = vertices[i] + vertices[iLowest];
                                vertices[i] = vertices[i] * 0.5;
                                values[i] = problem.value(vertices[i]);
                            }
                        }
                    }
                }
            }
            // If can't extrapolate given the constraints, exit
            if abs(factor) <= 1e-100 {
                x_ = vertices[iLowest]
                var low = values[iLowest]
                problem.functionValue = low
                problem.currentValue = x_
                return EndCriteriaType.StationaryFunctionValue
            }
        } while (end == false)
        
    }
}


func computeSimplexSize(vertices : [matrix]) -> Double {
    var center = vertices[0]
    for i in 0..<(center.count) {
        center[i] = 0.0
    }
    
    for i in 0..<(vertices.count) {
        center = center + vertices[i]
    }
    
    center = center * 1.0 / Double(vertices.count)
    
    var result = 0.0
    for i in 0..<(vertices.count) {
        var temp = vertices[i] - center
        result += sqrt(temp *! temp)
    }
    
    return result / Double(vertices.count)
}