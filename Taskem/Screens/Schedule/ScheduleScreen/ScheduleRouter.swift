//
//  ScheduleRouter.swift
//  Taskem
//
//  Created by Wilson on 11/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation
import TaskemFoundation
import PainlessInjection
import PopMenu

public class ScheduleStandardRouter: ScheduleRouter, DrawerCoordinating {
    weak var controller: ScheduleViewController!

    public var drawerDisplayController: DrawerDisplayController?
    private var modalTransitioningDelegate: ModalTransitioningDelegate?
    private var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    private var expandTransitioningDelegate: ExpandTransitioningDelegate?

    init(scheduleController: ScheduleViewController) {
        self.controller = scheduleController
    }

    public func presentPopMenu() {
        let manager = PopMenuManager.default
        
        let theme = AppTheme.current
        
        let refresh = PopMenuDefaultAction(
            title: "REFRESH",
            image: Icons.icScheduleRefresh.image,
            color: theme.secondTitle) { [weak self] _ in
                self?.controller.delegate?.onRefresh()
        }
        let search = PopMenuDefaultAction(
            title: "SEARCH",
            image: Icons.icScheduleSearch.image,
            color: theme.secondTitle) { [weak self] _ in
                self?.controller.delegate?.onBeginSearch()
        }
        let edit = PopMenuDefaultAction(
            title: "EDIT",
            image: Icons.icScheduleRescheduleLarge.image,
            color: theme.secondTitle) { [weak self] _ in
                self?.controller.isEditing = true
        }
        
        let actions = [
            refresh,
            search,
            edit
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
    
    public func presentScheduleControl() {
        let vc: ScheduleControlViewController = Container.get()
        let navigationVC = DrawerNavigationController(navigationBarClass: ScheduleControlNavigationBar.self, toolbarClass: ScheduleControlToolbar.self)
        navigationVC.setViewControllers([vc], animated: false)
        
        drawerDisplayController = DrawerDisplayController(presentingViewController: controller,
                                                          presentedViewController: navigationVC,
                                                          configuration: scheduleControlDrawerConfiguration,
                                                          inDebugMode: false)
        
        controller.present(navigationVC, animated: true)
    }
    
    public func presentDatePickerPopup(initialData: DatePickerTemplatesPresenter.InitialData, completion: @escaping DatePickerCallback) {
        let vc: DatePickerTemplatesViewController = Container.get(data: initialData, callback: completion)
        let navVC = ModalNavController(controller: vc)
        modalTransitioningDelegate = .init()
        navVC.transitioningDelegate = self.modalTransitioningDelegate
        controller.navigationController?.present(navVC, animated: true)
    }
    
    public func presentGroupPopup(initialData: GroupPopupPresenter.InitialData, completion: @escaping GroupPopupCallback) {
        let vc: GroupPopupViewController = Container.get(data: initialData, completion: completion)
        let navigationVC = DrawerNavigationController(rootViewController: vc)
        
        drawerDisplayController = DrawerDisplayController(presentingViewController: controller,
                                                          presentedViewController: navigationVC,
                                                          configuration: drawerConfiguration,
                                                          inDebugMode: false)
        
        controller.present(navigationVC, animated: true)
    }

    public func presentTaskPopup(initialData: TaskPopupPresenter.InitialData) {
        let vc: TaskPopupViewController = Container.get(data: initialData)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        controller.navigationController?.tabBarController?.present(vc, animated: true)
    }
    
    public func presentTask(initialData: TaskOverviewPresenter.InitialData, frame: CGRect?) {
        let vc: TaskOverviewViewController = Container.get(data: initialData)
        let navVc = ExpandNavController(rootViewController: vc)
        
        if let frame = frame {
            expandTransitioningDelegate = .init(viewController: controller, presentingViewController: navVc, collapsedFrame: frame)
            navVc.modalPresentationStyle = .custom
            navVc.transitioningDelegate = expandTransitioningDelegate
            
            // http://openradar.appspot.com/19563577
            DispatchQueue.main.async {
                self.controller.present(navVc, animated: true)
            }
        } else {
            controller.present(navVc, animated: true)
        }
    }

    public func presentComplete() {
        let vc: CompletedViewController = Container.get()
        self.controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    public func presentReschedule() {
        let vc: RescheduleViewController = Container.get()
        controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    public func presentSearch() {
        controller.navigationController?.present(controller.searchController, animated: true, completion: nil)
        controller.willPresentSearchController(controller.searchController)
    }
    
    public func alertDelete(title: String, message: String, _ completion: @escaping (Bool) -> Void) {
        let cancelTitle = "Cancel"
        let confirmTitle = "Delete"
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in completion(false) }
        let deleteAction = UIAlertAction(title: confirmTitle, style: .destructive) { _ in completion(true) }

        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        actionSheet.addAction(cancelAction)
        actionSheet.addAction(deleteAction)
        self.controller.present(actionSheet, animated: true, completion: nil)
    }

    public func alertView(message: String) {
        AlertView.post(in: controller, message: message)
    }

    private var scheduleControlDrawerConfiguration: DrawerConfiguration {
        var configuration = DrawerConfiguration.defaultConfiguration()
        configuration.handleViewConfiguration?.autoAnimatesDimming = false
        configuration.handleViewConfiguration?.backgroundColor = AppTheme.current.handleView
        configuration.fullExpansionBehaviour = .doesNotCoverStatusBar
        configuration.cornerAnimationOption = .alwaysShowBelowStatusBar
        configuration.supportsPartialExpansion = false
        configuration.dismissesInStages = false
        return configuration
    }
    
    private var drawerConfiguration: DrawerConfiguration {
        return DrawerConfiguration.defaultConfiguration()
    }
}
