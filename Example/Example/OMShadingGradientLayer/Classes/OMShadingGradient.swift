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
//  OMShadingGradient.swift
//
//  Created by Jorge Ouahbi on 20/4/16.
//  Copyright © 2016 Jorge Ouahbi. All rights reserved.
//


import Foundation
import UIKit

// function slope
typealias GradientSlopeFunction = EasingFunction

// interpolate two UIColors
typealias GradientInterpolationFunction = (UIColor,UIColor,CGFloat) -> UIColor

public enum GradientFunction {
    case linear
    case exponential
    case cosine
}

// TODO(jom): add a black and with gradients

func shadingFunctionCreate(_ colors : [UIColor],
                            locations : [CGFloat],
                            slopeFunction: @escaping GradientSlopeFunction,
                              interpolationFunction: @escaping GradientInterpolationFunction) -> (UnsafePointer<CGFloat>, UnsafeMutablePointer<CGFloat>) -> Void
{
    return { inData, outData in
        
        let interp = Double(inData[0])
        let alpha  = CGFloat(slopeFunction(interp))
        
        var positionIndex = 0;
        let colorCount    = colors.count
        var stop1Position = locations.first!
        var stop1Color    = colors[0]
        
        positionIndex += 1;
        
        var stop2Position:CGFloat = 0.0
        var stop2Color:UIColor;
        
        if (colorCount > 1) {
    
            // First stop color
            stop2Color  = colors[1]
            
            // When originally are 1 location and 1 color.
            // Add the stop2Position to 1.0
            
            if locations.count == 1 {
                stop2Position  = 1.0
            } else {
                // First stop location
                stop2Position = locations[1];
            }
            // Next positon index
            positionIndex += 1;
            
            
        } else {
            // if we only have one value, that's what we return
            stop2Position = stop1Position;
            stop2Color    = stop1Color;
        }
        
        while (positionIndex < colorCount && stop2Position < alpha) {
            stop1Color      = stop2Color;
            stop1Position   = stop2Position;
            stop2Color      = colors[positionIndex]
            stop2Position   = locations[positionIndex]
            positionIndex  += 1;
        }
        
        if (alpha <= stop1Position) {
            // if we are less than our lowest position, return our first color
            Log.d("(OMShadingGradient) alpha:\(String(format:"%.1f",alpha)) <= position \(String(format:"%.1f",stop1Position)) color \(stop1Color.shortDescription)")
            outData[0] = (stop1Color.components[0])
            outData[1] = (stop1Color.components[1])
            outData[2] = (stop1Color.components[2])
            outData[3] = (stop1Color.components[3])
            
        } else if (alpha >= stop2Position) {
            // likewise if we are greater than our highest position, return the last color
            Log.d("(OMShadingGradient) alpha:\(String(format:"%.1f",alpha)) >= position \(String(format:"%.1f",stop2Position)) color \(stop1Color.shortDescription)")
            outData[0] = (stop2Color.components[0])
            outData[1] = (stop2Color.components[1])
            outData[2] = (stop2Color.components[2])
            outData[3] = (stop2Color.components[3])
            
        } else {
            
            // otherwise interpolate between the two
            let newPosition = (alpha - stop1Position) / (stop2Position - stop1Position);
            
            let newColor : UIColor = interpolationFunction(stop1Color, stop2Color, newPosition)
            
            Log.d("(OMShadingGradient) alpha:\(String(format:"%.1f",alpha)) position \(String(format:"%.1f",newPosition)) color \(newColor.shortDescription)")
        
            for componentIndex in 0 ..< 3 {
                outData[componentIndex] = (newColor.components[componentIndex])
            }
            // The alpha component is always 1, the shading is always opaque.
            outData[3] = 1.0
        }
    }
}


func shadingCallback(_ infoPointer: UnsafeMutableRawPointer?,
                     inData: UnsafePointer<CGFloat>,
                     outData: UnsafeMutablePointer<CGFloat>) -> Swift.Void {
    // Load the UnsafeMutableRawPointer, and call the shadingFunction
    
    guard let infoPointer = infoPointer else {
        return
    }
    let shadingPtr = Unmanaged<OMShadingGradient>.fromOpaque(infoPointer).takeUnretainedValue()
    shadingPtr.shadingFunction(inData, outData)
}


public class OMShadingGradient {
    var monotonicLocations: [CGFloat] = []
    var locations: [CGFloat]?
    
    let colors : [UIColor]
    let startPoint : CGPoint
    let endPoint : CGPoint
    let startRadius : CGFloat
    let endRadius : CGFloat
    let extendsPastStart:Bool
    let extendsPastEnd:Bool
    let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
    let slopeFunction: EasingFunction
    let functionType : GradientFunction
    let gradientType : OMGradientType
    
    convenience init(colors: [UIColor],
          locations: [CGFloat]?,
          startPoint: CGPoint,
          endPoint: CGPoint,
          extendStart: Bool = false,
          extendEnd: Bool = false,
          functionType: GradientFunction = .linear,
          slopeFunction:  @escaping EasingFunction =  linear) {
        
        self.init(colors:colors,
                  locations: locations,
                  startPoint: startPoint,
                  startRadius: 0,
                  endPoint: endPoint,
                  endRadius: 0,
                  extendStart: extendStart,
                  extendEnd: extendEnd,
                  gradientType: .axial,
                  functionType: functionType,
                  slopeFunction:  slopeFunction)
    }
    
