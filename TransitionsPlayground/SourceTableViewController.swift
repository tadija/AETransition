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
//        let fadeIn = AETransitionFade(presenting: true)
//        let fadeOut = AETransitionFade(presenting: false)
//        let animator = AEAnimator(presentTransition: fadeIn, dismissTransition: fadeOut)
        let animator = AEAnimator(transition: AETransitionFade.self)
        return animator
    }()
    
    lazy var slideAnimator: AEAnimator = {
//        let animator = AEAnimator(transition: AETransitionSlide.self)
        
        let slideFromTop = AETransitionSlide(presenting: true, duration: 0.5, direction: .Top)
        let slideToBottom = AETransitionSlide(presenting: false, duration: 0.3, direction: .Bottom)
        let animator = AEAnimator(presentTransition: slideFromTop, dismissTransition: slideToBottom)
        
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
            fadeAnimator.presentationController = AEPresentationController(presentedViewController: toViewController, presentingViewController: self, presentedViewFrame: CGRectMake(60, 84, 200, 400))
            toViewController.transitioningDelegate = fadeAnimator
        }
        
        if segue.identifier == "fadeSegueModalCustom" {
            fadeAnimator.presentationController = AEPresentationController(presentedViewController: toViewController, presentingViewController: self, presentedViewFrame: CGRectMake(60, 84, 200, 400))
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
            slideAnimator.presentationController = AEPresentationController(presentedViewController: toViewController, presentingViewController: self, presentedViewFrame: CGRectMake(60, 84, 200, 400))
            toViewController.transitioningDelegate = slideAnimator
        }
        
        if segue.identifier == "slideSegueModalCustom" {
            slideAnimator.presentationController = AEPresentationController(presentedViewController: toViewController, presentingViewController: self, presentedViewFrame: CGRectMake(60, 84, 200, 400))
            toViewController.modalPresentationStyle = .Custom
            toViewController.transitioningDelegate = slideAnimator
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