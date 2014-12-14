//
//  AETransitioning.swift
//  TransitionsPlayground
//
//  Created by Marko Tadic on 11/23/14.
//  Copyright (c) 2014 AE. All rights reserved.
//

import UIKit

// MARK: -
class AEAnimator: NSObject, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate {
    
    // MARK: Properties
    
    let presentingTransition: UIViewControllerAnimatedTransitioning
    let dismissingTransition: UIViewControllerAnimatedTransitioning
    
    var presentationController: UIPresentationController?
    
    // MARK: Lifecycle
    
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
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentingTransition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissingTransition
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        return presentationController
    }
    
    // MARK: UINavigationControllerDelegate
    
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
    
    // MARK: UITabBarControllerDelegate

    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentingTransition
    }
    
}

// MARK: -
@objc class AEPresentationController: UIPresentationController {
    
    // MARK: Properties
    
    var presentedViewFrame: CGRect?
    
    var presentingViewTransform: CGAffineTransform?
//    var presentedViewTransform: CGAffineTransform?
    
    var dimmingView: UIView = UIView()
    var dimmingViewColor: UIColor = UIColor(white: 0.5, alpha: 0.5) {
        didSet {
            dimmingView.backgroundColor = dimmingViewColor
        }
    }
    
    // MARK: Transition
    
    private func presentationTransition() {
        println("presentationTransition")
        // show dimming view
        self.dimmingView.alpha = 1.0
        
        // transform presenting view
        if let presentingViewTransform = self.presentingViewTransform {
            self.presentingViewController.view.transform = presentingViewTransform
        }
        
//        // transform presented view
//        if let presentedViewTransform = self.presentedViewTransform {
//            self.presentedViewController.view.transform = presentedViewTransform
//        }
    }
    
    private func dismissalTransition() {
        // hide dimming view
        self.dimmingView.alpha = 0.0
        
        // reset presenting view transform
        if let presentingViewTransform = self.presentingViewTransform {
            self.presentingViewController.view.transform = CGAffineTransformIdentity
        }
        
//        // reset presented view transform
//        if let presentedViewTransform = self.presentedViewTransform {
//            println("dismissalTransition CGAffineTransformIdentity")
//            self.presentedViewController.view.transform = CGAffineTransformIdentity
//        }
    }
    
