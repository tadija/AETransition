//
//  DestinationViewController.swift
//  TransitionsPlayground
//
//  Created by Marko Tadic on 11/22/14.
//  Copyright (c) 2014 AE. All rights reserved.
//

import UIKit

class DestinationViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
//    lazy var fadeAnimator: AETransitioningDelegate = {
//        let fadeIn = AETransitionFade(presenting: true)
//        let fadeOut = AETransitionFade(presenting: false)
//        let transitioningDelegate = AETransitioningDelegate(presentingTransition: fadeIn, dismissingTransition: fadeOut)
//        return transitioningDelegate
//        }()
//    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.commonInit()
//    }
//    
//    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)  {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        
//        self.commonInit()
//    }
//    
//    func commonInit() {
//        self.modalPresentationStyle = .Custom
//        self.transitioningDelegate = self
//        
////        self.transitioningDelegate = fadeAnimator
//    }
//    
//    
//    // ---- UIViewControllerTransitioningDelegate methods
//    
//    func presentationControllerForPresentedViewController(presented: UIViewController!, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController!) -> UIPresentationController! {
//        
//        if presented == self {
////            return CustomPresentationController(presentedViewController: presented, presentingViewController: presenting)
//            return AEPresentationController(presentedViewController: presented, presentingViewController: presenting, presentedViewFrame: CGRectMake(50, 50, 200, 400))
//        }
//        
//        return nil
//    }
//    
//    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
//        
//        if presented == self {
////            return CustomPresentationAnimationController(isPresenting: true)
//            return AETransitionFade(presenting: true)
//        }
//        else {
//            return nil
//        }
//    }
//    
//    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
//        
//        if dismissed == self {
////            return CustomPresentationAnimationController(isPresenting: false)
//            return AETransitionFade(presenting: false)
//        }
//        else {
//            return nil
//        }
//    }

}
