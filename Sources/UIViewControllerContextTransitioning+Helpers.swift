/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

public extension UIViewControllerContextTransitioning {

    // MARK: Properties

    var fromView: UIView? {
        return view(forKey: .from)
    }
    var toView: UIView? {
        return view(forKey: .to)
    }

    // MARK: API

    func insertToViewAboveFromView() {
        if let fromView = fromView, let toView = toView {
            containerView.insertSubview(toView, aboveSubview: fromView)
        }
    }

    func insertToViewBelowFromView() {
        if let fromView = fromView, let toView = toView {
            containerView.insertSubview(toView, belowSubview: fromView)
        }
    }

}
