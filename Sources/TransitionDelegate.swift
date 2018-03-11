/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

open class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    // MARK: Properties

    let presentTransition: UIViewControllerAnimatedTransitioning
    let dismissTransition: UIViewControllerAnimatedTransitioning

    let presentInteractionController: UIViewControllerInteractiveTransitioning?
    let dismissInteractionController: UIViewControllerInteractiveTransitioning?

    var presentationController: UIPresentationController?

    // MARK: Init

    public init(presentTransition: UIViewControllerAnimatedTransitioning,
                dismissTransition: UIViewControllerAnimatedTransitioning,
                presentInteractionController: UIViewControllerInteractiveTransitioning? = nil,
                dismissInteractionController: UIViewControllerInteractiveTransitioning? = nil,
                presentationController: UIPresentationController? = nil) {
        self.presentTransition = presentTransition
        self.dismissTransition = dismissTransition
        self.presentInteractionController = presentInteractionController
        self.dismissInteractionController = dismissInteractionController
        self.presentationController = presentationController
    }

    // MARK: UIViewControllerTransitioningDelegate

    open func animationController(forPresented presented: UIViewController,
                                  presenting: UIViewController,
                                  source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentTransition
    }

    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissTransition
    }

    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return presentInteractionController
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissInteractionController
    }

    open func presentationController(forPresented presented: UIViewController,
                                     presenting: UIViewController?,
                                     source: UIViewController) -> UIPresentationController? {
        return presentationController
    }

}

extension TransitionDelegate: UINavigationControllerDelegate {

    open func navigationController(_ navigationController: UINavigationController,
                                   animationControllerFor operation: UINavigationControllerOperation,
                                   from fromVC: UIViewController,
                                   to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return presentTransition
        case .pop:
            return dismissTransition
        default:
            return nil
        }
    }

    public func navigationController(_ navigationController: UINavigationController,
                                     interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return presentInteractionController
    }

}

extension TransitionDelegate: UITabBarControllerDelegate {

    open func tabBarController(_ tabBarController: UITabBarController,
                               animationControllerForTransitionFrom fromVC: UIViewController,
                               to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentTransition
    }

    public func tabBarController(_ tabBarController: UITabBarController,
                                 interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return presentInteractionController
    }

}
