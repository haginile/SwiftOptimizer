//
//  Simplex.swift
//  SwiftOptimizer
//
//  Created by Helin Gai on 7/19/14.
//  Copyright (c) 2014 SHFuse. All rights reserved.
//

import Foundation


//class Simplex : OptimizationMethod {
//    var lambda : Double
//    var vertices : [matrix]
//    var values : matrix
//    var sum_ : matrix
//    
//    init(lambda : Double) {
//        self.lambda = lambda
//    }
//}


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
//        result
    }
    
    return 0.0
}