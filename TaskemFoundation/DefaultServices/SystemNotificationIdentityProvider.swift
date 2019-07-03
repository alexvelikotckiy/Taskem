//
//  NotificationIdentityProvider.swift
//  TaskemFoundation
//
//  Created by Wilson on 4/9/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class SystemNotificationIdentityProvider: NotificationIdentityProvider {

    public static let standard: SystemNotificationIdentityProvider = .init(bundleIdentifier: Bundle.taskemFoundation.bundleIdentifier!)
    public let bundleIdentifier: String

    public init(bundleIdentifier: String) {
        self.bundleIdentifier = bundleIdentifier
    }

    public var reminderBase: String {
        return "\(bundleIdentifier)"
    }

    public func produceCategoryNotificationId(_ category: String) -> String {
        return "\(reminderBase).\(category)"
    }

    public func produceCategoryNotificationId(_ category: NotificationCategory) -> String {
        return "\(reminderBase).\(category.rawValue)"
    }
    
    public func produceNotificationId(category: NotificationCategory, entityId: EntityId, reminderId: EntityId, date: Date) -> String {
        return "\(produceCategoryNotificationId(category)).entity(\(entityId)).reminder(\(reminderId)).date(\(String(describing: date)))"
    }

    public func caregoryId(from aString: String) -> String? {
        if let range = aString.range(of: "(?<=\(bundleIdentifier)\\.).*?(?=\\.)", options: .regularExpression) {
            return .init(aString[range])
        }
        if let range = aString.range(of: "(?<=\(bundleIdentifier)\\.).*?(?<=\\z)", options: .regularExpression) {
            return .init(aString[range])
        }
        return nil
    }

    public func entityId(from aString: String) -> String? {
        guard let range = aString.range(of: "(?<=entity\\().*?(?=\\))", options: .regularExpression) else { return nil }
        return .init(aString[range])
    }
}

public enum NotificationAction: String, CustomStringConvertible {
    case complete = "complete"
    
    public var description: String {
        switch self {
        case .complete:
            return "Set as completed"
        }
    }
}

public enum NotificationCategory: String {
    case task = "task"
}
