/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

open class TransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: Types

    public enum TransitionType {
        case presenting
        case dismissing
    }

    // MARK: Properties

    open let type: TransitionType
    open let duration: TimeInterval

    open var presentingAnimation: ((UIViewControllerContextTransitioning) -> Void)?
    open var dismissingAnimation: ((UIViewControllerContextTransitioning) -> Void)?

    // MARK: Init

    public init(type: TransitionType = .presenting, duration: TimeInterval = 0.5) {
        self.type = type
        self.duration = duration
    }

    // MARK: UIViewControllerAnimatedTransitioning

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch type {
        case .presenting:
            presentingAnimation?(transitionContext)
        case .dismissing:
            dismissingAnimation?(transitionContext)
        }
    }

}
