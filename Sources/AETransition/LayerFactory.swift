/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2019
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
        public var center: CGPoint?
        private var originalCenter: CGPoint?

        public init(_ transform: CGAffineTransform = .identity, center: CGPoint? = nil) {
            self.transform = transform
            self.center = center
        }
        public func initialState(in context: UIViewControllerContextTransitioning) {
            if let destination = context.destination {
                let initialTransform = destination.transform == .identity ?
                    transform : destination.transform.concatenating(transform)
                destination.transform = initialTransform

                if let center = center {
                    originalCenter = destination.center
                    destination.center = center
                }
            }
        }
        public func finalState(in context: UIViewControllerContextTransitioning) {
            context.destination?.transform = .identity
            if let originalCenter = originalCenter {
                context.destination?.center = originalCenter
            }
        }
    }

    open class SourceTransform: AnimatedTransitionLayer {
        public var transform: CGAffineTransform
        public var center: CGPoint?
        private var originalCenter: CGPoint?

        public init(_ transform: CGAffineTransform = .identity, center: CGPoint? = nil) {
            self.transform = transform
            self.center = center
        }
        public func initialState(in context: UIViewControllerContextTransitioning) {
            context.source?.transform = .identity
            originalCenter = context.source?.center
        }
        public func finalState(in context: UIViewControllerContextTransitioning) {
            if let source = context.source {
                let finalTransform = source.transform == .identity ?
                    transform : source.transform.concatenating(transform)
                source.transform = finalTransform

                if let center = center {
                    source.center = center
                }
            }
        }
        public func cleanup(in context: UIViewControllerContextTransitioning) {
            context.source?.transform = .identity
            if let originalCenter = originalCenter {
                context.source?.center = originalCenter
            }
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

// MARK: - Pop

extension LayerFactory {
    open class DestinationPopOut: DestinationTransform {
        public let from: UIView
        public init(from view: UIView) {
            self.from = view
        }
        public override func initialState(in context: UIViewControllerContextTransitioning) {
            let initialFrame = from.superview?.convert(from.frame, to: nil) ?? .zero
            let finalFrame = context.destination?.frame ?? .zero

            let scaleX = initialFrame.width / finalFrame.width
            let scaleY = initialFrame.height / finalFrame.height
            let scaleTransform = CGAffineTransform(scaleX: scaleX, y: scaleY)

            transform = scaleTransform
            center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)

            super.initialState(in: context)
        }
    }

    open class SourcePopIn: SourceTransform {
        public let to: UIView
        public init(to view: UIView) {
            self.to = view
        }
        public override func finalState(in context: UIViewControllerContextTransitioning) {
            let initialFrame = context.source?.frame ?? .zero
            let finalFrame = to.superview?.convert(to.frame, to: nil) ?? .zero

            let scaleX = finalFrame.width / initialFrame.width
            let scaleY = finalFrame.height / initialFrame.height
            let scaleTransform = CGAffineTransform(scaleX: scaleX, y: scaleY)

            transform = scaleTransform
            center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)

            super.finalState(in: context)
        }
    }
}
