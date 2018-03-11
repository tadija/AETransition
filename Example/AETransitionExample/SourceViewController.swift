/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit
import AETransition

class SourceViewController: UIViewController {

    var animator: TransitioningDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        animator = {
            let pt = FadeTransition(type: .presenting, duration: 0.5)
            let dt = FadeTransition(type: .dismissing, duration: 0.5)
            let td = TransitioningDelegate(presentAnimation: pt, dismissAnimation: dt)
            return td
        }()
    }

    @IBAction func unwindToSourceViewController(_ segue: UIStoryboardSegue) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate = animator
    }

}
