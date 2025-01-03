//
//    Copyright 2015 - Jorge Ouahbi
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//

//
//  Math.swift
//
//  Created by Jorge Ouahbi on 9/5/16.
//  Copyright © 2016 Jorge Ouahbi. All rights reserved.
//

import UIKit
// clamp a number between lower and upper.
public func clamp<T: Comparable>(_ value: T, lower: T, upper: T) -> T {
    return min(max(value, lower), upper)
}
// is the number between lower and upper.
public func between<T: Comparable>(_ value: T, lower: T, upper: T, include: Bool = true) -> Bool {
    let left = min(lower, upper)
    let right = max(lower, upper)
    return include ? (value >= left && value <= right) : (value > left && value < right)
}
// min radius from rectangle
public func minRadius(_ size: CGSize) -> CGFloat {
    assert(size != CGSize.zero)
    return size.min() * 0.5
}
// max radius from a rectangle (pythagoras)
public func maxRadius(_ size: CGSize) -> CGFloat {
    assert(size != CGSize.zero)
    return 0.5 * sqrt(size.width * size.width + size.height * size.height)
}
// monotonically increasing function
public func monotonic(_ numberOfElements: Int) -> [CGFloat] {
    assert(numberOfElements > 0)
    var monotonicFunction: [CGFloat] = []
    let numberOfLocations: CGFloat = CGFloat(numberOfElements - 1)
    for locationIndex in 0 ..< numberOfElements {
         monotonicFunction.append(CGFloat(locationIndex) / numberOfLocations)
    }
    return monotonicFunction
}
// redistributes values on a slope (ease-in ease-out)
public func slope( slopeX: Float, slopeA: Float) -> Float {
    let slopeP = powf(slopeX, slopeA)
    return slopeP/(slopeP + powf(1.0-slopeX, slopeA))
}
public func linlin( val: Double, inMin: Double, inMax: Double, outMin: Double, outMax: Double) -> Double {
    return ((val - inMin) / (inMax - inMin) * (outMax - outMin)) + outMin
}
public func  linexp( val: Double, inMin: Double, inMax: Double, outMin: Double, outMax: Double) -> Double {
    //clipping
    let valclamp = max(min(val, inMax), inMin)
    return pow((outMax / outMin), (valclamp - inMin) / (inMax - inMin)) * outMin
}
public func explin(val: Double, inMin: Double, inMax: Double, outMin: Double, outMax: Double) -> Double {
    //clipping
    let valclamp = max(min(val, inMax), inMin)
    return (log(valclamp/inMin) / log(inMax/inMin) * (outMax - outMin)) + outMin
}
