/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

public protocol AnimatedTransition: UIViewControllerAnimatedTransitioning {}

public protocol AnimatedTransitionLayer {
    func prepare(using context: UIViewControllerContextTransitioning) -> Void
    func animate(using context: UIViewControllerContextTransitioning) -> Void
}

public extension AnimatedTransitionLayer {
    func prepare(using context: UIViewControllerContextTransitioning) -> Void {}
    func animate(using context: UIViewControllerContextTransitioning) -> Void {}
}
