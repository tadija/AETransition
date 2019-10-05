/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2019
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

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

    static func translation(for view: UIView?, to edge: Edge) -> CGAffineTransform {
        guard let view = view else {
            return .identity
        }
        switch edge {
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
