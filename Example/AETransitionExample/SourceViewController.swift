/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2019
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit
import AETransition

final class SourceViewController: UIViewController {

    @IBOutlet weak var label: UILabel!

    var randomAnimator: TransitioningDelegate?

    var popAnimator: TransitioningDelegate?
    let popView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        popView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(popOut(_:))))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSelf()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updatePopView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "random" {
            segue.destination.transitioningDelegate = randomAnimator
        }
    }

    @IBAction func unwindToSourceViewController(_ segue: UIStoryboardSegue) {}

    @objc
    func popOut(_ sender: UITapGestureRecognizer) {
        let vc = PopOutViewController()
        vc.color = popView.backgroundColor
        vc.transitioningDelegate = popAnimator
        present(vc, animated: true, completion: nil)
    }

    // MARK: Helpers

    private func updateSelf() {
        let color = UIColor.randomVivid()
        view.backgroundColor = color
        label.backgroundColor = color.darker(withFactor: 0.75).withAlphaComponent(0.75)

        randomAnimator = TransitioningDelegate(presentTransition: randomPresenting, dismissTransition: randomDismissing)

        let description = randomAnimator?.presentTransition?.debugDescription ?? "?"
        label.text = description
        print(description)
    }

    private func updatePopView() {
        popView.removeFromSuperview()
        popView.backgroundColor = UIColor.randomVivid()
        popView.frame = CGRect(x: .random(in: 20...view.bounds.width / 2),
                               y: .random(in: 20...view.bounds.height / 2),
                               width: .random(in: 44...view.bounds.width / 3),
                               height: .random(in: 44...view.bounds.height / 4))
        view.insertSubview(popView, at: 0)
        let popOut = Transition.PopOut(from: popView)
        let popIn = Transition.PopIn(to: popView)
        popAnimator = TransitioningDelegate(presentTransition: popOut, dismissTransition: popIn)
    }

    var randomPresenting: AnimatedTransition {
        let index = Int.random(in: 0...presentingTransitions.count - 1)
        let random = presentingTransitions[index]
        return random
    }

    var randomDismissing: AnimatedTransition {
        let index = Int.random(in: 0...dismissingTransitions.count - 1)
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

final class PopOutViewController: UIViewController {
    var color: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didRecognizeTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc
    func didRecognizeTapGesture(_ sender: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
