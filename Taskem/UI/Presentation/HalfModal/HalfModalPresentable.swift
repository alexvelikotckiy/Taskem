//
//  HalfModalPresentable.swift
//  Taskem
//
//  Created by Wilson on 17.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

protocol HalfModalPresentable: HalfModalInteractiveTransitionDelegate where Self: HalfModalController {
    func resolveScreenHeight(animated: Bool)
}

extension HalfModalPresentable {
    func adjustTo(height: CGFloat, animated: Bool) {
        if let presentationController = navigationController?.presentationController as? HalfModalPresentationController {
            presentationController.adjustTo(height: height, animated: animated)
        }
    }

    func maximizeToFullScreen(animated: Bool = true) {
        if let presetation = navigationController?.presentationController as? HalfModalPresentationController {
            presetation.adjustToFullScreen(animated: animated)
        }
    }

    func minimizeScreen(animated: Bool = true) {
        if let presentationController = navigationController?.presentationController as? HalfModalPresentationController {
            presentationController.adjustTo(height: navigationController!.view.frame.height / 2, animated: animated)
        }
    }

    func isMaximized() -> Bool? {
        if let presentationController = navigationController?.presentationController as? HalfModalPresentationController {
            return presentationController.isMaximized
        }
        return nil
    }

    func applyPresentingBounce() {
        
    }
}

extension HalfModalPresentable {
    func dismissNoninteractive(animated: Bool, completion: (() -> Void)? = nil) {
        if let delegate = navigationController?.transitioningDelegate as? HalfModalTransitioningDelegate {
            delegate.interactiveDismiss = false
        }
        dismiss(animated: animated, completion: completion)
    }
}
