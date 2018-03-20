/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

public struct Layer {}

// MARK: - Hierarchy

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

// MARK: - Alpha

extension Layer {
    public struct AlphaIn: AnimatedTransitionLayer {
        public func prepare(using context: UIViewControllerContextTransitioning) {
            context.toView?.alpha = 0
        }
        public func animate(using context: UIViewControllerContextTransitioning) {
            context.toView?.alpha = 1
        }
    }

    public struct AlphaOut: AnimatedTransitionLayer {
        public func animate(using context: UIViewControllerContextTransitioning) {
            context.fromView?.alpha = 0
        }
    }
}

// MARK: - Transform

extension Layer {
    open class TransformIn: AnimatedTransitionLayer {
        public var transform: CGAffineTransform = .identity
        public func prepare(using context: UIViewControllerContextTransitioning) {
            context.toView?.transform = transform
        }
        public func animate(using context: UIViewControllerContextTransitioning) {
            context.toView?.transform = .identity
        }
    }

    open class TransformOut: AnimatedTransitionLayer {
        public var transform: CGAffineTransform = .identity
        public func animate(using context: UIViewControllerContextTransitioning) {
            context.fromView?.transform = transform
        }
    }
}

// MARK: - Translate

extension Layer {
    open class TranslateIn: TransformIn {
        public let edge: Edge
        public init(from edge: Edge) {
            self.edge = edge
        }
        public override func prepare(using context: UIViewControllerContextTransitioning) {
            transform = Edge.makeTransform(translating: context.toView, to: edge)
            super.prepare(using: context)
        }
    }

    open class TranslateOut: TransformOut {
        public let edge: Edge
        public init(to edge: Edge) {
            self.edge = edge
        }
        public override func animate(using context: UIViewControllerContextTransitioning) {
            transform = Edge.makeTransform(translating: context.fromView, to: edge)
            super.animate(using: context)
        }
    }
}
