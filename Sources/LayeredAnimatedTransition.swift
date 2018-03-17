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

    // MARK: Types

    public struct Default {
        public static let duration: TimeInterval = 0.5
        public static let delay: TimeInterval = 0
        public static let dumping: CGFloat = 1
        public static let velocity: CGFloat = 1
        public static let options: UIViewAnimationOptions = []
    }

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
                duration: TimeInterval = Default.duration, delay: TimeInterval = Default.delay,
                damping: CGFloat = Default.dumping, velocity: CGFloat = Default.velocity,
                options: UIViewAnimationOptions = Default.options) {
        self.layers = layers
        super.init(duration: duration)
        configureTransitionAnimation(with: layers,
                                     duration: duration, delay: delay,
                                     damping: damping, velocity: velocity,
                                     options: options)
    }

    // MARK: Helpers

    private func configureTransitionAnimation(with layers: [AnimatedTransitionLayer],
                                              duration: TimeInterval, delay: TimeInterval,
                                              damping: CGFloat, velocity: CGFloat,
                                              options: UIViewAnimationOptions) {
        transitionAnimation = { [weak self] (context) in
            layers.forEach({ $0.preparation?(context) })
            UIView.animate(withDuration: duration, delay: delay,
                           usingSpringWithDamping: damping, initialSpringVelocity: velocity,
                           options: options,
                           animations: {
                            layers.forEach({ $0.animation?(context) })
            }, completion: { (finished) in
                self?.completion?(context)
            })
        }
    }

}
