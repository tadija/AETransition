/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

open class FadeInTransition: AnimatedTransition {
    public init(duration: TimeInterval = 0.5) {
        super.init(duration: duration) { (context) in
            context.insertToViewAboveFromView()
            context.toView?.alpha = 0
            UIView.animate(withDuration: duration, animations: {
                context.toView?.alpha = 1
            }, completion: { (finished) in
                context.completeTransition(!context.transitionWasCancelled)
            })
        }
    }
}

open class FadeOutTransition: AnimatedTransition {
    public init(duration: TimeInterval = 0.5) {
        super.init(duration: duration) { (context) in
            context.insertToViewBelowFromView()
            UIView.animate(withDuration: duration, animations: {
                context.fromView?.alpha = 0
            }, completion: { (finished) in
                context.completeTransition(!context.transitionWasCancelled)
            })
        }
    }
}

open class MoveInTransition: AnimatedTransition {
    public init(duration: TimeInterval = 0.5) {
        super.init(duration: duration) { (context) in
            context.insertToViewAboveFromView()
            let translationX = context.fromView?.bounds.width ?? 0
            context.toView?.transform = CGAffineTransform(translationX: translationX, y: 0)
            UIView.animate(withDuration: duration, animations: {
                context.toView?.transform = .identity
            }, completion: { (finished) in
                context.completeTransition(!context.transitionWasCancelled)
            })
        }
    }
}

open class MoveOutTransition: AnimatedTransition {
    public init(duration: TimeInterval = 0.5) {
        super.init(duration: duration) { (context) in
            context.insertToViewBelowFromView()
            UIView.animate(withDuration: duration, animations: {
                let translationX = context.fromView?.bounds.width ?? 0
                context.fromView?.transform = CGAffineTransform(translationX: translationX, y: 0)
            }, completion: { (finished) in
                context.completeTransition(!context.transitionWasCancelled)
            })
        }
    }
}
