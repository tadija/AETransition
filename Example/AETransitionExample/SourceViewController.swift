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
        animator = TransitioningDelegate(presentAnimation: randomPresenting, dismissAnimation: randomDismissing)
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
        FadeInTransition(), MoveInTransition(from: Edge.random)
    ]

    let dismissingTransitions: [AnimatedTransition] = [
        FadeOutTransition(), MoveOutTransition(to: Edge.random)
    ]

}

extension Int {
    static func random(min: Int = 0, max: Int = Int.max) -> Int {
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }
}

extension Edge {
    static var random: Edge {
        let index = Int.random(min: 0, max: all.count - 1)
        return all[index]
    }
    static var all: [Edge] = [.left, .right, .top, .bottom]
}
