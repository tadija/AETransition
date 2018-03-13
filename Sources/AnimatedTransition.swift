/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

public typealias ContextHandler = (UIViewControllerContextTransitioning) -> Void

open class AnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: Properties

    open let duration: TimeInterval
    open var transitionAnimation: ContextHandler?

    // MARK: Init

    public init(duration: TimeInterval, transitionAnimation: ContextHandler? = nil) {
        self.duration = duration
        self.transitionAnimation = transitionAnimation
    }

    // MARK: UIViewControllerAnimatedTransitioning

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionAnimation?(transitionContext)
    }

}
