/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

// MARK: - Layers

public struct InsertViewAboveLayer: AnimatedTransitionLayer {
    public var preparation: ContextHandler? = { (context) in
        context.insertToViewAboveFromView()
    }
}

public struct InsertViewBelowLayer: AnimatedTransitionLayer {
    public var preparation: ContextHandler? = { (context) in
        context.insertToViewBelowFromView()
    }
}

public struct FadeInLayer: AnimatedTransitionLayer {
    public var preparation: ContextHandler? = { (context) in
        context.toView?.alpha = 0
    }
    public var animation: ContextHandler? = { (context) in
        context.toView?.alpha = 1
    }
}

public struct FadeOutLayer: AnimatedTransitionLayer {
    public var animation: ContextHandler? = { (context) in
        context.fromView?.alpha = 0
    }
}

public enum Edge {
    case left, right, top, bottom

    public var opposite: Edge {
        switch self {
        case .left:
            return .right
        case .right:
            return .left
        case .top:
            return .bottom
        case .bottom:
            return .top
        }
    }

    public func translate(_ view: UIView) -> CGAffineTransform {
        switch self {
        case .left:
            return CGAffineTransform(translationX: -view.bounds.width, y: 0)
        case .right:
            return CGAffineTransform(translationX: view.bounds.width, y: 0)
        case .top:
            return CGAffineTransform(translationX: 0, y: -view.bounds.height)
        case .bottom:
            return CGAffineTransform(translationX: 0, y: view.bounds.height)
        }
    }
}

public extension UIView {
    public func translate(to edge: Edge) {
        transform = edge.translate(self)
    }
}

public class MoveInLayer: AnimatedTransitionLayer {
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

public class MoveOutLayer: AnimatedTransitionLayer {
    let edge: Edge
    init(to edge: Edge) {
        self.edge = edge
    }
    public lazy var animation: ContextHandler? = { [unowned self] (context) in
        context.fromView?.translate(to: self.edge)
    }
}

// MARK: - Transitions

open class FadeInTransition: LayeredAnimatedTransition {
    public init(duration: TimeInterval = 0.5) {
        super.init(duration: duration, layers: [InsertViewAboveLayer(), FadeInLayer()])
    }
}

open class FadeOutTransition: LayeredAnimatedTransition {
    public init(duration: TimeInterval = 0.5) {
        super.init(duration: duration, layers: [InsertViewBelowLayer(), FadeOutLayer()])
    }
}

open class MoveInTransition: LayeredAnimatedTransition {
    public init(from edge: Edge = .right, duration: TimeInterval = 0.5) {
        super.init(duration: duration, layers: [InsertViewAboveLayer(), MoveInLayer(from: edge)])
    }
}

open class MoveOutTransition: LayeredAnimatedTransition {
    public init(to edge: Edge = .right, duration: TimeInterval = 0.5) {
        super.init(duration: duration, layers: [InsertViewBelowLayer(), MoveOutLayer(to: edge)])
    }
}
