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
            // setup presented frame and create custom presentation controller
            var presentedFrame = CGRectInset(view.frame, 40, 80)
            fadeAnimator.presentationController = AEPresentationController(presentedViewController: toViewController, presentedViewFrame: presentedFrame, presentingViewController: self)
            
            // set custom modal presentation style and transitioning delegate
            toViewController.modalPresentationStyle = .Custom
            toViewController.transitioningDelegate = fadeAnimator
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
            // setup presented frame
            var presentedFrame = CGRectInset(view.frame, 20, 0)
            presentedFrame.origin.x = 0
            // setup presenting frame
            var presentingFrame = view.frame
            presentingFrame.origin.x = CGRectGetMaxX(presentedFrame)
            
            // create custom presentation controller
//            slideAnimatorCustom.presentationController = AEPresentationController(presentedViewController: toViewController, presentedViewFrame: presentedFrame, presentingViewController: self, presentingViewFrame: presentingFrame)
            
            let pc = AEPresentationController(presentedViewController: toViewController, presentedViewFrame: presentedFrame, presentingViewController: self, presentingViewFrame: presentingFrame)
            let transform = CGAffineTransformMakeTranslation(280, 0)
            pc.presentingViewTransform = transform
            slideAnimatorCustom.presentationController = pc
            
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