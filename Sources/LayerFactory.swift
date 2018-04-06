/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

public typealias Layer = LayerFactory

public struct LayerFactory {}

// MARK: - Hierarchy

extension LayerFactory {
    public struct InsertDestinationAbove: AnimatedTransitionLayer {
        public func initialState(in context: UIViewControllerContextTransitioning) {
            context.insertToViewAboveFromView()
        }
    }

    public struct InsertDestinationBelow: AnimatedTransitionLayer {
        public func initialState(in context: UIViewControllerContextTransitioning) {
            context.insertToViewBelowFromView()
        }
    }
}

// MARK: - Alpha

extension LayerFactory {
    public struct FadeInDestination: AnimatedTransitionLayer {
        public func initialState(in context: UIViewControllerContextTransitioning) {
            context.toView?.alpha = 0
        }
        public func finalState(in context: UIViewControllerContextTransitioning) {
            context.toView?.alpha = 1
        }
    }

    public struct FadeOutSource: AnimatedTransitionLayer {
        public func initialState(in context: UIViewControllerContextTransitioning) {
            context.fromView?.alpha = 1
        }
        public func finalState(in context: UIViewControllerContextTransitioning) {
            context.fromView?.alpha = 0
        }
        public func finish(in context: UIViewControllerContextTransitioning) {
            context.fromView?.alpha = 1
        }
    }
}

// MARK: - Transform

extension LayerFactory {
    open class TransformDestination: AnimatedTransitionLayer {
        public var transform: CGAffineTransform = .identity
        public func initialState(in context: UIViewControllerContextTransitioning) {
            context.toView?.transform = transform
        }
        public func finalState(in context: UIViewControllerContextTransitioning) {
            context.toView?.transform = .identity
        }
    }

    open class TransformSource: AnimatedTransitionLayer {
        public var transform: CGAffineTransform = .identity
        public func initialState(in context: UIViewControllerContextTransitioning) {
            context.fromView?.transform = .identity
        }
        public func finalState(in context: UIViewControllerContextTransitioning) {
            context.fromView?.transform = transform
        }
        public func finish(in context: UIViewControllerContextTransitioning) {
            context.fromView?.transform = .identity
        }
    }
}

// MARK: - Translate

extension LayerFactory {
    open class TranslateDestination: TransformDestination {
        public let edge: Edge
        public init(from edge: Edge) {
            self.edge = edge
        }
        public override func initialState(in context: UIViewControllerContextTransitioning) {
            transform = Edge.translation(for: context.toView, to: edge)
            super.initialState(in: context)
        }
    }

    open class TranslateSource: TransformSource {
        public let edge: Edge
        public init(to edge: Edge) {
            self.edge = edge
        }
        public override func finalState(in context: UIViewControllerContextTransitioning) {
            transform = Edge.translation(for: context.fromView, to: edge)
            super.finalState(in: context)
        }
    }
}
