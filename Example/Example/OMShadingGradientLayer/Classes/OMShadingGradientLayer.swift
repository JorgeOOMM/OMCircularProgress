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
import UIKit
open class OMShadingGradientLayer: OMGradientLayer {
    var shading: [OMShadingGradient] = []
    /// Contruct gradient object with a type
    convenience public init(type: OMGradientType) {
        self.init()
        self.gradientType = type
        if type == .radial {
            self.startPoint = CGPoint(x: 0.5, y: 0.5)
            self.endPoint   = CGPoint(x: 0.5, y: 0.5)
        }
    }
    // MARK: - Object Overrides
    override public  init() {
        super.init()
    }
    /// Slope function
    open var slopeFunction: EasingFunction  = linear {
        didSet {
            setNeedsDisplay()
        }
    }
    /// Interpolation gardient function
    open var function: GradientFunction = .linear {
        didSet {
            setNeedsDisplay()
        }
    }
    /// Contruct gradient object with a layer
    override public  init(layer: Any) {
        super.init(layer: layer as AnyObject)
        if let other = layer as? OMShadingGradientLayer {
            self.slopeFunction = other.slopeFunction
        }
    }
    /// Contruct gradient object from NSCoder
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override open func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        var locations: [CGFloat]? = self.locations
        var colors: [UIColor] = self.colors
        var startPoint: CGPoint = self.startPoint
        var endPoint: CGPoint = self.endPoint
        var startRadius: CGFloat = self.startRadius
        var endRadius: CGFloat = self.endRadius
        let player = presentation()
        if let player = player {
            Log.v("\(self.name ?? "") (presentation) \(player)")
            colors       = player.colors
            locations    = player.locations
            startPoint   = player.startPoint
            endPoint     = player.endPoint
            startRadius  = player.startRadius
            endRadius    = player.endRadius
        } else {
            Log.v("\(self.name ?? "") (model) \(self)")
        }
        if isDrawable() {
            ctx.saveGState()
            // The starting point of the axis, in the shading's target coordinate space.
            var start: CGPoint = startPoint * self.bounds.size
            // The ending point of the axis, in the shading's target coordinate space.
            var end: CGPoint  = endPoint * self.bounds.size
            // The context must be clipped before scale the matrix.
            addPathAndClipIfNeeded(ctx)
            if self.isAxial {
                if self.stroke {
                    if self.path != nil {
                        // if we are using the stroke, we offset the from and to points
                        // by half the stroke width away from the center of the stroke.
                        // Otherwise we tend to end up with fills that only cover half of the
                        // because users set the start and end points based on the center
                        // of the stroke.
                        let halfLineWidth = self.lineWidth * 0.5
                        start  = end.projectLine(start, length: halfLineWidth)
                        end    = start.projectLine(end, length: -halfLineWidth)
                    }
                }
                ctx.scaleBy(x: self.bounds.size.width,
                            y: self.bounds.size.height)
                start  = start / self.bounds.size // swiftlint:disable:this shorthand_operator
                end    = end   / self.bounds.size // swiftlint:disable:this shorthand_operator
            } else {
                // The starting circle has radius `startRadius' and is centered at
                // `start', specified in the shading's target coordinate space. The ending
                // circle has radius `endRadius' and is centered at `end', specified in the
                // shading's target coordinate space.
            }
            if !self.radialTransform.isIdentity && !self.isAxial {
                // transform the radial context
                self.prepareContextIfNeeds(ctx, scale: self.radialTransform,
                                           closure: {(ctx, startPoint, endPoint, startRadius, endRadius) in
                                            let shading = OMShadingGradient(colors: colors,
                                                                        locations: locations,
                                                                        startPoint: startPoint,
                                                                        startRadius: startRadius,
                                                                        endPoint: endPoint,
                                                                        endRadius: endRadius,
                                                                        extendStart: self.extendsBeforeStart,
                                                                        extendEnd: self.extendsPastEnd,
                                                                        gradientType: self.gradientType,
                                                                        functionType: self.function,
                                                                        slopeFunction: self.slopeFunction)
                                            self.shading.append(shading)
                                            if let handle = shading.shadingHandle {
                                                ctx.drawShading(handle)
                                            }
                })
            } else {
                let minimumRadius = minRadius(self.bounds.size)
                let shading = OMShadingGradient(colors: colors,
                                            locations: locations,
                                            startPoint: start,
                                            startRadius: startRadius * minimumRadius,
                                            endPoint: end,
                                            endRadius: endRadius * minimumRadius,
                                            extendStart: self.extendsBeforeStart,
                                            extendEnd: self.extendsPastEnd,
                                            gradientType: self.gradientType,
                                            functionType: self.function,
                                            slopeFunction: self.slopeFunction)
                self.shading.append(shading)
                if let handle = shading.shadingHandle {
                    ctx.drawShading(handle)
                }
            }
            ctx.restoreGState()
        }
    }
    override open var description: String {
        var currentDescription: String = super.description
        if self.function == .linear {
            currentDescription += " linear interpolation"
        } else if self.function == .exponential {
            currentDescription += " exponential interpolation"
        } else if self.function == .cosine {
            currentDescription += " cosine interpolation"
        }
        return currentDescription
    }
}
