//
//  SourceTableViewController.swift
//  TransitionsPlayground
//
//  Created by Marko Tadic on 11/22/14.
//  Copyright (c) 2014 AE. All rights reserved.
//

import UIKit

class SourceTableViewController: UITableViewController/*, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate*/ {
    
    lazy var fadeAnimator: AETransitioningDelegate = {
        let fadeIn = AETransitionFade(presenting: true)
        let fadeOut = AETransitionFade(presenting: false)
        let transitioningDelegate = AETransitioningDelegate(presentingTransition: fadeIn, dismissingTransition: fadeOut)
        return transitioningDelegate
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = fadeAnimator
    }
    
    @IBAction func unwindToSourceTVC(segue: UIStoryboardSegue) {
        println("unwindToSourceTVC")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fadeSegue" {
            println("fadeSeguePrepare")
            let toViewController = segue.destinationViewController as UINavigationController
//            toViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            
            toViewController.transitioningDelegate = fadeAnimator
        }
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