/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit
import AETransition

final class SourceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.randomVivid()
    }

    var animator: TransitioningDelegate?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        animator = TransitioningDelegate(presentTransition: randomPresenting, dismissTransition: randomDismissing)
        segue.destination.transitioningDelegate = animator
    }

    @IBAction func unwindToSourceViewController(_ segue: UIStoryboardSegue) {}

    // MARK: Helpers

    var randomPresenting: AnimatedTransition {
        let index = Int.random(min: 0, max: presentingTransitions.count - 1)
        let random = presentingTransitions[index]
        print(random.debugDescription ?? "")
        return random
    }

    var randomDismissing: AnimatedTransition {
        let index = Int.random(min: 0, max: dismissingTransitions.count - 1)
        let random = dismissingTransitions[index]
        print(random.debugDescription ?? "")
        return random
    }

    var presentingTransitions: [AnimatedTransition] {
        return [
            Transition.FadeIn(crossfade: Bool.random(), options: .random()),
            Transition.TranslateIn(from: .random(), push: Bool.random(), options: .random()),
            Transition.RotateIn(angle: .pi, options: .random()),
            Transition.ScaleIn(x: CGFloat.random(min: 0, max: 2), y: CGFloat.random(min: 0, max: 2), options: .random())
        ]
    }

    var dismissingTransitions: [AnimatedTransition] {
        return [
            Transition.FadeOut(crossfade: Bool.random(), options: .random()),
            Transition.TranslateOut(to: .random(), push: Bool.random(), options: .random()),
            Transition.RotateOut(angle: .pi, fadeOut: Bool.random(), options: .random()),
            Transition.ScaleOut(x: CGFloat.random(min: 0, max: 2), y: CGFloat.random(min: 0, max: 2), fadeOut: Bool.random(), options: .random())
        ]
    }

}
