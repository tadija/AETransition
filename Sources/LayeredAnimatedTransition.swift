/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

open class LayeredAnimatedTransition: NSObject, AnimatedTransition {

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
    open let options: Options

    open override var debugDescription: String {
        return "\(String(describing: type(of: self))) | Layers: \(layers.map{ String(describing: type(of: $0)) })"
    }

    // MARK: Init

    public init(with layers: [AnimatedTransitionLayer], options: Options) {
        self.layers = layers
        self.options = options
        super.init()
    }

    // MARK: AnimatedTransition

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return options.duration
    }

    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        layers.forEach({ $0.initialState(in: transitionContext) })
        UIView.animate(withDuration: options.duration, delay: options.delay,
                       usingSpringWithDamping: options.damping, initialSpringVelocity: options.velocity,
                       options: options.animationOptions,
                       animations: { [weak self] in
                        self?.layers.forEach({ $0.finalState(in: transitionContext) })
            }, completion: { [weak self] (finished) in
                self?.completeTransition(using: transitionContext)
        })
    }

    open func completeTransition(using context: UIViewControllerContextTransitioning) {
        layers.forEach({ $0.finish(in: context) })
        context.completeTransition(!context.transitionWasCancelled)
    }

}
