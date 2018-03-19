/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

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
