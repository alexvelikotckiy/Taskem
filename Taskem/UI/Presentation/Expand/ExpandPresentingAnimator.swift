//
//  ExpandPresentingAnimator.swift
//  ExpandTest
//
//  Created by Wilson on 28.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import UIKit
import TaskemFoundation

class ExpandPresentingAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let originCollapsedFrame: CGRect
    let originExpandedFrame: CGRect

    let fadeOutDuration: TimeInterval = ExpandTransitionConstants.fadeoutAnimationDuration

    init(collapsedViewFrame: CGRect, expandedViewFrame: CGRect) {
        self.originCollapsedFrame = collapsedViewFrame
        self.originExpandedFrame = expandedViewFrame

        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return ExpandTransitionConstants.presentingDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let frontView = toViewController.view!
        let inView = transitionContext.containerView

        let expandingView = UIView(frame: self.originCollapsedFrame)
        expandingView.backgroundColor = AppTheme.current.background

        frontView.alpha = 0

        inView.addSubview(frontView)
        inView.addSubview(expandingView)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext) - self.fadeOutDuration,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseInOut,
            animations: {

                expandingView.frame = self.originExpandedFrame
                expandingView.layoutIfNeeded()
                inView.layoutIfNeeded()

        }, completion: { _ in
//            if let navController = toViewController as? ExpandNavController {
//                let isToolbarHidden = navController.isToolbarHidden
//                navController.setToolbarHidden(false, animated: false)
//                navController.setToolbarHidden(true, animated: false)
//                navController.setToolbarHidden(isToolbarHidden, animated: false)
//                navController.view.layoutSubviews()
//            }
            frontView.alpha = 1

            UIView.animate(
                withDuration: self.fadeOutDuration,
                animations: {

                expandingView.alpha = 0

            }, completion: { _ in
                expandingView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        })

    }

}
