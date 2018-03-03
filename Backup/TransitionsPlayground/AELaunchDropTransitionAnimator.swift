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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


public protocol AELaunchDropDelegate: class {
    /// called when user starts interactive transition (launch)
    func launchDidBegin(_ launchDropTransitionAnimator: AELaunchDropTransitionAnimator)
}

open class AELaunchDropTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning/*, UIViewControllerContextTransitioning*/ {
    
    // MARK: - Constants
    
    fileprivate struct Constants {
        static let LaunchLimit = 0.33
        static let LaunchPercentageChangedNotification = "LaunchPercentageChangedNotification"
    }
    
    // MARK: - Properties
    
    // AEBaseTransitionAnimator
    open var unwinding: Bool = false
    open var duration: TimeInterval = 0.5
    
    // AELaunchDropTransitionAnimator
    open weak var delegate: AELaunchDropDelegate?
    open var launchPercentageCompleted: CGFloat {
        return launchDropView.frame.minY / containerView.frame.height
    }
    
    // gesture
    fileprivate var panGesture: UIPanGestureRecognizer!
    fileprivate var touchOffsetFromCenter = UIOffset.zero
    
    // transition
    fileprivate var context: UIViewControllerContextTransitioning!
    fileprivate var containerView: UIView!
    
    // launch drop
    fileprivate var gravityForce = 0.0
    fileprivate var launchDropView: UIView!
    fileprivate var dropAnimator: UIDynamicAnimator!
    fileprivate lazy var launchDropBehaviour: UIDynamicItemBehavior = {
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
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(AELaunchDropTransitionAnimator.panned(_:)))
        sourceView.addGestureRecognizer(panGesture)
    }
    
    deinit {
        panGesture.view?.removeFromSuperview()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // get views
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        // set frames
        let finalFrame = transitionContext.finalFrame(for: toVC)
        var initialFrame = finalFrame
        initialFrame.origin.y -= initialFrame.height
        toVC.view.frame = initialFrame
        
        // add to container
        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)
        
        // set launch drop view
        launchDropView = toVC.view
        
        // create collision on the bottom edge of container
        let collision = UICollisionBehavior(items: [toVC.view])
        let topInset = -containerView.bounds.height
        collision.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0))
        
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
            if (view?.frame.origin.y >= 0 && self?.dropAnimator.elapsedTime > self?.duration) {
                self?.dropAnimator.removeAllBehaviors()
                view?.frame = finalFrame
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
    
    // MARK: - UIViewControllerInteractiveTransitioning
    
    open func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        // get views
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        // set frames
        fromVC.view.frame = transitionContext.initialFrame(for: fromVC)
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        
        // add to container
        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)
        containerView.bringSubview(toFront: fromVC.view)
        
        // set properties
        context = transitionContext
        self.containerView = containerView
        launchDropView = fromVC.view

        // set gesture offset from center
        let fingerPoint = panGesture.location(in: launchDropView)
        let viewCenter = launchDropView.center
        touchOffsetFromCenter = UIOffsetMake(fingerPoint.x - viewCenter.x, fingerPoint.y * 0.9 - viewCenter.y)
    }
    
    // MARK: - Gesture interaction
    
    open func panned(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            // inform delegate that launch began
            delegate?.launchDidBegin(self)
            
        case .changed:
            // get touch location in containerView
            let touchLocation = panGesture.location(in: containerView)
            
            // set new center location for launch drop view
            var center = launchDropView.center
            center.y = touchLocation.y * 0.9 - touchOffsetFromCenter.vertical
            
            // set gravity force accourding to gesture Y translation
            gravityForce = Double(panGesture.translation(in: launchDropView).y) * 0.04
            
            // do interaction only if gesture direction is from top to bottom
            if panGesture.translation(in: launchDropView).y > 0 {
                // set launch drop view transparent
                self.animateLaunchDropViewAlphaToValue(0.9)
                // move launch drop view to center
                launchDropView.center = center
                // post notification
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.LaunchPercentageChangedNotification), object: self)
                // update transition percentage
                context.updateInteractiveTransition(launchPercentageCompleted)
            }
            
        case .ended:
            if launchPercentageCompleted >= CGFloat(Constants.LaunchLimit) {
                finishInteraction()
            } else {
                cancelInteraction()
            }
            
        default:
            cancelInteraction()
        }

    }
    
    fileprivate func animateLaunchDropViewAlphaToValue(_ value: CGFloat) {
        // set launchDropView alpha when starting or ending transition
        UIView.transition(with: launchDropView, duration: 0.3, options: .allowUserInteraction, animations: { () -> Void in
            self.launchDropView.alpha = value
            }, completion: nil)
    }
    
    // MARK: - UIViewControllerContextTransitioning
    
    fileprivate func finishInteraction() {
        // set launch drop view opaque
        animateLaunchDropViewAlphaToValue(1.0)
        
        // get views
        let fromVC = context.viewController(forKey: UITransitionContextViewControllerKey.from)!
        var finalFrame = context.initialFrame(for: fromVC)
        finalFrame.origin.y -= finalFrame.height
        
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
            if self?.launchPercentageCompleted < -1.0 && animator.elapsedTime > self?.duration {
                animator.removeAllBehaviors()
                view?.frame = finalFrame
                self?.completeTransition()
            }
        }
        
        // finish interaction
        context.finishInteractiveTransition()
    }
    
    fileprivate func cancelInteraction() {
        // set launch drop view opaque
        animateLaunchDropViewAlphaToValue(1.0)
        
        // get views
        let fromVC = context.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let initialFrame = context.initialFrame(for: fromVC)
        
        // set point for the view to snap back in place
        let snapPoint = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
        
        // create snap with damping
        let snap = UISnapBehavior(item: launchDropView, snapTo: snapPoint)
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
            if abs(view!.frame.origin.y) < 0.5 && self?.launchDropBehaviour.linearVelocity(for: view!).y < 0.01 && animator.elapsedTime > self?.duration {
                animator.removeAllBehaviors()
                view?.frame = initialFrame
                self?.completeTransition()
            }
        }
        
        // cancel interaction
        context.cancelInteractiveTransition()
    }
    
    fileprivate func completeTransition() {
        // complete transition
        let finished = !context.transitionWasCancelled
        context.completeTransition(finished)
        
        // reset properties
        context = nil
        containerView = nil
        launchDropView = nil
        touchOffsetFromCenter = UIOffset.zero
    }
    
}
