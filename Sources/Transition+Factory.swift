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
        public init(duration: TimeInterval = 0.5) {
            super.init(duration: duration, layers: [Layer.InsertViewAbove(), Layer.FadeIn()])
        }
    }

    public class FadeOut: LayeredAnimatedTransition {
        public init(duration: TimeInterval = 0.5) {
            super.init(duration: duration, layers: [Layer.InsertViewBelow(), Layer.FadeOut()])
        }
    }
}

// MARK: - Move

public extension Transition {
    public class MoveIn: LayeredAnimatedTransition {
        public init(from edge: Edge = .right, duration: TimeInterval = 0.5) {
            super.init(duration: duration, layers: [Layer.InsertViewAbove(), Layer.MoveIn(from: edge)])
        }
    }

    public class MoveOut: LayeredAnimatedTransition {
        public init(to edge: Edge = .right, duration: TimeInterval = 0.5) {
            super.init(duration: duration, layers: [Layer.InsertViewBelow(), Layer.MoveOut(to: edge)])
        }
    }
}
