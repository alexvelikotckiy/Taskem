//
//  ExpandPresentationController.swift
//  ExpandTest
//
//  Created by Wilson on 27.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import UIKit

class ExpandPresentationController: UIPresentationController {

    private var _dimmingView: UIView?

    private var dimmingView: UIView {
        if let dimmedView = _dimmingView {
            return dimmedView
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: containerView!.bounds.width, height: containerView!.bounds.height))

        let translucentEffect = UIView(frame: view.bounds)
        translucentEffect.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(translucentEffect)

        _dimmingView = view
        return view
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: containerView!.bounds.height, width: containerView!.bounds.width, height: containerView!.bounds.height)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        let dimmedView = dimmingView
        if let containerView = self.containerView, let coordinator = presentingViewController.transitionCoordinator {

            dimmedView.alpha = 0
            containerView.addSubview(dimmedView)
            dimmedView.addSubview(presentedViewController.view)

            coordinator.animate(alongsideTransition: { (_) -> Void in
                dimmedView.alpha = 1
            }, completion: nil)
        }
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        if let coordinator = presentingViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { context -> Void in
                if !context.isInteractive {
                    self.dimmingView.alpha = 0
                }
            }, completion: { _ -> Void in

            })
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)

        if completed {
            dimmingView.removeFromSuperview()
            _dimmingView = nil
        }
    }

    func dismissalInteractiveTransitionWillBegin(duration: TimeInterval) {
        if presentingViewController.transitionCoordinator != nil {
            UIView.animate(withDuration: duration) {
                self.dimmingView.alpha = 0
            }
        }
    }

}
