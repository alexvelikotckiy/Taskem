//
//  TaskPopupRouter.swift
//  Taskem
//
//  Created by Wilson on 12/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import UIKit
import TaskemFoundation
import PainlessInjection

class TaskPopupStandardRouter: TaskPopupRouter, DrawerCoordinating {
    weak var controller: TaskPopupViewController!

    public var drawerDisplayController: DrawerDisplayController?
    private var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    private var modalTransitioningDelegate: ModalTransitioningDelegate?

    init(taskpopupController: TaskPopupViewController) {
        self.controller = taskpopupController
    }

    func dismiss() {
        self.controller.dismiss(animated: true, completion: nil)
    }
    
    func presentCalendarPopup(_ initialData: DatePickerTemplatesPresenter.InitialData, completion: @escaping DatePickerCallback) {
        let vc: DatePickerTemplatesViewController = Container.get(data: initialData, callback: completion)
        let navVC = ModalNavController(controller: vc)
        
        modalTransitioningDelegate = ModalTransitioningDelegate()
        navVC.transitioningDelegate = modalTransitioningDelegate

        controller.present(navVC, animated: true, completion: nil)
    }
    
    func presentGroupPopup(_ initialData: GroupPopupPresenter.InitialData, completion: @escaping GroupPopupCallback) {
        let vc: GroupPopupViewController = Container.get(data: initialData, completion: completion)
        let navigationVC = DrawerNavigationController(rootViewController: vc)

        drawerDisplayController = DrawerDisplayController(presentingViewController: controller,
                                                          presentedViewController: navigationVC,
                                                          configuration: drawerConfiguration,
                                                          inDebugMode: false)

        controller.present(navigationVC, animated: true)
    }
    
    func presentRepeatPicker(_ initialData: RepeatTemplatesPresenter.InitialData, callback: @escaping TaskRepeatCallback) {
        let vc: RepeatTemplatesViewController = Container.get(data: initialData, callback: callback)
        let navigationVC = DrawerNavigationController(rootViewController: vc)

        drawerDisplayController = DrawerDisplayController(presentingViewController: controller,
                                                          presentedViewController: navigationVC,
                                                          configuration: drawerConfiguration,
                                                          inDebugMode: false)

        controller.present(navigationVC, animated: true)
    }
    
    func presentReminderTemplates(_ initialDate: ReminderTemplatesPresenter.InitialData, callback: @escaping TaskReminderCallback) {
        let vc: ReminderTemplatesViewController = Container.get(data: initialDate, callback: callback)
        let navigationVC = DrawerNavigationController(rootViewController: vc)

        drawerDisplayController = DrawerDisplayController(presentingViewController: controller,
                                                          presentedViewController: navigationVC,
                                                          configuration: drawerConfiguration,
                                                          inDebugMode: false)

        controller.present(navigationVC, animated: true)
    }
    
    func presentReminderManual(_ initialDate: ReminderManualPresenter.InitialData, callback: @escaping TaskReminderCallback) {
        let vc: ReminderManualViewController = Container.get(data: initialDate, callback: callback)
        let navigationVC = DrawerNavigationController(rootViewController: vc)
        
        drawerDisplayController = DrawerDisplayController(presentingViewController: controller,
                                                          presentedViewController: navigationVC,
                                                          configuration: drawerConfiguration,
                                                          inDebugMode: false)
        
        controller.present(navigationVC, animated: true)
    }

    private var drawerConfiguration: DrawerConfiguration {
        var configuration = DrawerConfiguration.defaultConfiguration()
        configuration.handleViewConfiguration?.size = .init(width: 100, height: 4)
        configuration.handleViewConfiguration?.autoAnimatesDimming = false
        configuration.handleViewConfiguration?.backgroundColor = AppTheme.current.handleView
        configuration.fullExpansionBehaviour = .doesNotCoverStatusBar
        configuration.supportsPartialExpansion = true
        configuration.cornerAnimationOption = .alwaysShowBelowStatusBar
        return configuration
    }
}
