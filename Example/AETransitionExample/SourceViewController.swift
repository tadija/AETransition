/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit
import AETransition

class SourceViewController: UIViewController {

    var animator: TransitioningDelegate?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        animator = TransitioningDelegate(presentTransition: randomPresenting, dismissTransition: randomDismissing)
        segue.destination.transitioningDelegate = animator
    }

    @IBAction func unwindToSourceViewController(_ segue: UIStoryboardSegue) {}

    var randomPresenting: AnimatedTransition {
        let index = Int.random(min: 0, max: presentingTransitions.count - 1)
        let random = presentingTransitions[index]
        print(random.debugDescription)
        return random
    }

    var randomDismissing: AnimatedTransition {
        let index = Int.random(min: 0, max: dismissingTransitions.count - 1)
        let random = dismissingTransitions[index]
        print(random.debugDescription)
        return random
    }

    let presentingTransitions: [AnimatedTransition] = [
        Transition.FadeIn(options: .random), Transition.MoveIn(from: .random, options: .random)
    ]

    let dismissingTransitions: [AnimatedTransition] = [
        Transition.FadeOut(options: .random), Transition.MoveOut(to: .random, options: .random)
    ]

}

// MARK: - Random

extension Edge {
    static var random: Edge {
        let index = Int.random(min: 0, max: all.count - 1)
        return all[index]
    }
    static var all: [Edge] = [.left, .right, .top, .bottom]
}

extension LayeredAnimatedTransition.Options {
    static var random: LayeredAnimatedTransition.Options {
        return LayeredAnimatedTransition.Options(duration: Double.random(min: 0.3, max: 0.7),
                                                 delay: 0,
                                                 damping: CGFloat.random(min: 0, max: 1),
                                                 velocity: CGFloat.random(min: 0, max: 1),
                                                 animationOptions: .random)
    }
}

extension UIViewAnimationOptions {
    static var random: UIViewAnimationOptions {
        if Bool.random() {
            return .curveEaseIn
        } else {
            return .curveEaseOut
        }
    }
}
