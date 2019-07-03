//
//  ExpandNavController.swift
//  ExpandTest
//
//  Created by Wilson on 28.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import UIKit

class ExpandNavController: UINavigationController, ExpandTransitioningAdapter {

    var onDisappear: (() -> Void)?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onDisappear?()
    }
    
    func willBeginInteractiveTransitioning() {
        if let topViewController = self.topViewController as? ExpandTransitioningAdapter {
            topViewController.willBeginInteractiveTransitioning()
        }
    }
    
    func didEndInteractiveTransitioning() {
        if let topViewController = self.topViewController as? ExpandTransitioningAdapter {
            topViewController.didEndInteractiveTransitioning()
        }
    }

    func shouldBeginExpandInteractiveTransitioning() -> Bool {
        if let topViewController = self.topViewController as? ExpandTransitioningAdapter {
            return topViewController.shouldBeginExpandInteractiveTransitioning()
        }
        return false
    }
}
