/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit
import AETransition

extension Edge {
    static func random() -> Edge {
        return all.randomElement()!
    }
    static let all: [Edge] = [.left, .right, .top, .bottom]
}

extension LayeredAnimatedTransition.Options {
    static func random() -> LayeredAnimatedTransition.Options {
        return LayeredAnimatedTransition.Options(duration: Double.random(in: 0.5...1),
                                                 delay: 0,
                                                 damping: CGFloat.random(in: 0.3...1),
                                                 velocity: CGFloat.random(in: 0...1),
                                                 animationOptions: .random())
    }
}

extension UIView.AnimationOptions {
    static func random() -> UIView.AnimationOptions {
        if Bool.random() {
            return .curveEaseIn
        } else {
            return .curveEaseOut
        }
    }
}

extension CGAffineTransform {
    static func random() -> CGAffineTransform {
        switch Int.random(in: 0...10) {
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
        let x = CGFloat.random(in: -500...500)
        let y = CGFloat.random(in: -1000...1000)
        return CGAffineTransform(translationX: x, y: y)
    }
    static func scale() -> CGAffineTransform {
        let x = CGFloat.random(in: 0...5)
        let y = CGFloat.random(in: 0...5)
        return CGAffineTransform(scaleX: x, y: y)
    }
    static func rotate() -> CGAffineTransform {
        return CGAffineTransform(rotationAngle: randomAngle())
    }
    private static func randomAngle() -> CGFloat {
        switch Int.random(in: 0...9) {
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
