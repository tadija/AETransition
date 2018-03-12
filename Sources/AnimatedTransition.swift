/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

open class AnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: Types

    public enum TransitionType {
        case presenting
        case dismissing
    }

    public typealias ContextAnimation = (UIViewControllerContextTransitioning) -> Void

    // MARK: Properties

    open let type: TransitionType
    open let duration: TimeInterval

    open var presentingAnimation: ContextAnimation?
    open var dismissingAnimation: ContextAnimation?

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

open class FadeTransition: AnimatedTransition {
    public override init(type: TransitionType, duration: TimeInterval) {
        super.init(type: type, duration: duration)

        presentingAnimation = { (context) in
            guard
                let fromView = context.view(forKey: .from),
                let toView = context.view(forKey: .to)
            else {
                return
            }
            context.containerView.insertSubview(toView, aboveSubview: fromView)

            toView.alpha = 0
            UIView.animate(withDuration: duration, animations: {
                toView.alpha = 1
            }, completion: { (finished) in
                context.completeTransition(!context.transitionWasCancelled)
            })
        }

        dismissingAnimation = { (context) in
            guard
                let fromView = context.view(forKey: .from),
                let toView = context.view(forKey: .to)
            else {
                return
            }
            context.containerView.insertSubview(toView, belowSubview: fromView)

            UIView.animate(withDuration: duration, animations: {
                fromView.alpha = 0
            }, completion: { (finished) in
                context.completeTransition(!context.transitionWasCancelled)
            })
        }
    }
}

open class SlideTransition: AnimatedTransition {
    public override init(type: TransitionType, duration: TimeInterval) {
        super.init(type: type, duration: duration)

        presentingAnimation = { (context) in
            guard
                let fromView = context.view(forKey: .from),
                let toView = context.view(forKey: .to)
            else {
                return
            }
            context.containerView.insertSubview(toView, aboveSubview: fromView)

            toView.transform = CGAffineTransform(translationX: fromView.bounds.width, y: 0)
            UIView.animate(withDuration: duration, animations: {
                toView.transform = .identity
            }, completion: { (finished) in
                context.completeTransition(!context.transitionWasCancelled)
            })
        }

        dismissingAnimation = { (context) in
            guard
                let fromView = context.view(forKey: .from),
                let toView = context.view(forKey: .to)
            else {
                return
            }
            context.containerView.insertSubview(toView, belowSubview: fromView)

            UIView.animate(withDuration: duration, animations: {
                fromView.transform = CGAffineTransform(translationX: fromView.bounds.width, y: 0)
            }, completion: { (finished) in
                context.completeTransition(!context.transitionWasCancelled)
            })
        }
    }
}
