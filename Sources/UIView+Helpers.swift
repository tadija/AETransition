/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

public extension UIView {
    public func translate(to edge: Edge) {
        transform = edge.translate(self)
    }
}

public enum Edge {
    case left, right, top, bottom

    public var opposite: Edge {
        switch self {
        case .left:
            return .right
        case .right:
            return .left
        case .top:
            return .bottom
        case .bottom:
            return .top
        }
    }

    public func translate(_ view: UIView) -> CGAffineTransform {
        switch self {
        case .left:
            return CGAffineTransform(translationX: -view.bounds.width, y: 0)
        case .right:
            return CGAffineTransform(translationX: view.bounds.width, y: 0)
        case .top:
            return CGAffineTransform(translationX: 0, y: -view.bounds.height)
        case .bottom:
            return CGAffineTransform(translationX: 0, y: view.bounds.height)
        }
    }
}
