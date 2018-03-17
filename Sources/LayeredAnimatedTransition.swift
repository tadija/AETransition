/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

public protocol AnimatedTransitionLayer {
    var preparation: ContextHandler? { get }
    var animation: ContextHandler? { get }
}

public extension AnimatedTransitionLayer {
    public var preparation: ContextHandler? {
        return nil
    }
    public var animation: ContextHandler? {
        return nil
    }

    public var debugDescription: String {
        return String(describing: type(of: self))
    }
}

open class LayeredAnimatedTransition: AnimatedTransition {

    // MARK: Properties

    open let layers: [AnimatedTransitionLayer]

    open var completion: ContextHandler? = { (context) in
        context.completeTransition(!context.transitionWasCancelled)
    }

    open override var debugDescription: String {
        return "\(String(describing: type(of: self))) | Layers: \(layers.map{ $0.debugDescription })"
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
