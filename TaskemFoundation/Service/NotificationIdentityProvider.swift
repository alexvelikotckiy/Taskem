//
//  NotificationIdentityProvider.swift
//  TaskemFoundation
//
//  Created by Wilson on 10/3/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol NotificationIdentityProvider {
    
    func produceCategoryNotificationId(_ category: String) -> String
    func produceCategoryNotificationId(_ category: NotificationCategory) -> String
    func produceNotificationId(category: NotificationCategory, entityId: EntityId, reminderId: EntityId, date: Date) -> String
    
    func caregoryId(from aString: String) -> String?
    func entityId(from aString: String) -> String?
}
