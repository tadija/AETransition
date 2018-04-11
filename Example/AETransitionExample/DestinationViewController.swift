/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit
import AETransition

final class DestinationViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let color = UIColor.randomVivid()
        view.backgroundColor = color
        label.backgroundColor = color.darker(withFactor: 0.75).withAlphaComponent(0.75)

        let description = (transitioningDelegate as? TransitioningDelegate)?.dismissTransition?.debugDescription ?? "?"
        label.text = description
        print(description)
    }

}
