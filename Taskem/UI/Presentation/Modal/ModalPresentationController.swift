//
//  ExpandPresentationController.swift
//  ExpandTest
//
//  Created by Wilson on 27.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import UIKit
import TaskemFoundation

class ModalPresentationController: UIPresentationController {

    private var _dimmingView: UIView?

    private var defaultWidth: CGFloat {
        let bounds = containerView!.bounds
        return bounds.width - bounds.width / 10
    }

    private var defaultHeight: CGFloat {
        let bounds = containerView!.bounds
        return bounds.height - bounds.height / 2
    }

    private var dimmingView: UIView {
        if let dimmedView = _dimmingView {
            self.setupDismissTap(on: dimmedView)
            return dimmedView
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: containerView!.bounds.width, height: containerView!.bounds.height))
        
        let blurEffect = UIBlurEffect(style:  AppTheme.current == .light ? .light : .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        _dimmingView = view
        self.setupDismissTap(on: view)
        return view
    }

    func adjustTo(size: CGSize, animated: Bool) {
        if let presentedView = presentedView, let containerView = containerView {
            var newSize = size
            let bounds = containerView.bounds
            let actualFrame = presentedView.frame

            if size.width > bounds.width {
                newSize.width = bounds.width
            }

            if size.height > bounds.height {
                newSize.height = bounds.height
            }

            let newFrame = CGRect(
                x: (bounds.width - size.width) / 2,
                y: (bounds.height - size.height) / 2,
                width: size.width,
                height: size.height
            )

            if actualFrame.width != newFrame.width {
                let adjustedWidth = CGRect(
                    x: newFrame.origin.x,
                    y: actualFrame.origin.y,
                    width: newFrame.width,
                    height: actualFrame.height
                )
                presentedView.frame = adjustedWidth
                presentedView.setNeedsDisplay()
            }

            if actualFrame.height != newFrame.height {
                UIView.animate(
                    withDuration: animated ? 0.3 : 0.0,
                    delay: 0,
                    usingSpringWithDamping: 1,
                    initialSpringVelocity: 0.8,
                    options: .curveEaseIn,
                    animations: { () -> Void in
                        presentedView.frame = newFrame
                }, completion: nil)
            }
        }
    }

    func adjustTo(height: CGFloat, width: CGFloat? = nil, animated: Bool) {
        let currentWidth = width == nil ? defaultWidth : width!
        self.adjustTo(size: CGSize(width: currentWidth, height: height), animated: animated)
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

    func setupDismissTap(on view: UIView) {
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
                self.presentedViewController.dismiss(animated: true, completion: nil)
            }
        }
    }

}
