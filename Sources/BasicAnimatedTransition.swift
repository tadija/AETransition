/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

public protocol AnimatedTransitionLayer {
    var preparation: AnimatedTransition.ContextHandler? { get }
    var animation: AnimatedTransition.ContextHandler? { get }
}

open class BasicAnimatedTransition: AnimatedTransition {

    // MARK: Properties

    open let layer: AnimatedTransitionLayer

    open var completion: ContextHandler? = { (context) in
        context.completeTransition(!context.transitionWasCancelled)
    }

    // MARK: Init

    public init(layer: AnimatedTransitionLayer, duration: TimeInterval = 0.5) {
        self.layer = layer
        
        super.init(duration: duration)

        transitionAnimation = { [weak self] (context) in
            self?.layer.preparation?(context)
            UIView.animate(withDuration: duration, animations: {
                self?.layer.animation?(context)
            }, completion: { (finished) in
                self?.completion?(context)
            })
        }
    }

}

public struct FadeInLayer: AnimatedTransitionLayer {
    public var preparation: AnimatedTransition.ContextHandler? = { (context) in
        context.insertToViewAboveFromView()
        context.toView?.alpha = 0
    }
    public var animation: AnimatedTransition.ContextHandler? = { (context) in
        context.toView?.alpha = 1
    }
}

public struct FadeOutLayer: AnimatedTransitionLayer {
    public var preparation: AnimatedTransition.ContextHandler? = { (context) in
        context.insertToViewBelowFromView()
    }
    public var animation: AnimatedTransition.ContextHandler? = { (context) in
        context.fromView?.alpha = 0
    }
}

open class LayeredFadeInTransition: BasicAnimatedTransition {
    public init(duration: TimeInterval = 0.5) {
        super.init(layer: FadeInLayer(), duration: duration)
    }
}

open class LayeredFadeOutTransition: BasicAnimatedTransition {
    public init(duration: TimeInterval = 0.5) {
        super.init(layer: FadeOutLayer(), duration: duration)
    }
}

open class FadeInTransition: AnimatedTransition {
    public init(duration: TimeInterval = 0.5) {
        super.init(duration: duration)

        transitionAnimation = { (context) in
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
        super.init(duration: duration)

        transitionAnimation = { (context) in
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
        super.init(duration: duration)

        transitionAnimation = { (context) in
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
        super.init(duration: duration)

        transitionAnimation = { (context) in
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
