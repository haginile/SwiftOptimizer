//
//  This file is derived from QuantLib. The license of QuantLib is available online at <http://quantlib.org/license.shtml>.
//
//
//  Constraint.swift
//  SwiftOptimizer
//
//  Created by Helin Gai on 7/19/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation

class Constraint {
    class Impl {
        func test(parameters : matrix) -> Bool {
            return true
        }
    }
    
    var impl : Impl
    
    init(impl : Constraint.Impl) {
        self.impl = impl
    }
    
    func test(parameters : matrix) -> Bool {
        return impl.test(parameters)
    }
    
    func update(inout parameters : matrix, direction : matrix, beta : Double) -> Double {
        var diff = beta
        var newParams = parameters + diff * direction
        var valid = test(newParams)
        var icount = 0
        while !valid {
            assert(icount <= 200, "#Can't update parameter vector!")
            diff *= 0.5
            icount++
            newParams = parameters + diff * direction
            valid = test(newParams)
        }
        
        parameters = parameters + diff * direction
        return diff
    }
}


/**
 *  No constraint of any kind
 */
class NoConstraint : Constraint {
    class NoConstraintImpl : Constraint.Impl {
        override func test(parameters : matrix) -> Bool {
            return true
        }
    }
    
    init() {
        super.init(impl : NoConstraint.NoConstraintImpl())
    }
}


/**
 *  Constraint imposing positivity to all arguments
 */
class PositiveConstraint : Constraint {
    class PositiveConstraintImpl : Constraint.Impl {
        override func test(parameters : matrix) -> Bool {
            for i in 0..<(parameters.count) {
                if (parameters[i] <= 0.0) {
                    return false
                }
            }
            return true
        }
    }
    
    init() {
        super.init(impl : PositiveConstraint.PositiveConstraintImpl())
    }

}

/**
*  Constraint impositing all arguments to be in [low, high]
*/
class BoundaryConstraint : Constraint {
    class BoundaryConstraintImpl : Constraint.Impl {
        var high : Double, low : Double
        
        init(low : Double, high : Double) {
            self.high = high
            self.low = low
        }
        
        override func test(parameters : matrix) -> Bool {
            for i in 0..<(parameters.count) {
                if parameters[i] < low || parameters[i] > high {
                    return false
                }
            }
            return true
        }
    }
    
    init(low : Double, high : Double) {
        super.init(impl : BoundaryConstraint.BoundaryConstraintImpl(low : low, high : high))
    }
    
}


class CompositeConstraint : Constraint {
    class CompositeConstraintImpl : Constraint.Impl {
        var constraint1 : Constraint, constraint2 : Constraint
        
        init(constraint1 : Constraint, constraint2 : Constraint) {
            self.constraint1 = constraint1
            self.constraint2 = constraint2
        }
        
        override func test(parameters : matrix) -> Bool {
            return constraint1.test(parameters) && constraint2.test(parameters)
        }
    }
    
    init(constraint1 : Constraint, constraint2 : Constraint) {
        super.init(impl : CompositeConstraint.CompositeConstraintImpl(constraint1 : constraint1, constraint2 : constraint2))
    }

}