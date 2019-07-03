//
//  AppDelegate.swift
//  Taskem
//
//  Created by Wilson on 11.11.2017.
//  Copyright © 2017 Wilson. All rights reserved.
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let laucnhTasks: [AppLaunchTask] = [
            FabricLaunchTask(),
            PainlessInjectionLaunchTask(),
            IQKeyboardManagerLaunchTask(),
            AppUIAppearanceLaunchTask(),
            AppNotificationsLaunchTask(),
            SetWindowLaunchTask(delegate: self),
        ]
        laucnhTasks.forEach { $0.perform() }
        
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: [:])
    }
}
