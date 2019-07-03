//
//  ExpandDismissingAnimator.swift
//  ExpandTest
//
//  Created by Wilson on 28.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import UIKit
import TaskemFoundation

class ExpandDismissingAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let originCollapsedFrame: CGRect
    let originExpandedFrame: CGRect

    let fadeOutDuration: TimeInterval = ExpandTransitionConstants.fadeoutAnimationDuration

    weak var presentationController: ExpandPresentationController?

    var transitionContext: UIViewControllerContextTransitioning?
    var snapshotView: UIView?
    var collapseView: UIView?

    init(collapsedViewFrame: CGRect, expandedViewFrame: CGRect) {
        self.originCollapsedFrame = collapsedViewFrame
        self.originExpandedFrame = expandedViewFrame

        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return ExpandTransitionConstants.dismissingDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if transitionContext.isInteractive {
            return
        }

        self.transitionContext = transitionContext
        self.updateTransitionState(state: .start, isInteractive: false)
    }

    func updateTransitionState(state: TransitioningState, isInteractive: Bool) {
        if let transitionContext = self.transitionContext {
            switch state {
            case .none:
                break

            case .start:
                self.startTransition(context: transitionContext, isInteractive: isInteractive)

            case .finish:
                self.finishTransition(context: transitionContext, isInteractive: isInteractive)

            case .update(currentPercentage: let percentage):
                self.updateTransition(context: transitionContext, percentage: percentage, isInteractive: isInteractive)

            case .cancel(lastPercentage: let precentage):
                self.cancelTransition(context: transitionContext, percentage: precentage, isInteractive: isInteractive)

            }
        }
    }

    private func startTransition(context: UIViewControllerContextTransitioning, isInteractive: Bool) {
        let fromViewController = context.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let frontView = fromViewController.view!
        let inView = context.containerView

        let frontViewFrame = frontView.frame
        let snapshotView = frontView.resizableSnapshotView(
            from: frontViewFrame,
            afterScreenUpdates: false,
            withCapInsets: .zero)
        snapshotView?.alpha = 1 // 0.5 for test

        let collapseView = UIView(frame: frontViewFrame)
        collapseView.backgroundColor = AppTheme.current.background
        collapseView.alpha = 0

        if snapshotView != nil {
            inView.addSubview(frontView)
            inView.addSubview(snapshotView!)
            inView.insertSubview(collapseView, aboveSubview: snapshotView!)

            frontView.alpha = 0
            frontView.layoutIfNeeded()

            self.snapshotView = snapshotView
            self.collapseView = collapseView
        }

        if !isInteractive {
            self.finishTransition(context: context, isInteractive: isInteractive)
        }
    }

    private func finishTransition(context: UIViewControllerContextTransitioning, isInteractive: Bool) {
        self.presentationController?.dismissalInteractiveTransitionWillBegin(duration: transitionDuration(using: context))

        self.snapshotView?.alpha = 0
        self.collapseView?.alpha = 1

        if let snapshot = self.snapshotView {
            self.collapseView?.frame = snapshot.frame
        }

        UIView.animate(
            withDuration: transitionDuration(using: context) - self.fadeOutDuration,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseInOut,
            animations: {

                self.collapseView?.frame = self.originCollapsedFrame
                self.collapseView?.layoutIfNeeded()

        }, completion: { _ in

            UIView.animate(
                withDuration: self.fadeOutDuration,
                animations: {

                    self.collapseView?.alpha = 0

            }, completion: { _ in
                self.collapseView?.removeFromSuperview()
                self.snapshotView?.removeFromSuperview()

                if context.transitionWasCancelled {
                    if isInteractive {
                        context.cancelInteractiveTransition()
                    }
                    context.completeTransition(false)

                } else {
                    if isInteractive {
                        context.finishInteractiveTransition()
                    }
                    context.completeTransition(true)
                }
            })

        })
    }

    private func updateTransition(context: UIViewControllerContextTransitioning, percentage: CGFloat, isInteractive: Bool) {
        guard let snapshot = self.snapshotView else { return }
        let verticalOffset = snapshot.frame.maxY / 2 * percentage
        snapshot.frame.origin.y = verticalOffset
        snapshot.layoutIfNeeded()
    }

    private func cancelTransition(context: UIViewControllerContextTransitioning, percentage: CGFloat, isInteractive: Bool) {
        let fromViewController = context.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let frontView = fromViewController.view!

        if let snapshot = self.snapshotView {
            UIView.animate(withDuration: 0.3, animations: {
                snapshot.frame.origin.y = 0
                snapshot.layoutIfNeeded()
            }, completion: { _ in
                self.snapshotView?.removeFromSuperview()
                self.collapseView?.removeFromSuperview()

                frontView.alpha = 1

                context.cancelInteractiveTransition()
                context.completeTransition(false)
            })
        }
    }

}
