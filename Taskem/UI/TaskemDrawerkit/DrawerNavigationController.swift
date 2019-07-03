//
//  DrawerNavigationController.swift
//  Taskem
//
//  Created by Wilson on 8/10/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class DrawerNavigationController: UINavigationController, ThemeObservable {
    var shouldForceNavigationBar = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.prefersLargeTitles = true
        observeAppTheme()
    }
    
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.navbar
    }
}

extension DrawerNavigationController: DrawerAnimationParticipant {
    var drawerAnimationActions: DrawerAnimationActions {
        let topViewControllerActions = (topViewController as? DrawerAnimationParticipant)?.drawerAnimationActions ?? DrawerAnimationActions()

        let prepareAction: DrawerAnimationActions.PrepareHandler = { [weak self] info in
            self?.resolveIfClipsToBounds(info: info)
            self?.forceNavigationBar(info: info)
            topViewControllerActions.prepare?(info)
        }

        let animateAlongAction: DrawerAnimationActions.AnimateAlongHandler = { [weak self] info in
            self?.resolveIfClipsToBounds(info: info)
            self?.forceNavigationBar(info: info)
            topViewControllerActions.animateAlong?(info)
        }

        let cleanupAction: DrawerAnimationActions.CleanupHandler = { [weak self] info in
            self?.resolveIfClipsToBounds(info: info)
            self?.forceNavigationBar(info: info)
            topViewControllerActions.cleanup?(info)
        }

        return .init(prepare: prepareAction,
                     animateAlong: animateAlongAction,
                     cleanup: cleanupAction)
    }
    
    private func forceNavigationBar(info: DrawerAnimationInfo) {
        switch (info.startDrawerState, info.endDrawerState) {
        case (_, .fullyExpanded) where shouldForceNavigationBar:
            let isHiddenToolbar = isToolbarHidden
            setToolbarHidden(false, animated: false)
            setToolbarHidden(true, animated: false)
            setToolbarHidden(isHiddenToolbar, animated: false)
            shouldForceNavigationBar = false
        default:
            break
        }
    }
    
    private func resolveIfClipsToBounds(info: DrawerAnimationInfo) {
        switch (info.startDrawerState, info.endDrawerState) {
        case (_, .fullyExpanded):
            switch info.configuration.fullExpansionBehaviour {
            case .coversFullScreen:
                navigationBar.clipsToBounds = false
            default:
                navigationBar.clipsToBounds = true
            }
        default:
            navigationBar.clipsToBounds = true
        }
    }
}

extension DrawerNavigationController: DrawerPresentable {
    var shouldBeginTransitioning: Bool {
        return (topViewController as? DrawerPresentable)?.shouldBeginTransitioning ?? true
    }
    
    var drawerViewParticipants: [UIView] {
        var views = (topViewController as? DrawerPresentable)?.drawerViewParticipants ?? []
        views.append(navigationBar)
        views.append(view.subviews[0])
        return views
    }
    
    var heightOfPartiallyExpandedDrawer: CGFloat {
        return (topViewController as? DrawerPresentable)?.heightOfPartiallyExpandedDrawer ?? 0.0
    }
}
