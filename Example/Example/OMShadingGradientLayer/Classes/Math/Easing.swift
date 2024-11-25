
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
//  Easing.swift
//
//  Created by Jorge Ouahbi on 21/4/16.
//  Copyright © 2016 Jorge Ouahbi. All rights reserved.
//

import Foundation

public typealias EasingFunction = (Double) -> Double
public typealias EasingFunctionsTuple = (function: EasingFunction, name: String)


/*
 
 public var kEasingFunctions : Array<EasingFunctionsTuple> = [
 (Linear,"Linear"),
 (QuadraticEaseIn,"QuadraticEaseIn"),
 (QuadraticEaseOut,"QuadraticEaseOut"),
 (QuadraticEaseInOut,"QuadraticEaseInOut"),
 (CubicEaseIn,"CubicEaseIn"),
 (CubicEaseOut,"CubicEaseOut"),
 (CubicEaseInOut,"CubicEaseInOut"),
 (QuarticEaseIn,"QuarticEaseIn"),
 (QuarticEaseOut,"QuarticEaseOut"),
 (QuarticEaseInOut,"QuarticEaseInOut"),
 (QuinticEaseIn,"QuinticEaseIn"),
 (QuinticEaseOut,"QuinticEaseOut"),
 (QuinticEaseInOut,"QuinticEaseInOut"),
 (SineEaseIn,"SineEaseIn"),
 (SineEaseOut,"SineEaseOut"),
 (SineEaseInOut,"SineEaseInOut"),
 (CircularEaseIn,"CircularEaseIn"),
 (CircularEaseOut,"CircularEaseOut"),
 (CircularEaseInOut,"CircularEaseInOut"),
 (ExponentialEaseIn,"ExponentialEaseIn"),
 (ExponentialEaseOut,"ExponentialEaseOut"),
 (ExponentialEaseInOut,"ExponentialEaseInOut"),
 (ElasticEaseIn,"ElasticEaseIn"),
 (ElasticEaseOut,"ElasticEaseOut"),
 (ElasticEaseInOut,"ElasticEaseInOut"),
 (BackEaseIn,"BackEaseIn"),
 (BackEaseOut,"BackEaseOut"),
 (BackEaseInOut,"BackEaseInOut"),
 (BounceEaseIn,"BounceEaseIn"),
 (BounceEaseOut,"BounceEaseOut"),
 (BounceEaseInOut,"BounceEaseInOut")
 ]

 */
//
//  easing.c
//
//  Copyright (c) 2011, Auerhaus Development, LLC
//
//  This program is free software. It comes without any warranty, to
//  the extent permitted by applicable law. You can redistribute it
//  and/or modify it under the terms of the Do What The Fuck You Want
//  To Public License, Version 2, as published by Sam Hocevar. See
//  http://sam.zoy.org/wtfpl/COPYING for more details.
//

// Modeled after the line y = x
func linear(_ easingParam: Double) -> Double
{
    return easingParam;
}

// Modeled after the parabola y = x^2
func quadraticEaseIn(_ easingParam: Double) -> Double
{
    return easingParam * easingParam;
}

// Modeled after the parabola y = -x^2 + 2x
func quadraticEaseOut(_ easingParam: Double) -> Double
{
    return -(easingParam * (easingParam - 2));
}

// Modeled after the piecewise quadratic
// y = (1/2)((2x)^2)             ; [0, 0.5)
// y = -(1/2)((2x-1)*(2x-3) - 1) ; [0.5, 1]
func quadraticEaseInOut(_ easingParam: Double) -> Double
{
    if(easingParam < 0.5)
    {
        return 2 * easingParam * easingParam;
    }
    else
    {
        return (-2 * easingParam * easingParam) + (4 * easingParam) - 1;
    }
}

// Modeled after the cubic y = x^3
func cubicEaseIn(_ easingParam: Double) -> Double
{
    return easingParam * easingParam * easingParam;
}

// Modeled after the cubic y = (x - 1)^3 + 1
func cubicEaseOut(_ easingParam: Double) -> Double
{
    let easingConst = (easingParam - 1);
    return easingConst * easingConst * easingConst + 1;
}

