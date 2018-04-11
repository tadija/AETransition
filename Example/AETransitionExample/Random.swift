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

extension Edge {
    static func random() -> Edge {
        let index = Int.random(min: 0, max: all.count - 1)
        return all[index]
    }
    static let all: [Edge] = [.left, .right, .top, .bottom]
}

extension LayeredAnimatedTransition.Options {
    static func random() -> LayeredAnimatedTransition.Options {
        return LayeredAnimatedTransition.Options(duration: Double.random(min: 0.5, max: 1),
                                                 delay: 0,
                                                 damping: CGFloat.random(min: 0.3, max: 1),
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

extension CGAffineTransform {
    static func random() -> CGAffineTransform {
        switch Int.random(min: 0, max: 10) {
        case 0:
            return translate()
        case 1:
            return scale()
        case 2:
            return rotate()
        case 3:
            return translate().concatenating(scale())
        case 4:
            return translate().concatenating(rotate())
        case 5:
            return scale().concatenating(rotate())
        default:
            return translate().concatenating(scale()).concatenating(rotate())
        }
    }
    static func translate() -> CGAffineTransform {
        let x = CGFloat.random(min: -500, max: 500)
        let y = CGFloat.random(min: -1000, max: 1000)
        return CGAffineTransform(translationX: x, y: y)
    }
    static func scale() -> CGAffineTransform {
        let x = CGFloat.random(min: 0, max: 5)
        let y = CGFloat.random(min: 0, max: 5)
        return CGAffineTransform(scaleX: x, y: y)
    }
    static func rotate() -> CGAffineTransform {
        return CGAffineTransform(rotationAngle: randomAngle())
    }
    private static func randomAngle() -> CGFloat {
        switch Int.random(min: 0, max: 9) {
        case 0:
            return .pi / 2
        case 1:
            return .pi / 4
        case 2:
            return .pi * 2
        case 3:
            return .pi * 4
        default:
            return .pi
        }
    }
}
