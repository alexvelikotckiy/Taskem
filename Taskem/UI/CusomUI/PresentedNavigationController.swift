//
//  PresentedNavigationController.swift
//  Taskem
//
//  Created by Wilson on 8/1/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import DrawerKit

class PresentedNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = .black
        view.tintColor = .black
        delegate = self
    }
}

extension PresentedNavigationController: DrawerAnimationParticipant {
    var drawerAnimationActions: DrawerAnimationActions {
        return (topViewController as? DrawerAnimationParticipant)?.drawerAnimationActions
            ?? DrawerAnimationActions()
    }
}

extension PresentedNavigationController: DrawerPresentable {
    var heightOfPartiallyExpandedDrawer: CGFloat {
        return (topViewController as? DrawerPresentable)?.heightOfPartiallyExpandedDrawer ?? 0.0
    }
}

extension PresentedNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let viewController = viewController as? DrawerPresentationControlling {
            drawerPresentationController?.scrollViewForPullToDismiss = viewController.scrollViewForPullToDismiss
        }
    }
}
