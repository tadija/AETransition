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
    public struct DestinationAbove: AnimatedTransitionLayer {
        public init() {}
        public func initialState(in context: UIViewControllerContextTransitioning) {
            if let source = context.source, let destination = context.destination {
                context.containerView.insertSubview(destination, aboveSubview: source)
            }
        }
    }

    public struct DestinationBelow: AnimatedTransitionLayer {
        public init() {}
        public func initialState(in context: UIViewControllerContextTransitioning) {
            if let source = context.source, let destination = context.destination {
                context.containerView.insertSubview(destination, belowSubview: source)
            }
        }
    }
}

// MARK: - Alpha

extension LayerFactory {
    public struct DestinationAlpha: AnimatedTransitionLayer {
        public let from: CGFloat
        public let to: CGFloat
        public init(from: CGFloat = 0, to: CGFloat = 1) {
            self.from = from
            self.to = to
        }
        public func initialState(in context: UIViewControllerContextTransitioning) {
            context.destination?.alpha = from
        }
        public func finalState(in context: UIViewControllerContextTransitioning) {
            context.destination?.alpha = to
        }
    }

    public struct SourceAlpha: AnimatedTransitionLayer {
        public let from: CGFloat
        public let to: CGFloat
        public init(from: CGFloat = 1, to: CGFloat = 0) {
            self.from = from
            self.to = to
        }
        public func initialState(in context: UIViewControllerContextTransitioning) {
            context.source?.alpha = from
        }
        public func finalState(in context: UIViewControllerContextTransitioning) {
            context.source?.alpha = to
        }
        public func cleanup(in context: UIViewControllerContextTransitioning) {
            context.source?.alpha = 1
        }
    }
}

// MARK: - Transform

extension LayerFactory {
    open class DestinationTransform: AnimatedTransitionLayer {
        public var transform: CGAffineTransform
        public init(_ transform: CGAffineTransform = .identity) {
            self.transform = transform
        }
        public func initialState(in context: UIViewControllerContextTransitioning) {
            if let destinationTransform = context.destination?.transform {
                let t = destinationTransform == .identity ? transform : destinationTransform.concatenating(transform)
                context.destination?.transform = t
            }
        }
        public func finalState(in context: UIViewControllerContextTransitioning) {
            context.destination?.transform = .identity
        }
    }

    open class SourceTransform: AnimatedTransitionLayer {
        public var transform: CGAffineTransform
        public init(_ transform: CGAffineTransform = .identity) {
            self.transform = transform
        }
        public func initialState(in context: UIViewControllerContextTransitioning) {
            context.source?.transform = .identity
        }
        public func finalState(in context: UIViewControllerContextTransitioning) {
            if let sourceTransform = context.source?.transform {
                let t = sourceTransform == .identity ? transform : sourceTransform.concatenating(transform)
                context.source?.transform = t
            }
        }
        public func cleanup(in context: UIViewControllerContextTransitioning) {
            context.source?.transform = .identity
        }
    }
}

// MARK: - Slide

extension LayerFactory {
    open class DestinationSlide: DestinationTransform {
        public let from: Edge
        public init(from edge: Edge) {
            self.from = edge
        }
        public override func initialState(in context: UIViewControllerContextTransitioning) {
            transform = Edge.translation(for: context.destination, to: from)
            super.initialState(in: context)
        }
    }

    open class SourceSlide: SourceTransform {
        public let to: Edge
        public init(to edge: Edge) {
            self.to = edge
        }
        public override func finalState(in context: UIViewControllerContextTransitioning) {
            transform = Edge.translation(for: context.source, to: to)
            super.finalState(in: context)
        }
    }
}
