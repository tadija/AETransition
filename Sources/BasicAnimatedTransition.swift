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

extension AnimatedTransitionLayer {
    public var preparation: AnimatedTransition.ContextHandler? {
        return nil
    }
    public var animation: AnimatedTransition.ContextHandler? {
        return nil
    }
}

open class BasicAnimatedTransition: AnimatedTransition {

    // MARK: Properties

    open let layers: [AnimatedTransitionLayer]

    open var completion: ContextHandler? = { (context) in
        context.completeTransition(!context.transitionWasCancelled)
    }

    // MARK: Init

    public init(duration: TimeInterval = 0.5, layers: [AnimatedTransitionLayer]) {
        self.layers = layers
        super.init(duration: duration)
        configureTransitionAnimation(duration: duration, layers: layers)
    }

    // MARK: Helpers

    private func configureTransitionAnimation(duration: TimeInterval, layers: [AnimatedTransitionLayer]) {
        transitionAnimation = { [weak self] (context) in
            layers.forEach({ $0.preparation?(context) })
            UIView.animate(withDuration: duration, animations: {
                layers.forEach({ $0.animation?(context) })
            }, completion: { (finished) in
                self?.completion?(context)
            })
        }
    }

}

public struct InsertViewAboveLayer: AnimatedTransitionLayer {
    public var preparation: AnimatedTransition.ContextHandler? = { (context) in
        context.insertToViewAboveFromView()
    }
}

public struct InsertViewBelowLayer: AnimatedTransitionLayer {
    public var preparation: AnimatedTransition.ContextHandler? = { (context) in
        context.insertToViewBelowFromView()
    }
}

public struct FadeInLayer: AnimatedTransitionLayer {
    public var preparation: AnimatedTransition.ContextHandler? = { (context) in
        context.toView?.alpha = 0
    }
    public var animation: AnimatedTransition.ContextHandler? = { (context) in
        context.toView?.alpha = 1
    }
}

public struct FadeOutLayer: AnimatedTransitionLayer {
    public var animation: AnimatedTransition.ContextHandler? = { (context) in
        context.fromView?.alpha = 0
    }
}

open class LayeredFadeInTransition: BasicAnimatedTransition {
    public init(duration: TimeInterval = 0.5) {
        super.init(duration: duration, layers: [InsertViewAboveLayer(), FadeInLayer()])
    }
}

open class LayeredFadeOutTransition: BasicAnimatedTransition {
    public init(duration: TimeInterval = 0.5) {
        super.init(duration: duration, layers: [InsertViewBelowLayer(), FadeOutLayer()])
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