    // MARK: UIPresentationController override
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        dimmingView.frame = containerView.bounds
    }
    
    override func presentationTransitionWillBegin() {
        // setup dimmingView
        self.dimmingView.frame = containerView.bounds
        self.dimmingView.backgroundColor = dimmingViewColor
        self.dimmingView.alpha = 0.0
        containerView.insertSubview(dimmingView, atIndex: 0)
        
        // do presentationTransition
        if let coordinator = presentedViewController.transitionCoordinator() {
            coordinator.animateAlongsideTransition({ (transitionContext: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.presentationTransition()
            }, completion: nil)
        } else {
            presentationTransition()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        // setup dimmingView
        self.dimmingView.frame = containerView.bounds
        
        // do dismissalTransition
        if let coordinator = presentedViewController.transitionCoordinator() {
            coordinator.animateAlongsideTransition({ (transitionContext: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dismissalTransition()
            }, completion: { (transitionContext: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dimmingView.removeFromSuperview()
            })
        } else {
            dismissalTransition()
            dimmingView.removeFromSuperview()
        }
    }
    
//    override func presentationTransitionDidEnd(completed: Bool) {
//        // transform presented view
//        if let presentedViewTransform = self.presentedViewTransform {
//            self.presentedViewController.view.transform = presentedViewTransform
//        }
//    }
    
//    override func dismissalTransitionDidEnd(completed: Bool) {
//        // reset presented view transform
//        if let presentedViewTransform = self.presentedViewTransform {
//            println("dismissalTransition CGAffineTransformIdentity")
//            self.presentedViewController.view.transform = CGAffineTransformIdentity
//        }
//    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        return presentedViewFrame ?? containerView.bounds
    }
    
    override func shouldPresentInFullscreen() -> Bool {
        return false
    }
    
    override func shouldRemovePresentersView() -> Bool {
        return false
    }
    
}

// MARK: -
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


//if presenting {
//    if let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {
//        println("fade in")
//        
//        if let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) {
//            toView.frame = transitionContext.finalFrameForViewController(toVC)
//        }
//        
//        toView.alpha = 0.0
//        container.addSubview(toView)
//        
//        UIView.animateWithDuration(duration, animations: { () -> Void in
//            toView.alpha = 1.0
//            }, completion: { (finished) -> Void in
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
//        })
//    }
//} else {
//    if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) {
//        println("fade out")
//        
//        if let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {
//            println("dismiss has toView")
//            container.addSubview(toView)
//            container.sendSubviewToBack(toView)
//        }
//        
//        UIView.animateWithDuration(duration, animations: { () -> Void in
//            fromView.alpha = 0.0
//            }, completion: { (finished) -> Void in
//                fromView.removeFromSuperview()
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
//        })
//    }
//}


//if presenting {
//
//    let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
//    let finalFrame = transitionContext.finalFrameForViewController(toVC)
//    let initialFrame = initialFrameForRect(finalFrame, direction: direction)
//    
//    if let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {
//        println("slide in")
//        
//        toView.frame = initialFrame
//        container.addSubview(toView)
//        
//        UIView.animateWithDuration(duration, animations: { () -> Void in
//            toView.frame = finalFrame
//            }, completion: { (finished) -> Void in
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
//        })
//    }
//} else {
//    
//    let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
//    let finalFrame = transitionContext.initialFrameForViewController(fromVC)
//    let initialFrame = initialFrameForRect(finalFrame, direction: direction)
//    
//    if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) {
//        println("slide out")
//        
//        if let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {
//            println("dismiss has toView")
//            container.addSubview(toView)
//            container.sendSubviewToBack(toView)
//        }
//        
//        UIView.animateWithDuration(duration, animations: { () -> Void in
//            fromView.frame = initialFrame
//            }, completion: { (finished) -> Void in
//                fromView.removeFromSuperview()
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
//        })
//    }
//}

class AETransitionCustom: AETransition {
    
    enum Position {
        case Top
        case Left
        case Bottom
        case Right
    }
    
    var initialFrame: CGRect?
    var initialSide: Position?
    var initialTransform: CGAffineTransform?
    
    var animateAlpha: Bool = false
    
    override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView()
        
        if presenting {
            if let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {
                println("fade in")
                
//                if let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) {
//                    toView.frame = transitionContext.finalFrameForViewController(toVC)
//                }
                
                let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
                let finalFrame = transitionContext.finalFrameForViewController(toVC)
                
//                var initialFrame = finalFrame
                var initialFrame = self.initialFrame ?? finalFrame
                if let initialPosition = self.initialSide {
                    initialFrame = initialFrameForRect(finalFrame, position: initialPosition)
                }
                
                println(initialFrame)
                toView.frame = initialFrame
                
                if let initialTransform = self.initialTransform {
                    toView.transform = initialTransform
                }
                
                if animateAlpha {
                    toView.alpha = 0.0
                }
                
                container.addSubview(toView)
                
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    
                    if let initialTransform = self.initialTransform {
                        toView.transform = CGAffineTransformIdentity
                    }
                    
//                    println(finalFrame)
                    toView.frame = finalFrame
                    
                    if self.animateAlpha {
                        toView.alpha = 1.0
                    }
                    
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
                
                let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
                let finalFrame = transitionContext.initialFrameForViewController(fromVC)
//                let finalFrame = transitionContext.finalFrameForViewController(fromVC)
                
//                var initialFrame = finalFrame
                var initialFrame = self.initialFrame ?? finalFrame
//                var initialFrame = fromView.bounds
//                println(initialFrame)
                if let initialPosition = self.initialSide {
                    initialFrame = initialFrameForRect(initialFrame, position: initialPosition)
                }
                
//                if let initialTransform = self.initialTransform {
//                    fromView.transform = CGAffineTransformIdentity
//                }
                
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    
                    println(initialFrame)
                    fromView.frame = initialFrame
                    
                    if let initialTransform = self.initialTransform {
                        println("animation initialTransform")
                        fromView.transform = initialTransform
//                        fromView.transform = CGAffineTransformConcat(initialTransform, CGAffineTransformIdentity)
//                        fromView.transform = CGAffineTransformIdentity
                    }
                    
//                    fromView.frame = initialFrame
                    
                    if self.animateAlpha {
                        fromView.alpha = 0.0
                    }

                }, completion: { (finished) -> Void in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                })
            }
        }
        
    }
    
    func initialFrameForRect(rect: CGRect, position: Position) -> CGRect {
        
        var initialFrame = rect
        
        switch position {
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
                
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    toView.frame = finalFrame
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
                
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    fromView.frame = initialFrame
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


















