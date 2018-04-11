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
            let layers: [AnimatedTransitionLayer] = [Layer.DestinationAbove(), Layer.DestinationAlpha()]
            super.init(with: layers, options: options)
        }
    }

    open class FadeOut: LayeredAnimatedTransition {
        public init(options: Options = .standard) {
            let layers: [AnimatedTransitionLayer] = [Layer.DestinationBelow(), Layer.SourceAlpha()]
            super.init(with: layers, options: options)
        }
    }
}

// MARK: - Crossfade

extension TransitionFactory {
    open class CrossfadeIn: FadeIn {
        public override init(options: Options) {
            super.init(options: options)
            layers.append(Layer.SourceAlpha())
        }
    }

    open class CrossfadeOut: FadeOut {
        public override init(options: Options) {
            super.init(options: options)
            layers.append(Layer.DestinationAlpha())
        }
    }
}

// MARK: - Move

extension TransitionFactory {
    open class MoveIn: LayeredAnimatedTransition {
        public init(from edge: Edge = .right, options: Options = .standard) {
            let layers: [AnimatedTransitionLayer] = [Layer.DestinationAbove(), Layer.DestinationMove(from: edge)]
            super.init(with: layers, options: options)
        }
    }

    open class MoveOut: LayeredAnimatedTransition {
        public init(to edge: Edge = .right, options: Options = .standard) {
            let layers: [AnimatedTransitionLayer] = [Layer.DestinationBelow(), Layer.SourceMove(to: edge)]
            super.init(with: layers, options: options)
        }
    }
}

// MARK: - Push

extension TransitionFactory {
    open class PushIn: MoveIn {
        public override init(from edge: Edge = .right, options: Options = .standard) {
            super.init(from: edge, options: options)
            layers.append(Layer.SourceMove(to: edge.opposite))
        }
    }

    open class PushOut: MoveOut {
        public override init(to edge: Edge = .right, options: Options = .standard) {
            super.init(to: edge, options: options)
            layers.append(Layer.DestinationMove(from: edge.opposite))
        }
    }
}

// MARK: - Transform

extension TransitionFactory {
    open class TransformIn: LayeredAnimatedTransition {
        public init(transform: CGAffineTransform, fade: Bool = true, options: Options = .standard) {
            var layers: [AnimatedTransitionLayer] = [Layer.DestinationAbove(), Layer.DestinationTransform(transform)]
            if fade {
                layers.append(Layer.DestinationAlpha())
            }
            super.init(with: layers, options: options)
        }
    }

    open class TransformOut: LayeredAnimatedTransition {
        public init(transform: CGAffineTransform, fade: Bool = true, options: Options = .standard) {
            var layers: [AnimatedTransitionLayer] = [Layer.DestinationBelow(), Layer.SourceTransform(transform)]
            if fade {
                layers.append(Layer.SourceAlpha())
            }
            super.init(with: layers, options: options)
        }
    }
}

// MARK: - Basic

extension TransitionFactory {
    open class BasicIn: LayeredAnimatedTransition {
        public init(fade: Bool = true,
                    crossfade: Bool = false,
                    moveFrom: Edge? = nil,
                    pushTo: Edge? = nil,
                    transform: CGAffineTransform? = nil,
                    options: Options = .standard) {
            var layers: [AnimatedTransitionLayer] = [Layer.DestinationAbove()]
            if fade {
                layers.append(Layer.DestinationAlpha())
            }
            if crossfade {
                layers.append(Layer.SourceAlpha())
            }
            if let moveEdge = moveFrom {
                layers.append(Layer.DestinationMove(from: moveEdge))
            }
            if let pushEdge = pushTo {
                layers.append(Layer.SourceMove(to: pushEdge))
            }
            if let transform = transform {
                layers.append(Layer.DestinationTransform(transform))
            }
            super.init(with: layers, options: options)
        }
    }

    open class BasicOut: LayeredAnimatedTransition {
        public init(fade: Bool = true,
                    crossfade: Bool = false,
                    moveTo: Edge? = nil,
                    pushFrom: Edge? = nil,
                    transform: CGAffineTransform? = nil,
                    options: Options = .standard) {
            var layers: [AnimatedTransitionLayer] = [Layer.DestinationBelow()]
            if fade {
                layers.append(Layer.SourceAlpha())
            }
            if crossfade {
                layers.append(Layer.DestinationAlpha())
            }
            if let moveEdge = moveTo {
                layers.append(Layer.SourceMove(to: moveEdge))
            }
            if let pushEdge = pushFrom {
                layers.append(Layer.DestinationMove(from: pushEdge))
            }
            if let transform = transform {
                layers.append(Layer.SourceTransform(transform))
            }
            super.init(with: layers, options: options)
        }
    }
}
