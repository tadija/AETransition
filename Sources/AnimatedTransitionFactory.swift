/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit

// MARK: - Layers

public struct InsertViewAboveLayer: AnimatedTransitionLayer {
    public var preparation: AnimatedTransition.ContextHandler? = { (context) in
        context.insertToViewAboveFromView()
    }
}

public struct InsertViewBelowLayer: AnimatedTransitionLayer {
    public var preparation: AnimatedTransition.ContextHandler? = { (context) in
        context.insertToViewBelowFromView()
    }
}

public struct FadeInLayer: AnimatedTransitionLayer {
    public var preparation: AnimatedTransition.ContextHandler? = { (context) in
        context.toView?.alpha = 0
    }
    public var animation: AnimatedTransition.ContextHandler? = { (context) in
        context.toView?.alpha = 1
    }
}

public struct FadeOutLayer: AnimatedTransitionLayer {
    public var animation: AnimatedTransition.ContextHandler? = { (context) in
        context.fromView?.alpha = 0
    }
}

public struct MoveInLayer: AnimatedTransitionLayer {
    public var preparation: AnimatedTransition.ContextHandler? = { (context) in
        let translationX = context.fromView?.bounds.width ?? 0
        context.toView?.transform = CGAffineTransform(translationX: translationX, y: 0)
    }
    public var animation: AnimatedTransition.ContextHandler? = { (context) in
        context.toView?.transform = .identity
    }
}

public struct MoveOutLayer: AnimatedTransitionLayer {
    public var animation: AnimatedTransition.ContextHandler? = { (context) in
        let translationX = context.fromView?.bounds.width ?? 0
        context.fromView?.transform = CGAffineTransform(translationX: translationX, y: 0)
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
    public init(duration: TimeInterval = 0.5) {
        super.init(duration: duration, layers: [InsertViewAboveLayer(), MoveInLayer()])
    }
}

open class MoveOutTransition: LayeredAnimatedTransition {
    public init(duration: TimeInterval = 0.5) {
        super.init(duration: duration, layers: [InsertViewBelowLayer(), MoveOutLayer()])
    }
}
