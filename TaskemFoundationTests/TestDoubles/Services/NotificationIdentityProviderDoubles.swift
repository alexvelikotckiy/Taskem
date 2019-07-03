//
//  NotificationIdentityProviderDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/3/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class NotificationIdentityProviderStub: NotificationIdentityProvider {
    func produceCategoryNotificationId(_ category: String) -> String {
        return "\(category)"
    }
    
    func produceCategoryNotificationId(_ category: NotificationCategory) -> String {
        return "\(category.rawValue)"
    }
    
    func produceNotificationId(category: NotificationCategory, entityId: EntityId, reminderId: EntityId, date: Date) -> String {
        return "\(category).\(entityId).\(reminderId).\(date)"
    }
    
    func caregoryId(from aString: String) -> String? {
        return "category"
    }
    
    func entityId(from aString: String) -> String? {
        return "entityID"
    }
}
