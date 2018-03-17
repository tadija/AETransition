/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

public struct Layer {}

// MARK: - Insert View

extension Layer {
    public struct InsertViewAbove: AnimatedTransitionLayer {
        public var preparation: ContextHandler? = { (context) in
            context.insertToViewAboveFromView()
        }
    }

    public struct InsertViewBelow: AnimatedTransitionLayer {
        public var preparation: ContextHandler? = { (context) in
            context.insertToViewBelowFromView()
        }
    }
}

// MARK: - Fade

extension Layer {
    public struct FadeIn: AnimatedTransitionLayer {
        public var preparation: ContextHandler? = { (context) in
            context.toView?.alpha = 0
        }
        public var animation: ContextHandler? = { (context) in
            context.toView?.alpha = 1
        }
    }

    public struct FadeOut: AnimatedTransitionLayer {
        public var animation: ContextHandler? = { (context) in
            context.fromView?.alpha = 0
        }
    }
}

// MARK: - Move

extension Layer {
    open class MoveIn: AnimatedTransitionLayer {
        let edge: Edge
        init(from edge: Edge) {
            self.edge = edge
        }
        public lazy var preparation: ContextHandler? = { [unowned self] (context) in
            context.toView?.translate(to: self.edge)
        }
        public var animation: ContextHandler? = { (context) in
            context.toView?.transform = .identity
        }
    }

    open class MoveOut: AnimatedTransitionLayer {
        let edge: Edge
        init(to edge: Edge) {
            self.edge = edge
        }
        public lazy var animation: ContextHandler? = { [unowned self] (context) in
            context.fromView?.translate(to: self.edge)
        }
    }
}
