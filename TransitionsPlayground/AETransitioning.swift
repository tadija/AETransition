//
//  AETransitioning.swift
//  TransitionsPlayground
//
//  Created by Marko Tadic on 11/23/14.
//  Copyright (c) 2014 AE. All rights reserved.
//

import UIKit

class AEAnimator: NSObject, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate {
    
    let presentingTransition: UIViewControllerAnimatedTransitioning
    let dismissingTransition: UIViewControllerAnimatedTransitioning
    var presentationController: UIPresentationController?
    
    init (presentTransition: UIViewControllerAnimatedTransitioning, dismissTransition: UIViewControllerAnimatedTransitioning, presentationController: UIPresentationController? = nil) {
        self.presentingTransition = presentTransition
        self.dismissingTransition = dismissTransition
        self.presentationController = presentationController
    }
    
    convenience init (transition: AETransition.Type, presentationController: UIPresentationController? = nil) {
        let presenting = transition(presenting: true)
        let dismissing = transition(presenting: false)
        self.init(presentTransition: presenting, dismissTransition: dismissing, presentationController: presentationController)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentingTransition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissingTransition
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        return presentationController
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
    
}

@objc class AEPresentationController: UIPresentationController {
    
    let presentedViewFrame: CGRect

    init(presentedViewController: UIViewController!, presentingViewController: UIViewController!, presentedViewFrame: CGRect) {
        self.presentedViewFrame = presentedViewFrame
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    override func presentationTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator() {
            
            coordinator.animateAlongsideTransition({ (transitionContext: UIViewControllerTransitionCoordinatorContext!) -> Void in
                var newFrame = self.presentingViewController.view.frame
                newFrame.origin.x = CGRectGetMaxX(self.presentedViewFrame)
                self.presentingViewController.view.frame = newFrame
                
//                // has only toView
//                if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) {
//                    println("has from view")
//                    if let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {
//                        println("has to view")
//                        var newFrame = fromView.frame
//                        newFrame.origin.x = CGRectGetMaxX(toView.frame)
//                        fromView.frame = newFrame
//                    }
//                }
                
            }, completion: nil)
            
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator() {
            coordinator.animateAlongsideTransition({ (transitionContext: UIViewControllerTransitionCoordinatorContext!) -> Void in
                var newFrame = self.presentingViewController.view.frame
                newFrame.origin.x = 0
                self.presentingViewController.view.frame = newFrame
            }, completion: nil)
        }
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

// note to myself: probably all the logic can be inside AETransition (alpha, frame, direction)

class AETransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting: Bool
    let duration: NSTimeInterval
    
    required init(presenting: Bool = true, duration: NSTimeInterval = 0.5) {
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

class AETransitionSlide: AETransition {
    
    enum Direction {
        case Top
        case Left
        case Bottom
        case Right
    }
    
    let direction: Direction
    
    init(presenting: Bool, duration: NSTimeInterval, direction: Direction) {
        self.direction = direction
        super.init(presenting: presenting, duration: duration)
    }
    
    required convenience init(presenting: Bool, duration: NSTimeInterval) {
        self.init(presenting: presenting, duration: duration, direction: .Right)
    }
    
    override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        let container = transitionContext.containerView()
        
        if presenting {
            
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
            let finalFrame = transitionContext.finalFrameForViewController(toVC)
            let initialFrame = initialFrameForRect(finalFrame, direction: direction)
            
            if let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {
                println("slide in")
                
                toView.frame = initialFrame
                container.addSubview(toView)
                
//                // testing
//                var fromView = UIView()
//                var fromFrame = CGRectZero
//                if let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) {
//                    println("fromVC")
//                    println(fromVC.view.frame)
//                    fromView = fromVC.view
//                    fromFrame = fromVC.view.frame
//                    fromFrame.origin.x = CGRectGetMaxX(finalFrame)
//                }
//                // testing
                
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    toView.frame = finalFrame
//                    fromView.frame = fromFrame // testing
                    }, completion: { (finished) -> Void in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                })
            }
        } else {
            
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
            let finalFrame = transitionContext.initialFrameForViewController(fromVC)
            let initialFrame = initialFrameForRect(finalFrame, direction: direction)
            
            if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) {
                println("slide out")
                
                if let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {
                    println("dismiss has toView")
                    container.addSubview(toView)
                    container.sendSubviewToBack(toView)
                }
                
//                // testing
//                var toView = UIView()
//                var toFrame = CGRectZero
//                if let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) {
//                    println("toVC")
//                    println(toVC.view.frame)
//                    toView = toVC.view
//                    toFrame = toVC.view.frame
//                    toFrame.origin.x = 0
//                }
//                // testing
                
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    fromView.frame = initialFrame
//                    toView.frame = toFrame // testing
                    }, completion: { (finished) -> Void in
                        fromView.removeFromSuperview()
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                })
            }
        }
        
    }
    
    // use direction property
    func initialFrameForRect(rect: CGRect, direction: Direction) -> CGRect {
        
        var initialFrame = rect
        
        switch direction {
        case .Top:
            initialFrame.origin.y -= CGRectGetHeight(rect) + CGRectGetMinY(rect)
        case .Left:
            initialFrame.origin.x -= CGRectGetWidth(rect) + CGRectGetMinX(rect)
        case .Bottom:
            initialFrame.origin.y += CGRectGetHeight(rect) + CGRectGetMinY(rect)
        case .Right:
            initialFrame.origin.x += CGRectGetWidth(rect) + CGRectGetMinX(rect)
        }
        
        return initialFrame
    }
    
}


















