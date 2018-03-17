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

    public struct Options {
        public let duration: TimeInterval
        public let delay: TimeInterval
        public let damping: CGFloat
        public let velocity: CGFloat
        public let animationOptions: UIViewAnimationOptions

        public static let standard = Options()

        public init(duration: TimeInterval = 0.5, delay: TimeInterval = 0,
                    damping: CGFloat = 1, velocity: CGFloat = 0,
                    animationOptions: UIViewAnimationOptions = []) {
            self.duration = duration
            self.delay = delay
            self.damping = damping
            self.velocity = velocity
            self.animationOptions = animationOptions
        }
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

    public init(with layers: [AnimatedTransitionLayer], options: Options) {
        self.layers = layers
        super.init(duration: options.duration)
        configureTransitionAnimation(with: layers, options: options)
    }

    // MARK: Helpers

    private func configureTransitionAnimation(with layers: [AnimatedTransitionLayer], options: Options) {
        transitionAnimation = { [weak self] (context) in
            layers.forEach({ $0.preparation?(context) })
            UIView.animate(withDuration: options.duration, delay: options.delay,
                           usingSpringWithDamping: options.damping, initialSpringVelocity: options.velocity,
                           options: options.animationOptions,
                           animations: {
                            layers.forEach({ $0.animation?(context) })
            }, completion: { (finished) in
                self?.completion?(context)
            })
        }
    }

}
