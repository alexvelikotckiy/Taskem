//
//  SystemUserPreferences.swift
//  TaskemFoundation
//
//  Created by Wilson on 06.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

private let rootKey = Bundle.taskemFoundation.bundleIdentifier! + ".UserPreferences"

public class SystemUserPreferences: UserPreferencesProtocol {
    
    public var defaults: UserDefaults = .standard

    private let keyFirstWeekday = "\(rootKey):firstWeekday"
    private let keyThemeKey = "\(rootKey):theme"
    private let keyReminderSound = "\(rootKey):reminderSound"
    private let keyIsFirstLaunch = "\(rootKey):isFirstLaunch"
    private let keyMorning = "\(rootKey):morning"
    private let keyNoon = "\(rootKey):noon"
    private let keyEvening = "\(rootKey):evening"

    public init() {
        
    }

    public var firstWeekday: FirstWeekday {
        get {
            if let value = defaults.string(forKey: keyFirstWeekday),
                let firstWeekday = FirstWeekday(rawValue: value) {
                return firstWeekday
            }
            return .monday
        }
        set {
            defaults.set(newValue.rawValue, forKey: keyFirstWeekday)
            defaults.synchronize()
            NotificationCenter.default.post(name: .UserPreferencesDidChangeFirstWeekday, object: self)
        }
    }
    
    public var theme: AppTheme {
        get {
            let value = defaults.string(forKey: keyThemeKey) ?? ""
            if let theme = AppTheme.init(rawValue: value) {
                return theme
            } else {
                return .light
            }
        }
        set {
            defaults.set(newValue.rawValue, forKey: keyThemeKey)
            defaults.synchronize()
            NotificationCenter.default.post(name: .UserPreferencesDidChangeAppTheme, object: self)
        }
    }

    public var reminderSound: String {
        get {
            if let value = defaults.string(forKey: keyReminderSound) {
                return value
            } else {
                return SystemReminderSoundSource.defaultSound
            }
        }
        set {
            defaults.set(newValue, forKey: keyReminderSound)
            defaults.synchronize()
        }
    }

    public var isFirstLaunch: Bool {
        get {
            if let value = defaults.string(forKey: keyIsFirstLaunch) {
                return value == "false"
            } else {
                return true
            }
        }
        set {
            defaults.set(newValue ? "true" : " false", forKey: keyIsFirstLaunch)
            defaults.synchronize()
        }
    }
    
    public var morning: DayTime {
        get {
            if let dayTime = getDayTime(key: keyMorning) {
                return dayTime
            }
            return .init(hour: 8, minute: 0)
        }
        set {
            setDayTime(newValue, key: keyMorning)
            defaults.synchronize()
        }
    }
    
    public var noon: DayTime {
        get {
            if let dayTime = getDayTime(key: keyNoon) {
                return dayTime
            }
            return .init(hour: 12, minute: 0)
        }
        set {
            setDayTime(newValue, key: keyNoon)
            defaults.synchronize()
        }
    }
    
    public var evening: DayTime {
        get {
            if let dayTime = getDayTime(key: keyEvening) {
                return dayTime
            }
            return .init(hour: 18, minute: 0)
        }
        set {
            setDayTime(newValue, key: keyEvening)
            defaults.synchronize()
        }
    }
    
    private func getDayTime(key: String) -> DayTime? {
        if let dictionary = defaults.dictionary(forKey: key) as? [String: Int],
            let value = dictionary["value"] {
            return .init(hour: value / 60, minute: value % 60)
        }
        return nil
    }
    
    private func setDayTime(_ dayTime: DayTime, key: String) {
        let dictionary = ["value": dayTime.hashValue]
        defaults.set(dictionary, forKey: key)
    }
}
