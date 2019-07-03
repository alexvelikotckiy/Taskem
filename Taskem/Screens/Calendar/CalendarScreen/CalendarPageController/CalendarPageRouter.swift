//
//  CalendarPageRouter.swift
//  Taskem
//
//  Created by Wilson on 8/30/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection
import TaskemFoundation
import PopMenu

class CalendarPageStandardRouter: CalendarPageRouter, DrawerCoordinating {

    weak var controller: CalendarPageViewController!
    
    public var drawerDisplayController: DrawerDisplayController?
    private var expandTransitioningDelegate: ExpandTransitioningDelegate?
    
    init(calendarpageController: CalendarPageViewController) {
        self.controller = calendarpageController
    }
    
    public func presentPopMenu() {
        let manager = PopMenuManager.default
        let config = CalendarPreferences.current
        let theme = AppTheme.current
        
        let refresh = PopMenuDefaultAction(
            title: "REFRESH",
            image: Icons.icScheduleRefresh.image,
            color: theme.secondTitle) { [weak self] _ in
                self?.controller.viewDelegate?.onRefresh()
        }
        let type = PopMenuDefaultAction(
            title: "SORT: \(config.style.description.uppercased())",
            image: Icons.icCalendarType.image,
            color: theme.secondTitle) { [weak self] _ in
                self?.controller.viewDelegate?.onCalendarType(config.style == .bydate ? .standard : .bydate)
        }
        let showCompleted = PopMenuDefaultAction(
            title: config.showCompleted ? "HIDE COMPLETED" : "SHOW COMPLETED",
            image: config.showCompleted ? Icons.icCalendarHideCompleted.image : Icons.icCalendarShowCompleted.image,
            color: theme.secondTitle) { [weak self] _ in
                self?.controller.viewDelegate?.onShowCompleted(!config.showCompleted)
        }
        
        let actions = [
            refresh,
            type,
            showCompleted
        ]

        actions.forEach {
            $0.imageRenderingMode = .alwaysOriginal
        }

        manager.actions = actions
        manager.popMenuAppearance.popMenuFont = .avenirNext(ofSize: 16, weight: .demiBold)
        manager.popMenuAppearance.popMenuBackgroundStyle = .none()
        manager.popMenuShouldDismissOnSelection = false
        manager.popMenuAppearance.popMenuColor.backgroundColor = .solid(fill: theme.background)
        manager.popMenuAppearance.popMenuStatusBarStyle = UIApplication.shared.statusBarStyle
        manager.popMenuShouldDismissOnSelection = true

        manager.present(sourceView: controller.navigationBarDotsItem)
    }
    
    public func presentCalendarControl() {
        let vc: CalendarControlViewController = Container.get()
        let navigationVC = DrawerNavigationController(rootViewController: vc)
        
        drawerDisplayController = DrawerDisplayController(presentingViewController: controller,
                                                          presentedViewController: navigationVC,
                                                          configuration: calendarControlDrawerConfiguration,
                                                          inDebugMode: false)
        
        controller.present(navigationVC, animated: true)
    }
    
    public func presentTaskPopup(initialData: TaskPopupPresenter.InitialData) {
        let vc: TaskPopupViewController = Container.get(data: initialData)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        controller.navigationController?.tabBarController?.present(vc, animated: true)
    }
    
    public func presentTask(initialData: TaskOverviewPresenter.InitialData) {
        let vc: TaskOverviewViewController = Container.get(data: initialData)
        let navVc = ExpandNavController(rootViewController: vc)
        controller.present(navVc, animated: true)
    }
    
    private var calendarControlDrawerConfiguration: DrawerConfiguration {
        var configuration = DrawerConfiguration.defaultConfiguration()
        configuration.handleViewConfiguration?.size = .init(width: 100, height: 4)
        configuration.handleViewConfiguration?.autoAnimatesDimming = false
        configuration.handleViewConfiguration?.backgroundColor = AppTheme.current.handleView
        configuration.fullExpansionBehaviour = .doesNotCoverStatusBar
        configuration.cornerAnimationOption = .alwaysShowBelowStatusBar
        configuration.supportsPartialExpansion = false
        configuration.dismissesInStages = false
        return configuration
    }
}
