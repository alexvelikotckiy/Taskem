//
//  ExpandTransitioningDelegate.swift
//  ExpandTest
//
//  Created by Wilson on 27.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import UIKit

class ExpandTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    weak var viewController: UIViewController?
    weak var presentingViewController: UIViewController?

    weak var presentationController: ExpandPresentationController?

    let interactiveTransitioning: ExpandInteractiveTransitioning
    var expandAdapter: ExpandTransitioningAdapter?

    lazy var presentingAnimator = {
        ExpandPresentingAnimator(collapsedViewFrame: collapsedFrame, expandedViewFrame: expandedFrame)
    }()

    lazy var dismissingAnimator = {
        return ExpandDismissingAnimator(collapsedViewFrame: collapsedFrame, expandedViewFrame: expandedFrame)
    }()

    var interactiveDismiss = true
    var expandTransitioning = true

    var collapsedFrame: CGRect
    var expandedFrame: CGRect

    init(viewController: UIViewController, presentingViewController: UIViewController, collapsedFrame: CGRect) {
        self.viewController = viewController
        self.presentingViewController = presentingViewController

        self.collapsedFrame = collapsedFrame
        self.expandedFrame = presentingViewController.view.bounds
        self.interactiveTransitioning = ExpandInteractiveTransitioning(viewController: viewController, presentingViewController: presentingViewController)

        super.init()

        if let presentingExpandAdapter = presentingViewController as? ExpandTransitioningAdapter {
            self.expandAdapter = presentingExpandAdapter
            self.interactiveTransitioning.expandAdapter = presentingExpandAdapter
        }
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if expandTransitioning {
            return self.presentingAnimator
        }
        return nil
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if expandTransitioning {
            self.dismissingAnimator.presentationController = self.presentationController
            return self.dismissingAnimator
        }
        return nil
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interactiveDismiss {
            self.interactiveTransitioning.dismissAnimator = dismissingAnimator
            self.interactiveTransitioning.expandAdapter = expandAdapter
            return self.interactiveTransitioning
        }
        return nil
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = ExpandPresentationController(presentedViewController: presented, presenting: presenting)
        self.presentationController = presentationController
        return presentationController
    }

    func setTransitioningType(isInteractive: Bool) {
        self.interactiveDismiss = isInteractive
    }
}
