/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

public struct Transition {}

// MARK: - Fade

public extension Transition {
    public class FadeIn: LayeredAnimatedTransition {
        public init(options: Options = .standard) {
            let layers: [AnimatedTransitionLayer] = [Layer.InsertViewAbove(), Layer.FadeIn()]
            super.init(with: layers, options: options)
        }
    }

    public class FadeOut: LayeredAnimatedTransition {
        public init(options: Options = .standard) {
            let layers: [AnimatedTransitionLayer] = [Layer.InsertViewBelow(), Layer.FadeOut()]
            super.init(with: layers, options: options)
        }
    }
}

// MARK: - Move

public extension Transition {
    public class MoveIn: LayeredAnimatedTransition {
        public init(from edge: Edge = .right, options: Options = .standard) {
            let layers: [AnimatedTransitionLayer] = [Layer.InsertViewAbove(), Layer.MoveIn(from: edge)]
            super.init(with: layers, options: options)
        }
    }

    public class MoveOut: LayeredAnimatedTransition {
        public init(to edge: Edge = .right, options: Options = .standard) {
            let layers: [AnimatedTransitionLayer] = [Layer.InsertViewBelow(), Layer.MoveOut(to: edge)]
            super.init(with: layers, options: options)
        }
    }
}
