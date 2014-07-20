//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//
//  Method.swift
//  SwiftOptimizer
//
//  Created by Helin Gai on 7/19/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation

protocol OptimizationMethod {
    func minimize(inout problem : Problem, endCriteria : EndCriteria) -> EndCriteriaType
}