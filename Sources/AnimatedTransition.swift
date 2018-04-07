/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

public protocol AnimatedTransition: UIViewControllerAnimatedTransitioning {}

public protocol AnimatedTransitionLayer {
    func initialState(in context: UIViewControllerContextTransitioning) -> Void
    func finalState(in context: UIViewControllerContextTransitioning) -> Void
    func finish(in context: UIViewControllerContextTransitioning) -> Void
}

public extension AnimatedTransitionLayer {
    func initialState(in context: UIViewControllerContextTransitioning) -> Void {}
    func finalState(in context: UIViewControllerContextTransitioning) -> Void {}
    func finish(in context: UIViewControllerContextTransitioning) -> Void {}
}
