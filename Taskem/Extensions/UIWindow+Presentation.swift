//
//  UIWindow+Presentation.swift
//  Taskem
//
//  Created by Wilson on 8/28/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

extension UIWindow {
    var taskemViewControllerToPresentOn: UIViewController? {
        if let rootController = rootViewController {
            if let presented = findTopPresentedViewController(in: rootController) {
                return presented
            } else {
                return rootController
            }
        } else {
            return nil
        }
    }
    
    private func findTopPresentedViewController(in controller: UIViewController) -> UIViewController? {
        if let controller = controller.presentedViewController {
            if controller.presentedViewController == nil {
                return controller
            } else {
                return findTopPresentedViewController(in: controller)
            }
        } else {
            return nil
        }
    }
}
