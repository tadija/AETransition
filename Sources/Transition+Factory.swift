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
            super.init(duration: duration, layers: [InsertViewAboveLayer(), FadeInLayer()])
        }
    }

    public class FadeOut: LayeredAnimatedTransition {
        public init(duration: TimeInterval = 0.5) {
            super.init(duration: duration, layers: [InsertViewBelowLayer(), FadeOutLayer()])
        }
    }
}

// MARK: - Move

public extension Transition {
    public class MoveIn: LayeredAnimatedTransition {
        public init(from edge: Edge = .right, duration: TimeInterval = 0.5) {
            super.init(duration: duration, layers: [InsertViewAboveLayer(), MoveInLayer(from: edge)])
        }
    }

    public class MoveOut: LayeredAnimatedTransition {
        public init(to edge: Edge = .right, duration: TimeInterval = 0.5) {
            super.init(duration: duration, layers: [InsertViewBelowLayer(), MoveOutLayer(to: edge)])
        }
    }
}
