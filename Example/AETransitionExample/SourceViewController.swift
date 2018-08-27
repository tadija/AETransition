/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit
import AETransition

final class SourceViewController: UIViewController {

    @IBOutlet weak var label: UILabel!

    var animator: TransitioningDelegate?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let color = UIColor.randomVivid()
        view.backgroundColor = color
        label.backgroundColor = color.darker(withFactor: 0.75).withAlphaComponent(0.75)

        animator = TransitioningDelegate(presentTransition: randomPresenting, dismissTransition: randomDismissing)

        let description = animator?.presentTransition?.debugDescription ?? "?"
        label.text = description
        print(description)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate = animator
    }

    @IBAction func unwindToSourceViewController(_ segue: UIStoryboardSegue) {}

    // MARK: Helpers

    var randomPresenting: AnimatedTransition {
        let index = Int.random(min: 0, max: presentingTransitions.count - 1)
        let random = presentingTransitions[index]
        return random
    }

    var randomDismissing: AnimatedTransition {
        let index = Int.random(min: 0, max: dismissingTransitions.count - 1)
        let random = dismissingTransitions[index]
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
