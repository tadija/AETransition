/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

open class FadeInTransition: AnimatedTransition {
    public init(duration: TimeInterval = 0.5) {
        super.init(duration: duration) { (context) in
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
    }
}

open class FadeOutTransition: AnimatedTransition {
    public init(duration: TimeInterval = 0.5) {
        super.init(duration: duration) { (context) in
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

open class MoveInTransition: AnimatedTransition {
    public init(duration: TimeInterval = 0.5) {
        super.init(duration: duration) { (context) in
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
    }
}

open class MoveOutTransition: AnimatedTransition {
    public init(duration: TimeInterval = 0.5) {
        super.init(duration: duration) { (context) in
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
