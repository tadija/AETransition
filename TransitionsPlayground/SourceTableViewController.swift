//
//  SourceTableViewController.swift
//  TransitionsPlayground
//
//  Created by Marko Tadic on 11/22/14.
//  Copyright (c) 2014 AE. All rights reserved.
//

import UIKit

class SourceTableViewController: UITableViewController {
    
    lazy var fadeAnimator: AEAnimator = {
        let animator = AEAnimator(transition: AETransitionFade.self)
        
//        let fadeIn = AETransitionFade(presenting: true)
//        let fadeOut = AETransitionFade(presenting: false)
//        let animator = AEAnimator(presentTransition: fadeIn, dismissTransition: fadeOut)
        
        return animator
    }()
    
    lazy var slideAnimator: AEAnimator = {
        let animator = AEAnimator(transition: AETransitionSlide.self)
        
//        let slideFromTop = AETransitionSlide(presenting: true, duration: 0.5, direction: .Top)
//        let slideToBottom = AETransitionSlide(presenting: false, duration: 0.3, direction: .Bottom)
//        let animator = AEAnimator(presentTransition: slideFromTop, dismissTransition: slideToBottom)
        
        return animator
    }()
    
    lazy var slideAnimatorCustom: AEAnimator = {
        let slideFromLeft = AETransitionSlide(presenting: true, duration: 0.5, direction: .Left)
        let slideToLeft = AETransitionSlide(presenting: false, duration: 0.3, direction: .Left)
        let animator = AEAnimator(presentTransition: slideFromLeft, dismissTransition: slideToLeft)
        
        return animator
    }()
    
    lazy var fadeAnimatorCustom: AEAnimator = {
        let present = AETransitionCustom(presenting: true)
        present.animateAlpha = true
//        present.initialSide = .Top
//        present.initialTransform = CGAffineTransformMakeScale(0.01, 0.01)
//        present.initialTransform = CGAffineTransformMake(0, 1, 1, 0.5, 0, 100)
//        let scale = CGAffineTransformMakeScale(0.01, 0.01)
//        let translate = CGAffineTransformMakeTranslation(-100, -100)
//        present.initialTransform = CGAffineTransformConcat(scale, translate)
        present.initialTransform = CGAffineTransformMakeScale(0.25, 0.25)
        present.initialFrame = CGRect(x: 100, y: 200, width: 100, height: 100)
        
        let dismiss = AETransitionCustom(presenting: false)
        dismiss.animateAlpha = true
//        dismiss.initialSide = .Bottom
//        dismiss.initialTransform = CGAffineTransformMakeScale(0.01, 0.01)
//        dismiss.initialTransform = CGAffineTransformConcat(scale, translate)
        dismiss.initialTransform = CGAffineTransformMakeScale(0.25, 0.25)
        dismiss.initialFrame = CGRect(x: 100, y: 200, width: 100, height: 100)
        
        let animator = AEAnimator(presentTransition: present, dismissTransition: dismiss)
        return animator
    }()
    
    @IBAction func unwindToSourceTVC(segue: UIStoryboardSegue) {
        println("unwindToSourceTVC")
        if let p = presentedViewController {
            if p.modalPresentationStyle == .Custom {
                println("manual dismiss")
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toViewController = segue.destinationViewController as UIViewController
        
        // FADE
        
        if segue.identifier == "fadeSeguePush" {
            navigationController?.delegate = fadeAnimator
        }
        
        if segue.identifier == "fadeSegueReplace" {
            toViewController.transitioningDelegate = fadeAnimator
        }
        
        if segue.identifier == "fadeSegueModalDefault" {
            toViewController.transitioningDelegate = fadeAnimator
        }
        
        if segue.identifier == "fadeSegueModalCustom" {
            // setup presentationController
            var presentedViewFrame = CGRectInset(view.frame, 40, 80)
//            let presentedViewTransform = CGAffineTransformMakeRotation(0.2)
            
            let presentationController = AEPresentationController(presentedViewController: toViewController, presentingViewController: self)
            presentationController.presentedViewFrame = presentedViewFrame
//            presentationController.presentedViewTransform = presentedViewTransform
//
//            fadeAnimator.presentationController = presentationController
//            
//            // set custom modal presentation style and transitioning delegate
//            toViewController.modalPresentationStyle = .Custom
//            toViewController.transitioningDelegate = fadeAnimator
            
            // test custom
            fadeAnimatorCustom.presentationController = presentationController
            toViewController.modalPresentationStyle = .Custom
            toViewController.transitioningDelegate = fadeAnimatorCustom
        }
        
        if segue.identifier == "fadeSeguePopover" {
            toViewController.transitioningDelegate = fadeAnimator
        }
        
        if segue.identifier == "fadeSegueCustom" {
            navigationController?.delegate = fadeAnimator
        }
        
        // SLIDE
        
        if segue.identifier == "slideSeguePush" {
            navigationController?.delegate = slideAnimator
        }
        
        if segue.identifier == "slideSegueReplace" {
            toViewController.transitioningDelegate = slideAnimator
        }
        
        if segue.identifier == "slideSegueModalDefault" {
            toViewController.transitioningDelegate = slideAnimator
        }
        
        if segue.identifier == "slideSegueModalCustom" {
            // setup presentationController
            var presentedViewFrame = CGRectInset(view.frame, 20, 0)
            presentedViewFrame.origin.x = 0
            let presentingViewTransform = CGAffineTransformMakeTranslation(280, 0)
            
            let presentationController = AEPresentationController(presentedViewController: toViewController, presentingViewController: self)
            presentationController.presentedViewFrame = presentedViewFrame
            presentationController.presentingViewTransform = presentingViewTransform
            presentationController.dimmingViewColor = UIColor.orangeColor().colorWithAlphaComponent(0.5)
            
            slideAnimatorCustom.presentationController = presentationController
            
            // set custom modal presentation style and transitioning delegate
            toViewController.modalPresentationStyle = .Custom
            toViewController.transitioningDelegate = slideAnimatorCustom
        }
        
        if segue.identifier == "slideSeguePopover" {
            toViewController.transitioningDelegate = slideAnimator
        }
        
        if segue.identifier == "slideSegueCustom" {
            navigationController?.delegate = slideAnimator
        }

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

/*
let presentingTransition = AETransitionFade(type: .Presenting, duration: 0.5)
let dismissingTransition = AETransitionFade(type: .Dismissing, duration: 0.5)
let presentationController = AEPresentationController(presentedViewFrame: CGRectZero(), dimmingViewColor: UIColor.redColor())
let transitioningDelegate = AETransitioningDelegate(presentingTransition: presentingTransition, dismissingTransition: dismissingTransition, presentationController: presentationController)

let transition = AETransitionFade()
let transitioningDelegate = AETransitioningDelegate(transition: transition)
*/