    convenience init(colors: [UIColor],
          locations: [CGFloat]?,
          startPoint: CGPoint,
          startRadius: CGFloat,
          endPoint: CGPoint,
          endRadius: CGFloat,
          extendStart: Bool = false,
          extendEnd: Bool = false,
          functionType: GradientFunction = .linear,
          slopeFunction: @escaping EasingFunction =  linear) {
        
        self.init(colors:colors,
                  locations: locations,
                  startPoint: startPoint,
                  startRadius: startRadius,
                  endPoint: endPoint,
                  endRadius: endRadius,
                  extendStart: extendStart,
                  extendEnd: extendEnd,
                  gradientType: .radial,
                  functionType: functionType,
                  slopeFunction: slopeFunction)
    }
    
    init(colors: [UIColor],
         locations: [CGFloat]?,
         startPoint: CGPoint,
         startRadius: CGFloat,
         endPoint: CGPoint,
         endRadius: CGFloat,
         extendStart: Bool,
         extendEnd: Bool,
         gradientType : OMGradientType  = .axial,
         functionType : GradientFunction = .linear,
         slopeFunction: @escaping EasingFunction  =  linear)
    {
        self.locations   = locations
        self.startPoint  = startPoint
        self.endPoint    = endPoint
        self.startRadius = startRadius
        self.endRadius   = endRadius
        
        // already checked in OMShadingGradientLayer
        assert(colors.count >= 2);
        
        // if only exist one color, duplicate it.
        if (colors.count == 1) {
            let color = colors.first!
            self.colors = [color,color];
        } else {
            self.colors = colors
        }
        
        // check the color space of all colors.
        if let lastColor = colors.last {
            for color in colors {
                // must be the same colorspace
                assert(lastColor.colorSpace?.model == color.colorSpace?.model,
                       "unexpected color model \(String(describing: color.colorSpace?.model.name)) != \(String(describing: lastColor.colorSpace?.model.name))")
                // and correct model
                assert(color.colorSpace?.model == .rgb,"unexpected color space model \(String(describing: color.colorSpace?.model.name))")
                if(color.colorSpace?.model != .rgb) {
                    //TODO: handle different color spaces
                    Log.w("(OMShadingGradient) : Unsupported color space. model: \(String(describing: color.colorSpace?.model.name))")
                }
            }
        }
        
        self.slopeFunction  = slopeFunction
        self.functionType   = functionType
        self.gradientType   = gradientType
        self.extendsPastStart = extendStart
        self.extendsPastEnd   = extendEnd
        
        // handle nil locations
        if let locations = self.locations {
            if locations.count > 0 {
                monotonicLocations = locations
            }
        }
        
        // TODO(jom): handle different number colors and locations
        
        if (monotonicLocations.count == 0) {
            self.monotonicLocations = monotonic(colors.count)
            self.locations          = self.monotonicLocations
        }
        
        Log.v("(OMShadingGradient): \(monotonicLocations.count) monotonic locations")
        Log.v("(OMShadingGradient): \(monotonicLocations)")
    }
    
    lazy var shadingFunction : (UnsafePointer<CGFloat>, UnsafeMutablePointer<CGFloat>) -> Void = {
        
        // @default: linear interpolation
        var interpolationFunction: GradientInterpolationFunction =  UIColor.lerp
        switch(self.functionType){
        case .linear :
            interpolationFunction =  UIColor.lerp
            break
        case .exponential :
            interpolationFunction =  UIColor.eerp
            break
        case .cosine :
            interpolationFunction =  UIColor.coserp
            break
        }
        let colors = self.colors
        let locations =  self.locations
        return shadingFunctionCreate(colors,
                                     locations: locations!,
                                     slopeFunction: self.slopeFunction,
                                     interpolationFunction: interpolationFunction )
    }()
    
    lazy var handleFunction : CGFunction! = {
        var callbacks = CGFunctionCallbacks(version: 0, evaluate: shadingCallback, releaseInfo: nil)
        // https://www.cnblogs.com/zbblog/p/15774171.html
        let infoPointer = Unmanaged<OMShadingGradient>.passRetained(self).toOpaque()
        return CGFunction(info: infoPointer,             // info
            domainDimension: 1,                          // domainDimension
            domain: [0, 1],                              // domain
            rangeDimension: 4,                           // rangeDimension
            range: [0, 1, 0, 1, 0, 1, 0, 1],             // range
            callbacks: &callbacks)                       // callbacks
    }()
    
    lazy var shadingHandle: CGShading? = {
        var callbacks = CGFunctionCallbacks(version: 0, evaluate: shadingCallback, releaseInfo: nil)
        if let handleFunction = self.handleFunction {
            if (self.gradientType == .axial) {
                return CGShading(axialSpace: self.colorSpace,
                                 start: self.startPoint,
                                 end: self.endPoint,
                                 function: handleFunction,
                                 extendStart: self.extendsPastStart,
                                 extendEnd: self.extendsPastEnd)
            } else {
                assert(self.gradientType == .radial)
                return CGShading(radialSpace: self.colorSpace,
                                 start: self.startPoint,
                                 startRadius: self.startRadius,
                                 end: self.endPoint,
                                 endRadius: self.endRadius,
                                 function: handleFunction,
                                 extendStart: self.extendsPastStart,
                                 extendEnd: self.extendsPastEnd)
            }
        }
        
        return nil
    }()
}
