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
//        let animator = AEAnimator(transition: AETransitionFade.self)
//        let animator = AEAnimator(transition: AETransitionFadeIn.self)
        
        let animator = AEAnimator(presentTransition: AETransitionFadeIn(), dismissTransition: AETransitionFadeOut())
        
//        let fadeIn = AETransitionFade(presenting: true)
//        let fadeOut = AETransitionFade(presenting: false)
//        let animator = AEAnimator(presentTransition: fadeIn, dismissTransition: fadeOut)
        
        return animator
    }()
    
    lazy var slideAnimator: AEAnimator = {
//        let animator = AEAnimator(transition: AETransitionSlide.self)
        
//        let slideFromTop = AETransitionSlide(presenting: true, duration: 0.5, direction: .Top)
//        let slideToBottom = AETransitionSlide(presenting: false, duration: 0.3, direction: .Bottom)
//        let animator = AEAnimator(presentTransition: slideFromTop, dismissTransition: slideToBottom)
        
        let animator = AEAnimator(presentTransition: AETransitionSlideIn(), dismissTransition: AETransitionSlideOut())
        
        return animator
    }()
    
    lazy var slideAnimatorCustom: AEAnimator = {
//        let slideFromLeft = AETransitionSlide(presenting: true, duration: 0.5, direction: .Left)
//        let slideToLeft = AETransitionSlide(presenting: false, duration: 0.3, direction: .Left)
//        let animator = AEAnimator(presentTransition: slideFromLeft, dismissTransition: slideToLeft)
        
        let animator = AEAnimator(presentTransition: AETransitionSlideIn(fromSide: .left), dismissTransition: AETransitionSlideOut(toSide: .left))
        
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
        present.initialTransform = CGAffineTransform(scaleX: 2.25, y: 2.25)
//        present.initialFrame = CGRect(x: 100, y: 200, width: 100, height: 100)
        
        let dismiss = AETransitionCustom(presenting: false)
        dismiss.animateAlpha = true
        dismiss.initialSide = .bottom
        dismiss.initialTransform = CGAffineTransform(scaleX: 0.01, y: 0.01)
//        dismiss.initialTransform = CGAffineTransformConcat(scale, translate)
//        dismiss.initialTransform = CGAffineTransformMakeScale(0.25, 0.25)
//        dismiss.initialFrame = CGRect(x: 100, y: 200, width: 100, height: 100)
        
        let animator = AEAnimator(presentTransition: present, dismissTransition: dismiss)
        return animator
    }()
    
    @IBAction func unwindToSourceTVC(_ segue: UIStoryboardSegue) {
        print("unwindToSourceTVC")
        if let p = presentedViewController {
            if p.modalPresentationStyle == .custom {
                print("manual dismiss")
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let toViewController = segue.destination as UIViewController
        
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
            let presentedViewFrame = view.frame.insetBy(dx: 40, dy: 80)
//            let presentedViewTransform = CGAffineTransformMakeRotation(0.2)
            
            let presentationController = AEPresentationController(presentedViewController: toViewController, presenting: self)
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
            toViewController.modalPresentationStyle = .custom
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
            var presentedViewFrame = view.frame.insetBy(dx: 20, dy: 0)
            presentedViewFrame.origin.x = 0
            let presentingViewTransform = CGAffineTransform(translationX: 280, y: 0)
            
            let presentationController = AEPresentationController(presentedViewController: toViewController, presenting: self)
            presentationController.presentedViewFrame = presentedViewFrame
            presentationController.presentingViewTransform = presentingViewTransform
            presentationController.dimmingViewColor = UIColor.orange.withAlphaComponent(0.5)
            
            slideAnimatorCustom.presentationController = presentationController
            
            // set custom modal presentation style and transitioning delegate
            toViewController.modalPresentationStyle = .custom
            toViewController.transitioningDelegate = slideAnimatorCustom
        }
        
        if segue.identifier == "slideSeguePopover" {
            toViewController.transitioningDelegate = slideAnimator
        }
        
        if segue.identifier == "slideSegueCustom" {
            navigationController?.delegate = slideAnimator
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
