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
//            let pt = MoveInTransition()
//            let dt = MoveOutTransition()
            let pt = FadeInTransition()
            let dt = FadeOutTransition()
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
