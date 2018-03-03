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
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentingTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissingTransition
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return presentationController
    }
    
    // MARK: UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return presentingTransition
        case .pop:
            return dismissingTransition
        default:
            return nil
        }
    }
    
    // MARK: UITabBarControllerDelegate

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
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
    
    fileprivate func presentationTransition() {
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
    
    fileprivate func dismissalTransition() {
        // hide dimming view
        self.dimmingView.alpha = 0.0
        
        // reset presenting view transform
        if let _ = self.presentingViewTransform {
            self.presentingViewController.view.transform = CGAffineTransform.identity
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
        dimmingView.frame = containerView!.bounds
    }
    
    override func presentationTransitionWillBegin() {
        // setup dimmingView
        self.dimmingView.frame = containerView!.bounds
        self.dimmingView.backgroundColor = dimmingViewColor
        self.dimmingView.alpha = 0.0
        containerView!.insertSubview(dimmingView, at: 0)
        
        // do presentationTransition
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (transitionContext: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.presentationTransition()
            }, completion: nil)
        } else {
            presentationTransition()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        // setup dimmingView
        self.dimmingView.frame = containerView!.bounds
        
        // do dismissalTransition
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (transitionContext: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dismissalTransition()
            }, completion: { (transitionContext: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dimmingView.removeFromSuperview()
            })
        } else {
            dismissalTransition()
            dimmingView.removeFromSuperview()
        }
    }
    
    override var frameOfPresentedViewInContainerView : CGRect {
        return presentedViewFrame ?? containerView!.bounds
    }
    
    override var shouldPresentInFullscreen : Bool {
        return false
    }
    
    override var shouldRemovePresentersView : Bool {
        return false
    }
    
}

// MARK: -
class AETransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: Properties
    
    class var defaultDuration: TimeInterval { return 0.5 }
    
    var presenting: Bool
    var duration: TimeInterval
    
    // MARK: Lifecycle
    
    init(presenting: Bool = true, duration: TimeInterval = defaultDuration) {
        self.presenting = presenting
        self.duration = duration
    }
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        print("\(#function) must be implemented by subclass")
    }
    
}

// MARK: -
class AETransitionCustom: AETransition {
    
    enum Side {
        case top
        case left
        case bottom
        case right
    }
    
    // MARK: Properties
    
    var animateAlpha: Bool = false
    var initialSide: Side?
    var initialFrame: CGRect?
    var initialTransform: CGAffineTransform?
    
    // MARK: Animation
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        
        if presenting {
            // prepare
            if let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                if let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) {
                    
                    // frame
                    let finalFrame = transitionContext.finalFrame(for: toVC)
                    var initialFrame = self.initialFrame ?? finalFrame
                    if let side = initialSide {
                        initialFrame = initialFrameForRect(finalFrame, side: side)
                    }
                    toView.frame = initialFrame
                    
                    // transform
                    if let transform = initialTransform {
                        toView.transform = transform
                    }
                    
                    // alpha
                    if animateAlpha {
                        toView.alpha = 0.0
                    }
                    
                    container.addSubview(toView)
                    
                    // animate
                    UIView.animate(withDuration: duration, animations: { () -> Void in
                        
                        // transform
                        if let _ = self.initialTransform {
                            toView.transform = CGAffineTransform.identity
                        }
                        
                        // frame
                        toView.frame = finalFrame
                        
                        // alpha
                        if self.animateAlpha {
                            toView.alpha = 1.0
                        }
                        
                    }, completion: { (finished) -> Void in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    })
                }
            }
        } else {
            // prepare
            if let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) {
                if let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) {
                    
                    // must do this if dismiss has toView
                    if let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                        container.addSubview(toView)
                        container.sendSubview(toBack: toView)
                    }
                    
                    // frame
                    let finalFrame = transitionContext.initialFrame(for: fromVC)
                    var initialFrame = self.initialFrame ?? finalFrame
                    if let side = initialSide {
                        initialFrame = initialFrameForRect(finalFrame, side: side)
                    }
                    
                    // animate
                    UIView.animate(withDuration: duration, animations: { () -> Void in
                        
                        // frame
                        fromView.frame = initialFrame
                        
                        // transform
                        if let transform = self.initialTransform {
                            fromView.transform = transform
                        }
                        
                        // alpha
                        if self.animateAlpha {
                            fromView.alpha = 0.0
                        }
                        
                    }, completion: { (finished) -> Void in
                        fromView.removeFromSuperview()
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    })
                }
            }
        }
        
    }
    
    func initialFrameForRect(_ rect: CGRect, side: Side) -> CGRect {
        
        var initialFrame = rect
        
        // calculate initial frame for given side
        switch side {
        case .top:
            initialFrame.origin.y -= rect.height + rect.minY
        case .left:
            initialFrame.origin.x -= rect.width + rect.minX
        case .bottom:
            initialFrame.origin.y += rect.height + rect.minY
        case .right:
            initialFrame.origin.x += rect.width + rect.minX
        }
        
        return initialFrame
    }
    
}

// MARK: - Fade
class AETransitionFadeIn: AETransitionCustom {
    
    init(duration: TimeInterval = defaultDuration) {
        super.init(presenting: true, duration: duration)
        animateAlpha = true
    }
    
}

class AETransitionFadeOut: AETransitionCustom {
    
    init(duration: TimeInterval = defaultDuration) {
        super.init(presenting: false, duration: duration)
        animateAlpha = true
    }
    
}

// MARK: - Slide
class AETransitionSlideIn: AETransitionCustom {
    
    init(fromSide: Side = .right, duration: TimeInterval = defaultDuration) {
        super.init(presenting: true, duration: duration)
        initialSide = fromSide
    }
    
}

class AETransitionSlideOut: AETransitionCustom {
    
    init(toSide: Side = .right, duration: TimeInterval = defaultDuration) {
        super.init(presenting: false, duration: duration)
        initialSide = toSide
    }
    
}

class AETransitionPopOut: AETransitionCustom {
    
}

class AETransitionPopIn: AETransitionCustom {
    
}























