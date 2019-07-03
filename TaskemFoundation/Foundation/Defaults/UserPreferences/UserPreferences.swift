//
//  UserPreferences.swift
//  TaskemFoundation
//
//  Created by Wilson on 06.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol UserPreferencesProtocol: class {
    var theme: AppTheme { get set }
    var morning: DayTime { get set }
    var noon: DayTime { get set }
    var evening: DayTime { get set }
    var firstWeekday: FirstWeekday { get set }
    var reminderSound: String { get set }
    var isFirstLaunch: Bool { get set }
}

public struct UserPreferences {
    public static var current: UserPreferencesProtocol = SystemUserPreferences()
    public static func resetCurrent() {
        current = SystemUserPreferences()
    }
}

extension Notification.Name {
    public static let UserPreferencesDidChangeAppTheme = Notification.Name("UserPreferencesDidChangeAppTheme")
    public static let UserPreferencesDidChangeFirstWeekday = Notification.Name("UserPreferencesDidChangeFirstWeekday")
}
