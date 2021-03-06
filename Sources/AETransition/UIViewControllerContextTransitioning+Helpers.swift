/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2019
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

public extension UIViewControllerContextTransitioning {

    // MARK: Properties

    var source: UIView? {
        return view(forKey: .from)
    }
    var destination: UIView? {
        return view(forKey: .to)
    }

    func resetDestinationFrame() {
        destination?.frame = source?.frame ?? .zero
    }

}
