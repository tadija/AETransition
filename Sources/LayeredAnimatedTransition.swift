/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

open class LayeredAnimatedTransition: AnimatedTransition {

    // MARK: Properties

    open let layers: [AnimatedTransitionLayer]

    open var completion: ContextHandler? = { (context) in
        context.completeTransition(!context.transitionWasCancelled)
    }

    open override var debugDescription: String {
        return "\(type(of: self)) | Layers: \(layers.map{ "\(type(of: $0))".split{$0 == "."}.last ?? "" })"
    }

    // MARK: Init

    public init(duration: TimeInterval, layers: [AnimatedTransitionLayer]) {
        self.layers = layers
        super.init(duration: duration)
        configureTransitionAnimation(duration: duration, layers: layers)
    }

    // MARK: Helpers

    private func configureTransitionAnimation(duration: TimeInterval, layers: [AnimatedTransitionLayer]) {
        transitionAnimation = { [weak self] (context) in
            layers.forEach({ $0.preparation?(context) })
            UIView.animate(withDuration: duration, animations: {
                layers.forEach({ $0.animation?(context) })
            }, completion: { (finished) in
                self?.completion?(context)
            })
        }
    }

}