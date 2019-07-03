//
//  CalendarPreferences.swift
//  TaskemFoundation
//
//  Created by Wilson on 4/12/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol CalendarConfiguration: NotificationPauseable {
    var style: CalendarStyle { get set }
    var showCompleted: Bool { get set }
    var unselectedAppleCalendars: Set<String> { get set }
    var unselectedTaskemGroups: Set<String> { get set }
}

public struct CalendarPreferences {
    public static var current: CalendarConfiguration = SystemCalendarConfiguration()
    public static func resetCurrent() {
        current = SystemCalendarConfiguration()
    }
}

public extension Notification.Name {
    static let CalendarConfigurationDidChange = Notification.Name("CalendarConfigurationDidChange")
}

public enum CalendarStyle: Int, CustomStringConvertible {
    case standard = 0
    case bydate
    
    public var description: String {
        switch self {
        case .bydate:
            return "By Date"
        case .standard:
            return "Standard"
        }
    }
}
