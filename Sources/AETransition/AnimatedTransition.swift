/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2019
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

public protocol AnimatedTransition: UIViewControllerAnimatedTransitioning {}

public protocol AnimatedTransitionLayer: CustomDebugStringConvertible {
    func initialState(in context: UIViewControllerContextTransitioning) -> Void
    func finalState(in context: UIViewControllerContextTransitioning) -> Void
    func cleanup(in context: UIViewControllerContextTransitioning) -> Void
}

public extension AnimatedTransitionLayer {
    func initialState(in context: UIViewControllerContextTransitioning) -> Void {}
    func finalState(in context: UIViewControllerContextTransitioning) -> Void {}
    func cleanup(in context: UIViewControllerContextTransitioning) -> Void {}
}
