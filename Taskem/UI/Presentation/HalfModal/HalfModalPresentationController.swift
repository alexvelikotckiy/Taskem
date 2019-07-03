//
//  HalfModalPresentationController.swift
//  HalfModalPresentationController
//
//  Created by Martin Normark on 17/01/16.
//  Copyright © 2016 martinnormark. All rights reserved.
//

import UIKit

class HalfModalPresentationController: UIPresentationController {
    var isMaximized: Bool = false
    var _dimmingView: UIView?

    var dimmingView: UIView {
        if let dimmedView = _dimmingView {
            self.setDismissTap(on: dimmedView)
            return dimmedView
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: containerView!.bounds.width, height: containerView!.bounds.height))

        let translucentEffect = UIView(frame: view.bounds)
        translucentEffect.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(translucentEffect)

        _dimmingView = view
        self.setDismissTap(on: view)
        return view
    }

    func adjustTo(height: CGFloat, animated: Bool) {
        if let presentedView = presentedView, let containerView = self.containerView {
            if self.isMaximized, !animated {
                return
            }
            
            if presentedView.frame.height == height {
                return
            }
            
            isMaximized = false

            var height = height + 44
            if height > containerView.bounds.height {
                height = containerView.bounds.height
            }

            let frame = CGRect(x: 0, y: containerView.bounds.height - height, width: containerView.bounds.width, height: containerView.bounds.height)
            UIView.animate(
                withDuration: animated ? 1 : 0.0,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.5,
                options: .curveEaseIn,
                animations: {
                    presentedView.frame = frame

                    if let navController = self.presentedViewController as? UINavigationController {
                        navController.setNeedsStatusBarAppearanceUpdate()

                        // Force the navigation bar to update its size
                        navController.isNavigationBarHidden = true
                        navController.isNavigationBarHidden = false
                    }
            }, completion: { _ in
                if !self.presentedViewController.isBeingDismissed {
                    presentedView.frame = CGRect(x: 0, y: containerView.bounds.height - height, width: containerView.bounds.width, height: height)
                }
            })
        }
    }

    func adjustToFullScreen(animated: Bool = true) {
        if isMaximized {
            return
        }
        
        if let presentedView = presentedView, let containerView = self.containerView {
            UIView.animate(
                withDuration: animated ? 1 : 0.0,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.5,
                options: .curveEaseIn,
                animations: {
                    presentedView.frame = containerView.frame

                    if let navController = self.presentedViewController as? UINavigationController {
                        self.isMaximized = true

                        navController.setNeedsStatusBarAppearanceUpdate()

                        // Force the navigation bar to update its size
                        navController.isNavigationBarHidden = true
                        navController.isNavigationBarHidden = false
                    }
            }, completion: nil)
        }
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        return .init(x: 0, y: containerView!.bounds.height / 2, width: containerView!.bounds.width, height: containerView!.bounds.height / 2)
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
            coordinator.animate(alongsideTransition: { (_) -> Void in
                self.dimmingView.alpha = 0
            }, completion: { (_) -> Void in

            })
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)

        if completed {
            dimmingView.removeFromSuperview()
            _dimmingView = nil

            isMaximized = false
        }
    }

    func setDismissTap(on view: UIView) {
        let dismissTap = UITapGestureRecognizer()
        dismissTap.addTarget(self, action: #selector(onDismissTap))
        view.addGestureRecognizer(dismissTap)
        dismissTap.cancelsTouchesInView = false
    }

    @objc func onDismissTap(tap: UITapGestureRecognizer) {
        if tap.state == .ended {
            let location = tap.location(in: nil)

            if let view = self._dimmingView {
                guard view.frame.contains(location) else { return }
                self.presentingViewController.dismiss(animated: true, completion: nil)
            }
        }
    }

}
