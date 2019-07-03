//
//  ExpandTransitioningDelegate.swift
//  ExpandTest
//
//  Created by Wilson on 27.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import UIKit

class ModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    weak var presentationController: ModalPresentationController?

    let presentingAnimator: ModalPresentingAnimator
    let dismissingAnimator: ModalDismissingAnimator

    override init() {
        self.presentingAnimator = ModalPresentingAnimator()
        self.dismissingAnimator = ModalDismissingAnimator()

        super.init()
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.presentingAnimator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.dismissingAnimator
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = ModalPresentationController(presentedViewController: presented, presenting: presenting)
        self.presentationController = presentationController
        return presentationController
    }

}
