SwiftOptimizer
=========

SwiftOptimizer allows you to solve minimization/maximization problems in Apple's Swift programming language. It is ported from QuantLib and uses the awesome [`swix` library](http://swix.readthedocs.org/en/latest/index.html) for matrix calculations.

It currently supports the `Simplex` and `BFGS` methods, but will be expanded to include least squares, etc.

Example
--------

First things first, subclass `CostFunction` to create a class representing the function you are trying to minimize. For example, if you are interested in minimizing the [Rosenbrock Function](http://mathworld.wolfram.com/RosenbrockFunction.html), then you need to set up the cost function as follows:

```swift
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
```

The `CostFunction`, `Constraint` (if any), and the initial values together define the `Problem` you are trying to solve. You also need to specify the `EndCriteria` so that the optimizer knows when to quit:    

```swift
var costFunction = RosenBrockFunction()
var constraint = NoConstraint()
var initialValue = zeros(2)
var problem = Problem(costFunction: costFunction, constraint: constraint, initialValue: initialValue)

var myEndCriteria = EndCriteria(maxIterations: 1000, 
                                maxStationaryStateIterations: 100, 
                                rootEpsilon: 1.0e-8, 
                                functionEpsilon: 1.0e-9, 
                                gradientNormEpsilon: 1.0e-5)

```

Finally, this is how you run the `Simplex` optimizer:

```swift
var solver = Simplex(lambda: 0.1)
var solved = solver.minimize(&problem, endCriteria: myEndCriteria)
problem.currentValue    // return matrix([1.000, 1.000])
```

Other optimization algorithms can be applied analogously. For example, this is how to use the `BFGS` algorithm:

```swift
var bfgsSolver = BFGS()
var bfgsSolved = bfgsSolver.minimize(&problem, endCriteria: myEndCriteria)
problem.currentValue    // return matrix([1.000, 1.000])
```
