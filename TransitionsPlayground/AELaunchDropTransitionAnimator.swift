//
//  AELaunchDropTransitionAnimator.swift
//  TweetPlay
//
//  This is Objective-c rewrite from old project
//  It barely works, not ready for production usage.
//
//  Created by Marko Tadic on 11/30/15.
//  Copyright © 2015 AE. All rights reserved.
//

import UIKit

public protocol AELaunchDropDelegate: class {
    /// called when user starts interactive transition (launch)
    func launchDidBegin(launchDropTransitionAnimator: AELaunchDropTransitionAnimator)
}

public class AELaunchDropTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning/*, UIViewControllerContextTransitioning*/ {
    
    // MARK: - Constants
    
    private struct Constants {
        static let LaunchLimit = 0.33
        static let LaunchPercentageChangedNotification = "LaunchPercentageChangedNotification"
    }
    
    // MARK: - Properties
    
    // AEBaseTransitionAnimator
    public var unwinding: Bool = false
    public var duration: NSTimeInterval = 0.5
    
    // AELaunchDropTransitionAnimator
    public weak var delegate: AELaunchDropDelegate?
    public var launchPercentageCompleted: CGFloat {
        return CGRectGetMinY(launchDropView.frame) / CGRectGetHeight(containerView.frame)
    }
    
    // gesture
    private var panGesture: UIPanGestureRecognizer!
    private var touchOffsetFromCenter = UIOffsetZero
    
    // transition
    private var context: UIViewControllerContextTransitioning!
    private var containerView: UIView!
    
    // launch drop
    private var gravityForce = 0.0
    private var launchDropView: UIView!
    private var dropAnimator: UIDynamicAnimator!
    private lazy var launchDropBehaviour: UIDynamicItemBehavior = {
        [unowned self] in
        let ldb = UIDynamicItemBehavior(items: [self.launchDropView])
        ldb.allowsRotation = false
        ldb.elasticity = 0.6
        ldb.resistance = 0.5
        ldb.density = 7.0
        return ldb
    }()
    
    // MARK: - Lifecycle
    
    public init(sourceView: UIView) {
        super.init()
        
        duration = 0.0
        panGesture = UIPanGestureRecognizer(target: self, action: "panned:")
        sourceView.addGestureRecognizer(panGesture)
    }
    
    deinit {
        panGesture.view?.removeFromSuperview()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // get views
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()!
        
        // set frames
        let finalFrame = transitionContext.finalFrameForViewController(toVC)
        var initialFrame = finalFrame
        initialFrame.origin.y -= CGRectGetHeight(initialFrame)
        toVC.view.frame = initialFrame
        
        // add to container
        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)
        
        // set launch drop view
        launchDropView = toVC.view
        
