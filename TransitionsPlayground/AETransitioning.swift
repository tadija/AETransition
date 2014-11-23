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
    var presentationController: UIPresentationController?
    
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

@objc class AEPresentationController: UIPresentationController {
    
    let presentedViewFrame: CGRect

    init(presentedViewController: UIViewController!, presentingViewController: UIViewController!, presentedViewFrame: CGRect) {
        self.presentedViewFrame = presentedViewFrame
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        return presentedViewFrame
    }
    
    override func shouldPresentInFullscreen() -> Bool {
        return false
    }
    
    override func shouldRemovePresentersView() -> Bool {
        return false
    }
    
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
        println("\(__FUNCTION__) must be implemented by subclass")
    }
    
}

// see: http://stackoverflow.com/questions/24338700/from-view-controller-disappears-using-uiviewcontrollercontexttransitioning

class AETransitionFade: AETransition {
    
    override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView()

        if presenting {
            if let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {
                println("fade in")
                
                if let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) {
                    toView.frame = transitionContext.finalFrameForViewController(toVC)
                }
                
                toView.alpha = 0.0
                container.addSubview(toView)
                
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    toView.alpha = 1.0
                }, completion: { (finished) -> Void in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                })
            }
        } else {
            if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) {
                println("fade out")
                
                if let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {
                    println("dismiss has toView")
                    container.addSubview(toView)
                    container.sendSubviewToBack(toView)
                }
                
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    fromView.alpha = 0.0
                }, completion: { (finished) -> Void in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                })
            }
        }
        
    }
    
}

//// original old version
//class AETransitionFade: AETransition {
//    
//    override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
//        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
//        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
//        let containerView = transitionContext.containerView()
//        
//        fromVC.view.frame = transitionContext.initialFrameForViewController(fromVC)
//        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
//        
//        if presenting {
//            toVC.view.alpha = 0.0
//            containerView.addSubview(toVC.view)
//            
//            UIView.animateWithDuration(duration, animations: { () -> Void in
//                toVC.view.alpha = 1.0
//                }, completion: { (finished) -> Void in
//                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
//            })
//        } else {
//            containerView.addSubview(toVC.view)
//            containerView.sendSubviewToBack(toVC.view)
//            
//            UIView.animateWithDuration(duration, animations: { () -> Void in
//                fromVC.view.alpha = 0.0
//                }, completion: { (finished) -> Void in
//                    fromVC.view.removeFromSuperview()
//                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
//            })
//        }
//    }
//    
//}



















