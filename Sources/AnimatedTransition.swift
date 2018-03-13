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
