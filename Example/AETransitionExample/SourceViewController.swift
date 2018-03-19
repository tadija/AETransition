/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit
import AETransition

final class SourceViewController: UIViewController {

    var animator: TransitioningDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.randomVivid()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        animator = TransitioningDelegate(presentTransition: randomPresenting, dismissTransition: randomDismissing)
        segue.destination.transitioningDelegate = animator
        segue.destination.view.backgroundColor = UIColor.randomVivid()
    }

    @IBAction func unwindToSourceViewController(_ segue: UIStoryboardSegue) {}

    // MARK: Helpers

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
        Transition.FadeIn(options: .random()), Transition.MoveIn(from: .random(), options: .random())
    ]

    let dismissingTransitions: [AnimatedTransition] = [
        Transition.FadeOut(options: .random()), Transition.MoveOut(to: .random(), options: .random())
    ]

}
