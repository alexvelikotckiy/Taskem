//
//  HalfModalTransitionAnimator.swift
//  HalfModalPresentationController
//
//  Created by Martin Normark on 29/01/16.
//  Copyright © 2016 martinnormark. All rights reserved.
//

import UIKit

class HalfModalTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var type: HalfModalTransitionAnimatorType

    init(type: HalfModalTransitionAnimatorType) {
        self.type = type
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) != nil,
            let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
        }

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                let screenHeight = UIScreen.main.bounds.height
                from.view.frame.origin.y = screenHeight
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
}

internal enum HalfModalTransitionAnimatorType {
    case present
    case dismiss
}
