/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

public enum TransitionType {
    case presenting
    case dismissing
}

public protocol TransitionAnimation: UIViewControllerAnimatedTransitioning {
    var type: TransitionType { get }
    var duration: TimeInterval { get }

    var presentingAnimation: (UIViewControllerContextTransitioning) -> Void { get set }
    var dismissingAnimation: (UIViewControllerContextTransitioning) -> Void { get set }
}

extension TransitionAnimation {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch type {
        case .presenting:
            presentingAnimation(transitionContext)
        case .dismissing:
            dismissingAnimation(transitionContext)
        }
    }
}
