//
//  AppLaunchTask.swift
//  Taskem
//
//  Created by Wilson on 3/8/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection
import TaskemFoundation
import UserNotifications
import GoogleSignIn
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import Answers

protocol AppLaunchTask {
    func perform()
}

class FabricLaunchTask: AppLaunchTask {
    func perform() {
        #if FABRIC
        Fabric.with([Crashlytics.self, Answers.self])
        #endif
    }
}

class PainlessInjectionLaunchTask: AppLaunchTask {
    func perform() {
        Container.load()
    }
}

class IQKeyboardManagerLaunchTask: AppLaunchTask {
    func perform() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.disabledToolbarClasses.append(contentsOf: [TaskNotesViewController.self, TaskPopupViewController.self, TaskOverviewViewController.self])
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(contentsOf: [TaskPopupViewController.self])
    }
}

class AppUIAppearanceLaunchTask: AppLaunchTask {
    func perform() {
        let themeManager: ThemeManager = Container.get()
        themeManager.start()
    }
}

class AppNotificationsLaunchTask: AppLaunchTask {
    func perform() {
        let center = UNUserNotificationCenter.current()
        
        let complete = NotificationAction.complete
        let completeAction = UNNotificationAction(identifier: complete.rawValue, title: complete.description, options: [.authenticationRequired])
        
        let taskId = SystemNotificationIdentityProvider.standard.produceCategoryNotificationId(.task)
        let taskCategory = UNNotificationCategory(identifier: taskId, actions: [completeAction], intentIdentifiers: [], options: [.customDismissAction])
        
        center.setNotificationCategories([taskCategory])
        
        let notificationHandler: NotificationHandler = Container.get()
        notificationHandler.start()
    }
}

class SetWindowLaunchTask: AppLaunchTask {
    private let appDel: AppDelegate
    
    init(delegate: AppDelegate) {
        self.appDel = delegate
    }
    
    func perform() {
        appDel.window = UIWindow(frame: UIScreen.main.bounds)
        appDel.window?.rootViewController = Container.get() as TapBarViewController
        appDel.window?.makeKeyAndVisible()
    }
}
