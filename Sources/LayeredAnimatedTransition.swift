/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

public protocol AnimatedTransitionLayer {
    var preparation: ContextHandler? { get }
    var animation: ContextHandler? { get }
}

public extension AnimatedTransitionLayer {
    public var preparation: ContextHandler? {
        return nil
    }
    public var animation: ContextHandler? {
        return nil
    }

    public var debugDescription: String {
        return String(describing: type(of: self))
    }
}

open class LayeredAnimatedTransition: AnimatedTransition {

    // MARK: Properties

    open let layers: [AnimatedTransitionLayer]

    open var completion: ContextHandler? = { (context) in
        context.completeTransition(!context.transitionWasCancelled)
    }

    open override var debugDescription: String {
        return "\(String(describing: type(of: self))) | Layers: \(layers.map{ $0.debugDescription })"
    }

    // MARK: Init

    public init(with layers: [AnimatedTransitionLayer],
                duration: TimeInterval = 0.5, delay: TimeInterval = 0,
                springWithDamping: CGFloat = 1, springVelocity: CGFloat = 1,
                options: UIViewAnimationOptions = []) {
        self.layers = layers
        super.init(duration: duration)
        configureTransitionAnimation(with: layers,
                                     duration: duration, delay: delay,
                                     springWithDamping: springWithDamping,
                                     springVelocity: springVelocity, options: options)
    }

    // MARK: Helpers

    private func configureTransitionAnimation(with layers: [AnimatedTransitionLayer],
                                              duration: TimeInterval, delay: TimeInterval,
                                              springWithDamping: CGFloat, springVelocity: CGFloat,
                                              options: UIViewAnimationOptions) {
        transitionAnimation = { [weak self] (context) in
            layers.forEach({ $0.preparation?(context) })
            UIView.animate(withDuration: duration, delay: delay,
                           usingSpringWithDamping: springWithDamping, initialSpringVelocity: springVelocity,
                           options: options,
                           animations: {
                            layers.forEach({ $0.animation?(context) })
            }, completion: { (finished) in
                self?.completion?(context)
            })
        }
    }

}
