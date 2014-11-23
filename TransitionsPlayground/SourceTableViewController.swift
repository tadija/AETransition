//
//  SourceTableViewController.swift
//  TransitionsPlayground
//
//  Created by Marko Tadic on 11/22/14.
//  Copyright (c) 2014 AE. All rights reserved.
//

import UIKit

class SourceTableViewController: UITableViewController {
    
    lazy var fadeAnimator: AETransitioningDelegate = {
        let fadeIn = AETransitionFade(presenting: true)
        let fadeOut = AETransitionFade(presenting: false)
        let transitioningDelegate = AETransitioningDelegate(presentingTransition: fadeIn, dismissingTransition: fadeOut)
        return transitioningDelegate
    }()
    
    @IBAction func unwindToSourceTVC(segue: UIStoryboardSegue) {
        println("unwindToSourceTVC")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toViewController = segue.destinationViewController as UIViewController
        
        if segue.identifier == "fadeSeguePush" {
            navigationController?.delegate = fadeAnimator
        }
        
        if segue.identifier == "fadeSegueReplace" {
            toViewController.transitioningDelegate = fadeAnimator
        }
        
        if segue.identifier == "fadeSegueModal" {
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