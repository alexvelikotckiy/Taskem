//
//  HalfModalNavController.swift
//  Taskem
//
//  Created by Wilson on 03.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit

class HalfModalNavController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let presentationController = presentationController as? HalfModalPresentationController {
            return presentationController.isMaximized ? .default : .lightContent
        }
        return .default
    }
}

extension HalfModalNavController: HalfModalInteractiveTransitionDelegate {
    func shouldBeginInteractiveTransition() -> Bool {
        guard let vc = topViewController as? HalfModalInteractiveTransitionDelegate else { return false }
        return vc.shouldBeginInteractiveTransition()
    }
}

class HalfModalController: UIViewController {
    var wasFirstAppear = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        wasFirstAppear = true
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let delegate = navigationController?.transitioningDelegate as? HalfModalTransitioningDelegate {
            delegate.interactiveDismiss = false
        }
        super.dismiss(animated: flag, completion: completion)
    }
}
