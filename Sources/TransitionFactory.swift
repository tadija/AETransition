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
            var layers: [AnimatedTransitionLayer] = [Layer.DestinationAbove(), Layer.DestinationAlpha()]
            if crossfade {
                layers.append(Layer.SourceAlpha())
            }
            super.init(with: layers, options: options)
        }
    }

    open class FadeOut: LayeredAnimatedTransition {
        public init(crossfade: Bool = false, options: Options = .standard) {
            var layers: [AnimatedTransitionLayer] = [Layer.DestinationBelow(), Layer.SourceAlpha()]
            if crossfade {
                layers.append(Layer.DestinationAlpha())
            }
            super.init(with: layers, options: options)
        }
    }
}

// MARK: - Translate

extension TransitionFactory {
    open class MoveIn: LayeredAnimatedTransition {
        public init(from edge: Edge = .right, push: Bool, options: Options = .standard) {
            var layers: [AnimatedTransitionLayer] = [Layer.DestinationAbove(), Layer.DestinationMove(from: edge)]
            if push {
                layers.append(Layer.SourceMove(to: edge.opposite))
            }
            super.init(with: layers, options: options)
        }
    }

    open class MoveOut: LayeredAnimatedTransition {
        public init(to edge: Edge = .right, push: Bool, options: Options = .standard) {
            var layers: [AnimatedTransitionLayer] = [Layer.DestinationBelow(), Layer.SourceMove(to: edge)]
            if push {
                layers.append(Layer.DestinationMove(from: edge.opposite))
            }
            super.init(with: layers, options: options)
        }
    }
}

// MARK: - Rotate

extension TransitionFactory {
    open class RotateIn: LayeredAnimatedTransition {
        public init(angle: CGFloat, options: Options = .standard) {
            let rotate = CGAffineTransform(rotationAngle: angle)
            let layers: [AnimatedTransitionLayer] = [Layer.DestinationAbove(), Layer.DestinationTransform(rotate)]
            super.init(with: layers, options: options)
        }
    }

    open class RotateOut: LayeredAnimatedTransition {
        public init(angle: CGFloat, fadeOut: Bool, options: Options = .standard) {
            let rotate = CGAffineTransform(rotationAngle: angle)
            var layers: [AnimatedTransitionLayer] = [Layer.DestinationBelow(), Layer.SourceTransform(rotate)]
            if fadeOut {
                layers.append(Layer.SourceAlpha())
            }
            super.init(with: layers, options: options)
        }
    }
}

// MARK: - Scale

extension TransitionFactory {
    open class ScaleIn: LayeredAnimatedTransition {
        public init(x: CGFloat, y: CGFloat, options: Options = .standard) {
            let scale = CGAffineTransform(scaleX: x, y: y)
            let layers: [AnimatedTransitionLayer] = [Layer.DestinationAbove(), Layer.DestinationTransform(scale)]
            super.init(with: layers, options: options)
        }
    }

    open class ScaleOut: LayeredAnimatedTransition {
        public init(x: CGFloat, y: CGFloat, fadeOut: Bool, options: Options = .standard) {
            let scale = CGAffineTransform(scaleX: x, y: y)
            var layers: [AnimatedTransitionLayer] = [Layer.DestinationBelow(), Layer.SourceTransform(scale)]
            if fadeOut {
                layers.append(Layer.SourceAlpha())
            }
            super.init(with: layers, options: options)
        }
    }
}
