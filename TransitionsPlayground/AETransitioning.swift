//
//  AETransitioning.swift
//  TransitionsPlayground
//
//  Created by Marko Tadic on 11/23/14.
//  Copyright (c) 2014 AE. All rights reserved.
//

import UIKit

class AETransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate {
    
    let presentingTransition: UIViewControllerAnimatedTransitioning
    let dismissingTransition: UIViewControllerAnimatedTransitioning
    let presentationController: UIPresentationController?
    
    init (presentingTransition: UIViewControllerAnimatedTransitioning, dismissingTransition: UIViewControllerAnimatedTransitioning, presentationController: UIPresentationController? = nil) {
        self.presentingTransition = presentingTransition
        self.dismissingTransition = dismissingTransition
        self.presentationController = presentationController
    }
    
//    convenience init (transition: AETransition, presentationController: UIPresentationController? = nil) {
////        let presenting = transition
////        let dismissing = transition
////        presenting.presenting = true
////        dismissing.presenting = false
//        let presenting = AETransitionFade(presenting: true)
//        let dismissing = AETransitionFade(presenting: false)
//        self.init(presentingTransition: presenting, dismissingTransition: dismissing, presentationController: presentationController)
//    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentingTransition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissingTransition
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .Push:
            return presentingTransition
        case .Pop:
            return dismissingTransition
        default:
            return nil
        }
    }

    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentingTransition
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        return presentationController
    }
    
}

class AEPresentationController: UIPresentationController {
    
    
    
}

class AETransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting: Bool
    let duration: NSTimeInterval
    
    init(presenting: Bool = true, duration: NSTimeInterval = 0.5) {
        self.presenting = presenting
        self.duration = duration
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        doesNotRecognizeSelector(__FUNCTION__)
    }
    
}

class AETransitionFade: AETransition {
    
    override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
//        container.addSubview(toView)
//        container.addSubview(fromView)
//        
//        UIView.animateWithDuration(duration, animations: { () -> Void in
//            if self.presenting {
//                toView.alpha = 1.0
//            } else {
//                fromView.alpha = 0.0
//            }
//        }) { (finished) -> Void in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
//        }
        
        if presenting {
            println("fade presenting")
            toView.alpha = 0.0
            container.addSubview(toView)
            
            UIView.animateWithDuration(duration, animations: { () -> Void in
                toView.alpha = 1.0
            }, completion: { (finished) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        } else {
            println("fade dismissing")
            container.addSubview(toView)
            container.sendSubviewToBack(toView)
            
            UIView.animateWithDuration(duration, animations: { () -> Void in
                fromView.alpha = 0.0
                }, completion: { (finished) -> Void in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }
    }
    
}



























