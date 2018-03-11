/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

open class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    // MARK: Properties

    open var presentAnimation: UIViewControllerAnimatedTransitioning?
    open var dismissAnimation: UIViewControllerAnimatedTransitioning?

    open var presentInteraction: UIViewControllerInteractiveTransitioning?
    open var dismissInteraction: UIViewControllerInteractiveTransitioning?

    open var presentationController: UIPresentationController?

    // MARK: Init

    public init(presentAnimation: UIViewControllerAnimatedTransitioning? = nil,
                dismissAnimation: UIViewControllerAnimatedTransitioning? = nil,
                presentInteraction: UIViewControllerInteractiveTransitioning? = nil,
                dismissInteraction: UIViewControllerInteractiveTransitioning? = nil,
                presentationController: UIPresentationController? = nil) {
        self.presentAnimation = presentAnimation
        self.dismissAnimation = dismissAnimation
        self.presentInteraction = presentInteraction
        self.dismissInteraction = dismissInteraction
        self.presentationController = presentationController
    }

    // MARK: UIViewControllerTransitioningDelegate

    open func animationController(forPresented presented: UIViewController,
                                  presenting: UIViewController,
                                  source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimation
    }

    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimation
    }

    open func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return presentInteraction
    }

    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissInteraction
    }

    open func presentationController(forPresented presented: UIViewController,
                                     presenting: UIViewController?,
                                     source: UIViewController) -> UIPresentationController? {
        return presentationController
    }

}

extension TransitioningDelegate: UINavigationControllerDelegate {

    open func navigationController(_ navigationController: UINavigationController,
                                   animationControllerFor operation: UINavigationControllerOperation,
                                   from fromVC: UIViewController,
                                   to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return presentAnimation
        case .pop:
            return dismissAnimation
        default:
            return nil
        }
    }

    open func navigationController(_ navigationController: UINavigationController,
                                     interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return presentInteraction
    }

}

extension TransitioningDelegate: UITabBarControllerDelegate {

    open func tabBarController(_ tabBarController: UITabBarController,
                               animationControllerForTransitionFrom fromVC: UIViewController,
                               to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimation
    }

    open func tabBarController(_ tabBarController: UITabBarController,
                                 interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return presentInteraction
    }

}