// Modeled after the piecewise cubic
// y = (1/2)((2x)^3)       ; [0, 0.5)
// y = (1/2)((2x-2)^3 + 2) ; [0.5, 1]
func cubicEaseInOut(_ easingParam: Double) -> Double
{
    if(easingParam < 0.5)
    {
        return 4 * easingParam * easingParam * easingParam;
    }
    else
    {
        let easingConst = ((2 * easingParam) - 2);
        return 0.5 * easingConst * easingConst * easingConst + 1;
    }
}

// Modeled after the quartic x^4
func quarticEaseIn(_ easingParam: Double) -> Double
{
    return easingParam * easingParam * easingParam * easingParam;
}

// Modeled after the quartic y = 1 - (x - 1)^4
func quarticEaseOut(_ easingParam: Double) -> Double
{
    let easingConst = (easingParam - 1);
    return easingConst * easingConst * easingConst * (1 - easingParam) + 1;
}

// Modeled after the piecewise quartic
// y = (1/2)((2x)^4)        ; [0, 0.5)
// y = -(1/2)((2x-2)^4 - 2) ; [0.5, 1]
func quarticEaseInOut(_ easingParam: Double) -> Double
{
    if(easingParam < 0.5)
    {
        return 8 * easingParam * easingParam * easingParam * easingParam;
    }
    else
    {
        let easingConst = (easingParam - 1);
        return -8 * easingConst * easingConst * easingConst * easingConst + 1;
    }
}

// Modeled after the quintic y = x^5
func quinticEaseIn(_ easingParam: Double) -> Double
{
    return easingParam * easingParam * easingParam * easingParam * easingParam;
}

// Modeled after the quintic y = (x - 1)^5 + 1
func quinticEaseOut(_ easingParam: Double) -> Double
{
    let easingConst = (easingParam - 1);
    return easingConst * easingConst * easingConst * easingConst * easingConst + 1;
}

// Modeled after the piecewise quintic
// y = (1/2)((2x)^5)       ; [0, 0.5)
// y = (1/2)((2x-2)^5 + 2) ; [0.5, 1]
func quinticEaseInOut(_ easingParam: Double) -> Double
{
    if(easingParam < 0.5)
    {
        return 16 * easingParam * easingParam * easingParam * easingParam * easingParam;
    }
    else
    {
        let easingConst = ((2 * easingParam) - 2);
        return  0.5 * easingConst * easingConst * easingConst * easingConst * easingConst + 1;
    }
}

// Modeled after quarter-cycle of sine wave
func sineEaseIn(_ easingParam: Double) -> Double
{
    return sin((easingParam - 1) * .pi / 2.0) + 1;
}

// Modeled after quarter-cycle of sine wave (different phase)
func sineEaseOut(_ easingParam: Double) -> Double
{
    return sin(easingParam * .pi / 2.0);
}

// Modeled after half sine wave
func sineEaseInOut(_ easingParam: Double) -> Double
{
    return 0.5 * (1 - cos(easingParam * .pi));
}

// Modeled after shifted quadrant IV of unit circle
func circularEaseIn(_ easingParam: Double) -> Double
{
    return 1 - sqrt(1 - (easingParam * easingParam));
}

// Modeled after shifted quadrant II of unit circle
func circularEaseOut(_ easingParam: Double) -> Double
{
    return sqrt((2 - easingParam) * easingParam);
}

// Modeled after the piecewise circular function
// y = (1/2)(1 - sqrt(1 - 4x^2))           ; [0, 0.5)
// y = (1/2)(sqrt(-(2x - 3)*(2x - 1)) + 1) ; [0.5, 1]
func circularEaseInOut(_ easingParam: Double) -> Double
{
    if(easingParam < 0.5)
    {
        return 0.5 * (1 - sqrt(1 - 4 * (easingParam * easingParam)));
    }
    else
    {
        return 0.5 * (sqrt(-((2 * easingParam) - 3) * ((2 * easingParam) - 1)) + 1);
    }
}

// Modeled after the exponential function y = 2^(10(x - 1))
func exponentialEaseIn(_ easingParam: Double) -> Double
{
    return (easingParam == 0.0) ? easingParam : pow(2, 10 * (easingParam - 1));
}

// Modeled after the exponential function y = -2^(-10x) + 1
func exponentialEaseOut(_ easingParam: Double) -> Double
{
    return (easingParam == 1.0) ? easingParam : 1 - pow(2, -10 * easingParam);
}

