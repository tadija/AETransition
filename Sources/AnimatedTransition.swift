/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

open class AnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: Types

    public typealias Animation = (UIViewControllerContextTransitioning) -> Void

    // MARK: Properties

    open let duration: TimeInterval
    open let animation: Animation

    // MARK: Init

    public init(duration: TimeInterval, animation: @escaping Animation) {
        self.duration = duration
        self.animation = animation
    }

    // MARK: UIViewControllerAnimatedTransitioning

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animation(transitionContext)
    }

}

public enum TransitionType {
    case presenting
    case dismissing
}

open class FadeTransition: AnimatedTransition {
    public init(type: TransitionType, duration: TimeInterval) {
        super.init(duration: duration) { (context) in
            guard
                let fromView = context.view(forKey: .from),
                let toView = context.view(forKey: .to)
            else {
                return
            }

            switch type {
            case .presenting:
                context.containerView.insertSubview(toView, aboveSubview: fromView)
                toView.alpha = 0
                UIView.animate(withDuration: duration, animations: {
                    toView.alpha = 1
                }, completion: { (finished) in
                    context.completeTransition(!context.transitionWasCancelled)
                })
            case .dismissing:
                context.containerView.insertSubview(toView, belowSubview: fromView)
                UIView.animate(withDuration: duration, animations: {
                    fromView.alpha = 0
                }, completion: { (finished) in
                    context.completeTransition(!context.transitionWasCancelled)
                })
            }
        }
    }
}

open class SlideTransition: AnimatedTransition {
    public init(type: TransitionType, duration: TimeInterval) {
        super.init(duration: duration) { (context) in
            guard
                let fromView = context.view(forKey: .from),
                let toView = context.view(forKey: .to)
            else {
                return
            }

            switch type {
            case .presenting:
                context.containerView.insertSubview(toView, aboveSubview: fromView)
                toView.transform = CGAffineTransform(translationX: fromView.bounds.width, y: 0)
                UIView.animate(withDuration: duration, animations: {
                    toView.transform = .identity
                }, completion: { (finished) in
                    context.completeTransition(!context.transitionWasCancelled)
                })
            case .dismissing:
                context.containerView.insertSubview(toView, belowSubview: fromView)
                UIView.animate(withDuration: duration, animations: {
                    fromView.transform = CGAffineTransform(translationX: fromView.bounds.width, y: 0)
                }, completion: { (finished) in
                    context.completeTransition(!context.transitionWasCancelled)
                })
            }
        }
    }
}
