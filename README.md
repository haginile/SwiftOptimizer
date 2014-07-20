SwiftOptimizer
=========

SwiftOptimizer allows you to solve minimization/maximization problems in Apple's Swift programming language. It is ported from QuantLib and uses the awesome [`swix` library](http://swix.readthedocs.org/en/latest/index.html).

I've only implemented the Simplex method, but will expand the algorithms to include least squares, etc. in the next few days.

Here's an example illustrating how to use this library.

First things first, you need to subclass `CostFunction` to create a class presentatin the function you are trying to minimize.

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

The cost function, constraint, and the initial values together define the problem you are trying to solve. You also need to specify the `endCriteria` so that the optimizer knows when to quit:

    var myEndCriteria = EndCriteria(maxIterations: 1000, maxStationaryStateIterations: 100, rootEpsilon: 1.0e-8, functionEpsilon: 1.0e-9, gradientNormEpsilon: 1.0e-5)
    var myFunc = RosenBrockFunction()
    var constraint = NoConstraint()
    var initialValue = zeros(2)
    var problem = Problem(costFunction: myFunc, constraint: constraint, initialValue: initialValue)

Finally, this is how you run the `Simplex` optimizer:

    var solver = Simplex(lambda: 0.1)
    var solved = solver.minimize(problem, endCriteria: myEndCriteria)
    println(problem.currentValue) // [1.0, 1.0]