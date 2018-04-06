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
        public init(crossfade: Bool = false, options: Options = .standard) {
            var layers: [AnimatedTransitionLayer] = [Layer.InsertDestinationAbove(), Layer.FadeInDestination()]
            if crossfade {
                layers.append(Layer.FadeOutSource())
            }
            super.init(with: layers, options: options)
        }
    }

    open class FadeOut: LayeredAnimatedTransition {
        public init(crossfade: Bool = false, options: Options = .standard) {
            var layers: [AnimatedTransitionLayer] = [Layer.InsertDestinationBelow(), Layer.FadeOutSource()]
            if crossfade {
                layers.append(Layer.FadeInDestination())
            }
            super.init(with: layers, options: options)
        }
    }
}

// MARK: - Move

extension TransitionFactory {
    open class MoveIn: LayeredAnimatedTransition {
        public init(from edge: Edge = .right, push: Bool, options: Options = .standard) {
            var layers: [AnimatedTransitionLayer] = [Layer.InsertDestinationAbove(), Layer.TranslateDestination(from: edge)]
            if push {
                layers.append(Layer.TranslateSource(to: edge.opposite))
            }
            super.init(with: layers, options: options)
        }
    }

    open class MoveOut: LayeredAnimatedTransition {
        public init(to edge: Edge = .right, push: Bool, options: Options = .standard) {
            var layers: [AnimatedTransitionLayer] = [Layer.InsertDestinationBelow(), Layer.TranslateSource(to: edge)]
            if push {
                layers.append(Layer.TranslateDestination(from: edge.opposite))
            }
            super.init(with: layers, options: options)
        }
    }
}
