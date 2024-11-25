
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

//
//  UIColor+Interpolation.swift
//
//  Created by Jorge Ouahbi on 27/4/16.
//  Copyright © 2016 Jorge Ouahbi. All rights reserved.
//
import UIKit
extension UIColor {
    // RGBA

    /// Linear interpolation
    ///
    /// - Parameters:
    ///   - start: start UIColor
    ///   - end: start UIColor
    ///   - alpha:  alpha
    /// - Returns: return UIColor
    
    public class func lerp(_ start:UIColor, end:UIColor, alpha:CGFloat) -> UIColor {
        
        let srgba = start.components
        let ergba = end.components
        
        return UIColor(red: Interpolation.lerp(srgba[0],y1: ergba[0],alpha: alpha),
                       green: Interpolation.lerp(srgba[1],y1: ergba[1],alpha: alpha),
                       blue: Interpolation.lerp(srgba[2],y1: ergba[2],alpha: alpha),
                       alpha: Interpolation.lerp(srgba[3],y1: ergba[3],alpha: alpha))
    }
    
    /// Cosine interpolate
    ///
    /// - Parameters:
    ///   - start: start UIColor
    ///   - end: start UIColor
    ///   - alpha:  alpha
    /// - Returns: return UIColor
    public class func coserp(_ start:UIColor, end:UIColor, alpha:CGFloat) -> UIColor {
        let srgba = start.components
        let ergba = end.components
        return UIColor(red: Interpolation.coserp(srgba[0],y1: ergba[0],alpha: alpha),
                       green: Interpolation.coserp(srgba[1],y1: ergba[1],alpha: alpha),
                       blue: Interpolation.coserp(srgba[2],y1: ergba[2],alpha: alpha),
                       alpha: Interpolation.coserp(srgba[3],y1: ergba[3],alpha: alpha))
    }
    
    /// Exponential interpolation
    ///
    /// - Parameters:
    ///   - start: start UIColor
    ///   - end: start UIColor
    ///   - alpha:  alpha
    /// - Returns: return UIColor
    
    public class func eerp(_ start:UIColor, end:UIColor, alpha:CGFloat) -> UIColor {
        let srgba = start.components
        let ergba = end.components
        
        let red = clamp(Interpolation.eerp(srgba[0],y1: ergba[0],alpha: alpha), lowerValue: 0,upperValue: 1)
        let green = clamp(Interpolation.eerp(srgba[1],y1: ergba[1],alpha: alpha),lowerValue: 0, upperValue: 1)
        let blue = clamp(Interpolation.eerp(srgba[2],y1: ergba[2],alpha: alpha), lowerValue: 0, upperValue: 1)
        let rgbalpha = clamp(Interpolation.eerp(srgba[3],y1: ergba[3],alpha: alpha), lowerValue: 0,upperValue: 1)
        
        assert(red <= 1.0 && green <= 1.0 && blue <= 1.0 && rgbalpha <= 1.0);
        
        return UIColor(red: red,
                       green: green,
                       blue: blue,
                       alpha: rgbalpha)
        
    }
    
    
    /// Bilinear interpolation
    ///
    /// - Parameters:
    ///   - start: start UIColor
    ///   - end: start UIColor
    ///   - alpha:  alpha
    /// - Returns: return UIColor
    
    public class func bilerp(_ start:[UIColor], end:[UIColor], alpha:[CGFloat]) -> UIColor {
        let srgba0 = start[0].components
        let ergba0 = end[0].components
        
        let srgba1 = start[1].components
        let ergba1 = end[1].components
        
        return UIColor(red: Interpolation.bilerp(srgba0[0], y1: ergba0[0], t1: alpha[0], y2: srgba1[0], y3: ergba1[0], t2: alpha[1]),
                       green: Interpolation.bilerp(srgba0[1], y1: ergba0[1], t1: alpha[0], y2: srgba1[1], y3: ergba1[1], t2: alpha[1]),
                       blue: Interpolation.bilerp(srgba0[2], y1: ergba0[2], t1: alpha[0], y2: srgba1[2], y3: ergba1[2], t2: alpha[1]),
                       alpha:  Interpolation.bilerp(srgba0[3], y1: ergba0[3], t1: alpha[0], y2: srgba1[3], y3: ergba1[3], t2: alpha[1]))
        
    }
}