        // create collision on the bottom edge of container
        let collision = UICollisionBehavior(items: [toVC.view])
        let topInset = -CGRectGetHeight(containerView.bounds)
        collision.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0))
        
        // create gravity
        let gravity = UIGravityBehavior(items: [toVC.view])
        gravity.gravityDirection = CGVector(dx: 0.0, dy: 9.81)
        
        // create animator and add behaviors
        dropAnimator = UIDynamicAnimator(referenceView: containerView)
        dropAnimator.addBehavior(collision)
        dropAnimator.addBehavior(gravity)
        dropAnimator.addBehavior(launchDropBehaviour)
        
        // add action to gravity
        gravity.action = {
            [weak self] in
            // stop animator and complete transition when view is dropped
            let view = self?.launchDropView
            if (view?.frame.origin.y >= 0 && self?.dropAnimator.elapsedTime() > self?.duration) {
                self?.dropAnimator.removeAllBehaviors()
                view?.frame = finalFrame
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
        }
    }
    
    // MARK: - UIViewControllerInteractiveTransitioning
    
    public func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        // get views
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()!
        
        // set frames
        fromVC.view.frame = transitionContext.initialFrameForViewController(fromVC)
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        
        // add to container
        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)
        containerView.bringSubviewToFront(fromVC.view)
        
        // set properties
        context = transitionContext
        self.containerView = containerView
        launchDropView = fromVC.view

        // set gesture offset from center
        let fingerPoint = panGesture.locationInView(launchDropView)
        let viewCenter = launchDropView.center
        touchOffsetFromCenter = UIOffsetMake(fingerPoint.x - viewCenter.x, fingerPoint.y * 0.9 - viewCenter.y)
    }
    
    // MARK: - Gesture interaction
    
    public func panned(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Began:
            // inform delegate that launch began
            delegate?.launchDidBegin(self)
            
        case .Changed:
            // get touch location in containerView
            let touchLocation = panGesture.locationInView(containerView)
            
            // set new center location for launch drop view
            var center = launchDropView.center
            center.y = touchLocation.y * 0.9 - touchOffsetFromCenter.vertical
            
            // set gravity force accourding to gesture Y translation
            gravityForce = Double(panGesture.translationInView(launchDropView).y) * 0.04
            
            // do interaction only if gesture direction is from top to bottom
            if panGesture.translationInView(launchDropView).y > 0 {
                // set launch drop view transparent
                self.animateLaunchDropViewAlphaToValue(0.9)
                // move launch drop view to center
                launchDropView.center = center
                // post notification
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.LaunchPercentageChangedNotification, object: self)
                // update transition percentage
                context.updateInteractiveTransition(launchPercentageCompleted)
            }
            
        case .Ended:
            if launchPercentageCompleted >= CGFloat(Constants.LaunchLimit) {
                finishInteraction()
            } else {
                cancelInteraction()
            }
            
        default:
            cancelInteraction()
        }

    }
    
    private func animateLaunchDropViewAlphaToValue(value: CGFloat) {
        // set launchDropView alpha when starting or ending transition
        UIView.transitionWithView(launchDropView, duration: 0.3, options: .AllowUserInteraction, animations: { () -> Void in
            self.launchDropView.alpha = value
            }, completion: nil)
    }
    
    // MARK: - UIViewControllerContextTransitioning
    
    private func finishInteraction() {
        // set launch drop view opaque
        animateLaunchDropViewAlphaToValue(1.0)
        
        // get views
        let fromVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        var finalFrame = context.initialFrameForViewController(fromVC)
        finalFrame.origin.y -= CGRectGetHeight(finalFrame)
        
        // create gravity and set it's dynamic force
        let gravity = UIGravityBehavior(items: [launchDropView])
        gravity.gravityDirection = CGVector(dx: 0.0, dy: -gravityForce)
        
        // create animator and add behaviours
        let animator = UIDynamicAnimator(referenceView: containerView)
        animator.addBehavior(gravity)
        animator.addBehavior(launchDropBehaviour)
        
        // add action to gravity
        gravity.action = {
            [weak self] in
            // stop animator and complete transition when launchDropView is off screen
            let view = self?.launchDropView
            if self?.launchPercentageCompleted < -1.0 && animator.elapsedTime() > self?.duration {
                animator.removeAllBehaviors()
                view?.frame = finalFrame
                self?.completeTransition()
            }
        }
        
        // finish interaction
        context.finishInteractiveTransition()
    }
    
    private func cancelInteraction() {
        // set launch drop view opaque
        animateLaunchDropViewAlphaToValue(1.0)
        
        // get views
        let fromVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let initialFrame = context.initialFrameForViewController(fromVC)
        
        // set point for the view to snap back in place
        let snapPoint = CGPoint(x: CGRectGetMidX(initialFrame), y: CGRectGetMidY(initialFrame))
        
        // create snap with damping
        let snap = UISnapBehavior(item: launchDropView, snapToPoint: snapPoint)
        snap.damping = 0.21
        
        // create animator and add behaviors
        let animator = UIDynamicAnimator(referenceView: containerView)
        animator.addBehavior(snap)
        animator.addBehavior(launchDropBehaviour)
        
        // add action to snap
        snap.action = {
            [weak self] in
            // stop animator and complete transition when view is snapped back to place
            let view = self!.launchDropView
            if abs(view.frame.origin.y) < 0.5 && self?.launchDropBehaviour.linearVelocityForItem(view).y < 0.01 && animator.elapsedTime() > self?.duration {
                animator.removeAllBehaviors()
                view?.frame = initialFrame
                self?.completeTransition()
            }
        }
        
        // cancel interaction
        context.cancelInteractiveTransition()
    }
    
    private func completeTransition() {
        // complete transition
        let finished = !context.transitionWasCancelled()
        context.completeTransition(finished)
        
        // reset properties
        context = nil
        containerView = nil
        launchDropView = nil
        touchOffsetFromCenter = UIOffsetZero
    }
    
}