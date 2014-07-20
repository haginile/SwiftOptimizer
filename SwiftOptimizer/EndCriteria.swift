//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//
//  EndCriteria.swift
//  SwiftOptimizer
//
//  Created by Helin Gai on 7/19/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation

enum EndCriteriaType {
    case None,
    MaxIterations,
    StationaryPoint,
    StationaryFunctionValue,
    StationaryFunctionAccuracy,
    ZeroGradientNorm,
    Unknown
}

class EndCriteria {
    
    var maxIterations : Int
    var maxStationaryStateIterations : Int
    var rootEpsilon : Double
    var functionEpsilon : Double
    var gradientNormEpsilon : Double
    
    init(maxIterations : Int, maxStationaryStateIterations : Int,
        rootEpsilon : Double, functionEpsilon : Double,
        gradientNormEpsilon : Double) {
        self.maxIterations = maxIterations
        self.maxStationaryStateIterations = maxStationaryStateIterations
        self.rootEpsilon = rootEpsilon
        self.functionEpsilon = functionEpsilon
        self.gradientNormEpsilon = gradientNormEpsilon
            
        //@ missing treatment
    }
    
    func checkMaxIterations(iteration: Int, inout endCriteriaType : EndCriteriaType) -> Bool {
        if iteration < maxIterations {
            return false
        }
        
        endCriteriaType = EndCriteriaType.MaxIterations
        return true
    }
    
    func checkStationaryPoint(xOld : Double, xNew : Double, inout stationaryStateIterations : Int, inout endCriteriaType : EndCriteriaType) -> Bool {
        if abs(xNew - xOld) >= rootEpsilon {
            stationaryStateIterations = 0
            return false
        }
        stationaryStateIterations++
        if (stationaryStateIterations <= maxStationaryStateIterations) {
            return false
        }
        endCriteriaType = EndCriteriaType.StationaryPoint
        return false
    }
    
    
    func checkStationaryFunctionValue(fxOld : Double, fxNew : Double, inout stationaryStateIterations : Int, inout endCriteriaType : EndCriteriaType) -> Bool {
        
        if abs(fxNew-fxOld) >= functionEpsilon {
            stationaryStateIterations = 0
            return false
        }
        stationaryStateIterations++
        if stationaryStateIterations <= maxStationaryStateIterations {
            return false
        }

        endCriteriaType = EndCriteriaType.StationaryFunctionValue
        return false
    }

    
    func checkStationaryFunctionAccuracy(f : Double, positiveOptimization : Bool, inout endCriteriaType : EndCriteriaType) -> Bool {
        if (!positiveOptimization) {
            return false
        }
        if (f >= functionEpsilon) {
            return false
        }
        endCriteriaType = EndCriteriaType.StationaryFunctionAccuracy
        return true;
    }
    
    func checkZeroGradientNorm(gradientNorm : Double, inout endCriteriaType : EndCriteriaType) -> Bool {
        if (gradientNorm >= gradientNormEpsilon) {
            return false
        }
        endCriteriaType = EndCriteriaType.ZeroGradientNorm
        return true;
    }
    
    func check(iteration : Int, inout stationaryStateIterations : Int, positiveOptimization : Bool, fold : Double, normgold : Double, fnew : Double, normgnew : Double, inout endCriteriaType : EndCriteriaType) -> Bool {
        
        return (checkMaxIterations(iteration, endCriteriaType: &endCriteriaType) ||
                checkStationaryFunctionValue(fold, fxNew: fnew, stationaryStateIterations: &stationaryStateIterations, endCriteriaType: &endCriteriaType) ||
                checkStationaryFunctionAccuracy(fnew, positiveOptimization: positiveOptimization, endCriteriaType: &endCriteriaType) ||
                checkZeroGradientNorm(normgnew, endCriteriaType: &endCriteriaType))
    }

    
}