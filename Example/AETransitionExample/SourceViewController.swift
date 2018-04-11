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
            Transition.FadeIn(options: .random()),
            Transition.CrossfadeIn(options: .random()),
            Transition.SlideIn(from: .random(), options: .random()),
            Transition.PushIn(from: .random(), options: .random()),
            Transition.TransformIn(transform: .random(), options: .random()),
            Transition.BasicIn(crossfade: .random(), slideFrom: .random(), pushTo: .random(), transform: .random(), options: .random()),
        ]
    }

    var dismissingTransitions: [AnimatedTransition] {
        return [
            Transition.FadeOut(options: .random()),
            Transition.CrossfadeOut(options: .random()),
            Transition.SlideOut(to: .random(), options: .random()),
            Transition.PushOut(to: .random(), options: .random()),
            Transition.TransformOut(transform: .random(), options: .random()),
            Transition.BasicOut(crossfade: .random(), slideTo: .random(), pushFrom: .random(), transform: .random(), options: .random()),
        ]
    }

}
