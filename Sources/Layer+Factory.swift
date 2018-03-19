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
        public func prepare(using context: UIViewControllerContextTransitioning) {
            context.insertToViewAboveFromView()
        }
    }

    public struct InsertViewBelow: AnimatedTransitionLayer {
        public func prepare(using context: UIViewControllerContextTransitioning) {
            context.insertToViewBelowFromView()
        }
    }
}

// MARK: - Fade

extension Layer {
    public struct FadeIn: AnimatedTransitionLayer {
        public func prepare(using context: UIViewControllerContextTransitioning) {
            context.toView?.alpha = 0
        }
        public func animate(using context: UIViewControllerContextTransitioning) {
            context.toView?.alpha = 1
        }
    }

    public struct FadeOut: AnimatedTransitionLayer {
        public func animate(using context: UIViewControllerContextTransitioning) {
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
        public func prepare(using context: UIViewControllerContextTransitioning) {
            context.toView?.translate(to: self.edge)
        }
        public func animate(using context: UIViewControllerContextTransitioning) {
            context.toView?.transform = .identity
        }
    }

    open class MoveOut: AnimatedTransitionLayer {
        let edge: Edge
        init(to edge: Edge) {
            self.edge = edge
        }
        public func animate(using context: UIViewControllerContextTransitioning) {
            context.fromView?.translate(to: self.edge)
        }
    }
}
