//
//  TaskOverviewRouter.swift
//  Taskem
//
//  Created by Wilson on 01.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import PainlessInjection

class TaskOverviewStandardRouter: TaskOverviewRouter, DrawerCoordinating {
    unowned var controller: TaskOverviewViewController

    public var drawerDisplayController: DrawerDisplayController?
    private var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    private var modalTransitioningDelegate: ModalTransitioningDelegate?

    init(taskoverviewController: TaskOverviewViewController) {
        self.controller = taskoverviewController
    }

    func dismiss(expandingDismiss: Bool, completion: @escaping () -> Void) {
        if let deledate = controller.navigationController?.transitioningDelegate as? ExpandTransitioningDelegate {
            deledate.interactiveDismiss = false
            deledate.expandTransitioning = expandingDismiss
        }
        controller.navigationController?.dismiss(animated: true, completion: completion)
    }

    func presentRepeatSetup(data: RepeatTemplatesPresenter.InitialData, callback: @escaping TaskRepeatCallback) {
        let vc: RepeatTemplatesViewController = Container.get(data: data, callback: callback)
        let navigationVC = DrawerNavigationController(rootViewController: vc)
        
        drawerDisplayController = DrawerDisplayController(presentingViewController: controller,
                                                          presentedViewController: navigationVC,
                                                          configuration: drawerConfiguration,
                                                          inDebugMode: false)
        
        controller.present(navigationVC, animated: true)
    }
    
    func presentReminderTemplates(data: ReminderTemplatesPresenter.InitialData, callback: @escaping TaskReminderCallback) {
        let vc: ReminderTemplatesViewController = Container.get(data: data, callback: callback)
        let navigationVC = DrawerNavigationController(rootViewController: vc)
        
        drawerDisplayController = DrawerDisplayController(presentingViewController: controller,
                                                          presentedViewController: navigationVC,
                                                          configuration: drawerConfiguration,
                                                          inDebugMode: false)
        
        controller.present(navigationVC, animated: true)
    }
    
    func presentReminderManual(data: ReminderManualPresenter.InitialData, callback: @escaping TaskReminderCallback) {
        let vc: ReminderManualViewController = Container.get(data: data, callback: callback)
        let navigationVC = DrawerNavigationController(rootViewController: vc)
        
        drawerDisplayController = DrawerDisplayController(presentingViewController: controller,
                                                          presentedViewController: navigationVC,
                                                          configuration: drawerConfiguration,
                                                          inDebugMode: false)
        
        controller.present(navigationVC, animated: true)
    }
    
    func presentGroupPopup(data: GroupPopupPresenter.InitialData, completion: @escaping (Group?) -> Void) {
        let vc: GroupPopupViewController = Container.get(data: data, completion: completion)
        let navigationVC = DrawerNavigationController(rootViewController: vc)
        
        drawerDisplayController = DrawerDisplayController(presentingViewController: controller,
                                                          presentedViewController: navigationVC,
                                                          configuration: drawerConfiguration,
                                                          inDebugMode: false)
        
        controller.present(navigationVC, animated: true)
    }
    
    func presentCalendarPopup(data: DatePickerTemplatesPresenter.InitialData, completion: @escaping (DatePreferences?) -> Void) {
        let vc: DatePickerTemplatesViewController = Container.get(data: data, callback: completion)
        let navVC = ModalNavController(controller: vc)
        
        modalTransitioningDelegate = ModalTransitioningDelegate()
        navVC.transitioningDelegate = modalTransitioningDelegate
        
        controller.present(navVC, animated: true, completion: nil)
    }

    func presentTaskNotes(data: TaskNotesPresenter.InitialData, callback: @escaping TaskNotesCallback) {
        let vc: TaskNotesViewController = Container.get(data: data, callback: callback)
        controller.navigationController?.pushViewController(vc, animated: true)
    }

    func alertDelete(title: String, message: String, _ completion: @escaping ((Bool) -> Void)) {
        Alert.alertDeletion(controller, title: title, message: message, completion)
    }

    private var drawerConfiguration: DrawerConfiguration {
        var configuration = DrawerConfiguration.defaultConfiguration()
        configuration.handleViewConfiguration?.autoAnimatesDimming = false
        configuration.fullExpansionBehaviour = .doesNotCoverStatusBar
        configuration.supportsPartialExpansion = true
        configuration.cornerAnimationOption = .alwaysShowBelowStatusBar
        return configuration
    }
}
