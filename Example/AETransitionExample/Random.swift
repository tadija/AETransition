/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit
import AETransition

extension Bool {
    static func random() -> Bool {
        return arc4random_uniform(2) == 0
    }
}

extension Int {
    static func random(min: Int = 0, max: Int = Int.max) -> Int {
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }
}

extension Double {
    static func random(min: Double = 0.0, max: Double = 1.0) -> Double {
        let r = Double(arc4random()) / Double(UInt32.max)
        return (r * (max - min)) + min
    }
}

extension CGFloat {
    static func random(min: CGFloat = 0.0, max: CGFloat = 1.0) -> CGFloat {
        let r = CGFloat(arc4random()) / CGFloat(UInt32.max)
        return (r * (max - min)) + min
    }
}

extension UIColor {
    class func random() -> UIColor {
        let hue = CGFloat(arc4random() % 256) / 256.0
        let saturation = CGFloat(arc4random() % 256) / 256.0
        let brightness = CGFloat(arc4random() % 256) / 256.0
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }

    class func randomVivid() -> UIColor {
        let hue = CGFloat(arc4random() % 256) / 256.0
        let saturation = (CGFloat(arc4random() % 128) / 256.0) + 0.5 // 0.5 to 1.0 (away from white)
        let brightness = (CGFloat(arc4random() % 128) / 256.0) + 0.5 // 0.5 to 1.0 (away from white)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}

extension Edge {
    static func random() -> Edge {
        let index = Int.random(min: 0, max: all.count - 1)
        return all[index]
    }
    static var all: [Edge] = [.left, .right, .top, .bottom]
}

extension LayeredAnimatedTransition.Options {
    static func random() -> LayeredAnimatedTransition.Options {
        return LayeredAnimatedTransition.Options(duration: Double.random(min: 0.3, max: 0.7),
                                                 delay: 0,
                                                 damping: CGFloat.random(min: 0.5, max: 1),
                                                 velocity: CGFloat.random(min: 0, max: 1),
                                                 animationOptions: .random())
    }
}

extension UIViewAnimationOptions {
    static func random() -> UIViewAnimationOptions {
        if Bool.random() {
            return .curveEaseIn
        } else {
            return .curveEaseOut
        }
    }
}
