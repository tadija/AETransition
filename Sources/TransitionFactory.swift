/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

public typealias Transition = TransitionFactory

public struct TransitionFactory {}

// MARK: - Fade

extension TransitionFactory {
    open class FadeIn: LayeredAnimatedTransition {
        public init(options: Options = .standard) {
            let layers: [AnimatedTransitionLayer] = [Layer.InsertDestinationAbove(), Layer.FadeInDestination()]
            super.init(with: layers, options: options)
        }
    }

    open class FadeOut: LayeredAnimatedTransition {
        public init(options: Options = .standard) {
            let layers: [AnimatedTransitionLayer] = [Layer.InsertDestinationBelow(), Layer.FadeOutSource()]
            super.init(with: layers, options: options)
        }
    }
}

// MARK: - Move

extension TransitionFactory {
    open class MoveIn: LayeredAnimatedTransition {
        public init(from edge: Edge = .right, options: Options = .standard) {
            let layers: [AnimatedTransitionLayer] = [Layer.InsertDestinationAbove(), Layer.TranslateDestination(from: edge)]
            super.init(with: layers, options: options)
        }
    }

    open class MoveOut: LayeredAnimatedTransition {
        public init(to edge: Edge = .right, options: Options = .standard) {
            let layers: [AnimatedTransitionLayer] = [Layer.InsertDestinationBelow(), Layer.TranslateSource(to: edge)]
            super.init(with: layers, options: options)
        }
    }
}