// Modeled after the piecewise exponential
// y = (1/2)2^(10(2x - 1))         ; [0,0.5)
// y = -(1/2)*2^(-10(2x - 1))) + 1 ; [0.5,1]
func exponentialEaseInOut(_ easingParam: Double) -> Double
{
    if(easingParam == 0.0 || easingParam == 1.0) {return easingParam;}
    
    if(easingParam < 0.5)
    {
        return 0.5 * pow(2, (20 * easingParam) - 10);
    }
    else
    {
        return -0.5 * pow(2, (-20 * easingParam) + 10) + 1;
    }
}

// Modeled after the damped sine wave y = sin(13pi/2*x)*pow(2, 10 * (x - 1))
func elasticEaseIn(_ easingParam: Double) -> Double
{
    return sin(13 * .pi / 2.0 * easingParam) * pow(2, 10 * (easingParam - 1));
}

// Modeled after the damped sine wave y = sin(-13pi/2*(x + 1))*pow(2, -10x) + 1
func elasticEaseOut(_ easingParam: Double) -> Double
{
    return sin(-13 * .pi / 2.0 * (easingParam + 1)) * pow(2, -10 * easingParam) + 1;
}

// Modeled after the piecewise exponentially-damped sine wave:
// y = (1/2)*sin(13pi/2*(2*x))*pow(2, 10 * ((2*x) - 1))      ; [0,0.5)
// y = (1/2)*(sin(-13pi/2*((2x-1)+1))*pow(2,-10(2*x-1)) + 2) ; [0.5, 1]
func elasticEaseInOut(_ easingParam: Double) -> Double
{
    if(easingParam < 0.5)
    {
        return 0.5 * sin(13 * .pi / 2.0 * (2 * easingParam)) * pow(2, 10 * ((2 * easingParam) - 1));
    }
    else
    {
        return 0.5 * (sin(-13 * .pi / 2.0 * ((2 * easingParam - 1) + 1)) * pow(2, -10 * (2 * easingParam - 1)) + 2);
    }
}

// Modeled after the overshooting cubic y = x^3-x*sin(x*pi)
func backEaseIn(_ easingParam: Double) -> Double
{
    return easingParam * easingParam * easingParam - easingParam * sin(easingParam * .pi);
}

// Modeled after overshooting cubic y = 1-((1-x)^3-(1-x)*sin((1-x)*pi))
func backEaseOut(_ easingParam: Double) -> Double
{
    let easingConst = (1 - easingParam);
    return 1 - (easingConst * easingConst * easingConst - easingConst * sin(easingConst * .pi));
}

// Modeled after the piecewise overshooting cubic function:
// y = (1/2)*((2x)^3-(2x)*sin(2*x*pi))           ; [0, 0.5)
// y = (1/2)*(1-((1-x)^3-(1-x)*sin((1-x)*pi))+1) ; [0.5, 1]
func backEaseInOut(_ easingParam: Double) -> Double
{
    if(easingParam < 0.5)
    {
        let easingConst = 2 * easingParam;
        return 0.5 * (easingConst * easingConst * easingConst - easingConst * sin(easingConst * .pi));
    }
    else
    {
        let easingConst = (1 - (2*easingParam - 1));
        let fsin = sin(easingConst * .pi)
        return 0.5 * (1 - (easingConst * easingConst * easingConst - easingConst * fsin)) + 0.5;
    }
}

func bounceEaseIn(_ easingParam: Double) -> Double
{
    return 1 - bounceEaseOut(1 - easingParam);
}

func bounceEaseOut(_ easingParam: Double) -> Double
{
    if(easingParam < 4/11.0)
    {
        return (121 * easingParam * easingParam)/16.0;
    }
    else if(easingParam < 8/11.0)
    {
        return (363/40.0 * easingParam * easingParam) - (99/10.0 * easingParam) + 17/5.0;
    }
    else if(easingParam < 9/10.0)
    {
        return (4356/361.0 * easingParam * easingParam) - (35442/1805.0 * easingParam) + 16061/1805.0;
    }
    else
    {
        return (54/5.0 * easingParam * easingParam) - (513/25.0 * easingParam) + 268/25.0;
    }
}

func bounceEaseInOut(_ easingParam: Double) -> Double
{
    if(easingParam < 0.5)
    {
        return 0.5 * bounceEaseIn(easingParam*2);
    }
    else
    {
        return 0.5 * bounceEaseOut(easingParam * 2 - 1) + 0.5;
    }
}

