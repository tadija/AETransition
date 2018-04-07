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
            if let source = context.source, let destination = context.destination {
                context.containerView.insertSubview(destination, aboveSubview: source)
            }
        }
    }

    public struct InsertDestinationBelow: AnimatedTransitionLayer {
        public func initialState(in context: UIViewControllerContextTransitioning) {
            if let source = context.source, let destination = context.destination {
                context.containerView.insertSubview(destination, belowSubview: source)
            }
        }
    }
}

// MARK: - Alpha

extension LayerFactory {
    public struct FadeInDestination: AnimatedTransitionLayer {
        public func initialState(in context: UIViewControllerContextTransitioning) {
            context.destination?.alpha = 0
        }
        public func finalState(in context: UIViewControllerContextTransitioning) {
            context.destination?.alpha = 1
        }
    }

    public struct FadeOutSource: AnimatedTransitionLayer {
        public func initialState(in context: UIViewControllerContextTransitioning) {
            context.source?.alpha = 1
        }
        public func finalState(in context: UIViewControllerContextTransitioning) {
            context.source?.alpha = 0
        }
        public func cleanup(in context: UIViewControllerContextTransitioning) {
            context.source?.alpha = 1
        }
    }
}

// MARK: - Transform

extension LayerFactory {
    open class TransformDestination: AnimatedTransitionLayer {
        public var transform: CGAffineTransform
        public init(_ transform: CGAffineTransform = .identity) {
            self.transform = transform
        }
        public func initialState(in context: UIViewControllerContextTransitioning) {
            context.destination?.transform = transform
        }
        public func finalState(in context: UIViewControllerContextTransitioning) {
            context.destination?.transform = .identity
        }
    }

    open class TransformSource: AnimatedTransitionLayer {
        public var transform: CGAffineTransform
        public init(_ transform: CGAffineTransform = .identity) {
            self.transform = transform
        }
        public func initialState(in context: UIViewControllerContextTransitioning) {
            context.source?.transform = .identity
        }
        public func finalState(in context: UIViewControllerContextTransitioning) {
            context.source?.transform = transform
        }
        public func cleanup(in context: UIViewControllerContextTransitioning) {
            context.source?.transform = .identity
        }
    }
}

// MARK: - Move

extension LayerFactory {
    open class MoveDestination: TransformDestination {
        public let edge: Edge
        public init(from edge: Edge) {
            self.edge = edge
        }
        public override func initialState(in context: UIViewControllerContextTransitioning) {
            transform = Edge.translation(for: context.destination, to: edge)
            super.initialState(in: context)
        }
    }

    open class MoveSource: TransformSource {
        public let edge: Edge
        public init(to edge: Edge) {
            self.edge = edge
        }
        public override func finalState(in context: UIViewControllerContextTransitioning) {
            transform = Edge.translation(for: context.source, to: edge)
            super.finalState(in: context)
        }
    }
}
