//
//  TapBarViewController.swift
//  Taskem
//
//  Created by Wilson on 21.12.2017.
//  Copyright © 2017 Wilson. All rights reserved.
//

import UIKit
import PainlessInjection
import TaskemFoundation

class TapBarViewController: UITabBarController {

    private let viewModel: TabbarViewModel

    init(viewModel: TabbarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.start()
        viewModel.onShowOnboarding = { [weak self] in self?.showOnboarding() }
        viewModel.onShowTemplateSetup = { [weak self] in self?.showTemplatesSetup() }
        viewModel.onShowUserAuth = { [weak self] in self?.showUserAuth() }
    }

    private func showOnboarding() {
        let navController = UINavigationController(rootViewController: OnboardingController())
        navController.isNavigationBarHidden = true
        present(navController, animated: false, completion: nil)
    }

    private func showTemplatesSetup() {
        let vc: UserTemplatesSetupViewController = Container.get()
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        present(navController, animated: false, completion: nil)
    }

    private func showUserAuth() {
        popToRootCurrentNavigationController()
        let vc: LogInViewController = Container.get()
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true, completion: nil)
    }
    
    private func popToRootCurrentNavigationController() {
        if let navVc = selectedViewController as? UINavigationController {
            if let topVc = navVc.topViewController {
                topVc.presentedViewController?.dismiss(animated: false, completion: nil)
            }
            navVc.popToRootViewController(animated: true)
        }
    }
    
    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not available. Use the appropriate init method.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewControllers = appTabBarControllers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.appear()
    }

    open func appTabBarControllers() -> [UIViewController] {
        return [
            scheduleStack,
            calendarStack,
            settingsStack
        ]
    }

}

extension TapBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        print("Selected \(viewController.title!)")
    }
}

private let scheduleStack: UIViewController = ({
    let controller: ScheduleViewController = Container.get()
    let scheduleStack = UINavigationController(navigationBarClass: ScheduleNavigationBar.self, toolbarClass: nil)
    scheduleStack.title = "Schedule"
    scheduleStack.setViewControllers([controller], animated: false)
    scheduleStack.tabBarItem = UITabBarItem(
        title: "Schedule",
        image: Icons.icTabbarSchedule.image,
        selectedImage: nil)
    scheduleStack.tabBarItem.accessibilityIdentifier = "Schedule"
    return scheduleStack
})()

private let calendarStack: UIViewController = ({
    let pageController: CalendarPageViewController = Container.get()    
    let calendarStack = CalendarPageNavController(navigationBarClass: CalendarNavigationBar.self, toolbarClass: nil)
    calendarStack.setViewControllers([pageController], animated: false)
    calendarStack.title = "Calendar"
    calendarStack.tabBarItem = UITabBarItem(
        title: "Calendar",
        image: Icons.icTabbarCalendar.image,
        selectedImage: nil)
    calendarStack.tabBarItem.accessibilityIdentifier = "Calendar"
    return calendarStack
})()

private let settingsStack: UIViewController = ({
    let controller: SettingsViewController = Container.get()
    let settingsStack = UINavigationController(rootViewController: controller)
    settingsStack.title = "Settings"
    settingsStack.tabBarItem = UITabBarItem(
        title: "Settings",
        image: Icons.icTabbarSettings.image,
        selectedImage: nil)
    settingsStack.tabBarItem.accessibilityIdentifier = "Settings"
    return settingsStack
})()
