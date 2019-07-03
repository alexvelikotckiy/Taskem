//
//  IOSNotificationHandler.swift
//  Taskem
//
//  Created by Wilson on 8/24/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import TaskemFirebase
import PainlessInjection
import UserNotifications

class IOSNotificationHandler: NSObject, NotificationHandler, UNUserNotificationCenterDelegate {
    let center: UNUserNotificationCenter = .current()
    
    let dataHandler: NotificationHandlerDataUpdater
    
    let identityProvider: SystemNotificationIdentityProvider = .standard
    
    public init(dataHandler: NotificationHandlerDataUpdater) {
        self.dataHandler = dataHandler
        super.init()
    }
    
    func start() {
        center.delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        guard let categoryIdentifier = identityProvider.caregoryId(from: response.notification.request.content.categoryIdentifier) else { return }
        
        guard let categoty = NotificationCategory.init(rawValue: categoryIdentifier),
            let action = NotificationAction.init(rawValue: response.actionIdentifier) else  {
                completionHandler()
                return
        }

        switch categoty {
        case .task:
            guard let id = identityProvider.entityId(from: response.notification.request.identifier) else { return }
            switch action {
            case .complete:
                dataHandler.setTaskAsComplete(by: id, completionHandler)
                
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge])
    }
}
