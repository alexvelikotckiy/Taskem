//
//  SystemCalendarPreferences.swift
//  TaskemFoundation
//
//  Created by Wilson on 4/12/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

private let rootKey = Bundle.taskemFoundation.bundleIdentifier! + ".calendarConfiguration"

public class SystemCalendarConfiguration: CalendarConfiguration {

    private var defaults: UserDefaults = .standard

    private func notifyDidChange() {
        if isPaused { return }
        NotificationCenter.default.post(name: .CalendarConfigurationDidChange, object: self)
    }
    
    private var isPaused = false
    
    public func pause(onCompletion notification: Notification.Name?, _ block: () -> Void) {
        isPaused = true
        block()
        if let notification = notification {
            NotificationCenter.default.post(name: notification, object: self)
        }
        isPaused = false
    }
    
    private let keyCalendarStyle = "\(rootKey):calendarStyle"
    private let keyShowCompleted = "\(rootKey):showCompleted"
    private let keyUnselectedAppleCalendars = "\(rootKey):unselectedAppleCalendars"
    private let keyUnselectedTaskemGroups = "\(rootKey):unselectedTaskemGroups"
    
    public var style: CalendarStyle {
        get {
            let value = CalendarStyle(rawValue: defaults.integer(forKey: keyCalendarStyle)) ?? .standard
            return value
        }
        set {
            defaults.set(newValue.rawValue, forKey: keyCalendarStyle)
            defaults.synchronize()
            notifyDidChange()
        }
    }

    public var showCompleted: Bool {
        get {
            return defaults.bool(forKey: keyShowCompleted)
        }
        set {
            defaults.set(newValue, forKey: keyShowCompleted)
            defaults.synchronize()
            notifyDidChange()
        }
    }

    public var unselectedAppleCalendars: Set<String> {
        get {
            let values = defaults.stringArray(forKey: keyUnselectedAppleCalendars) ?? []
            return Set(values)
        }
        set {
            defaults.set(newValue.array, forKey: keyUnselectedAppleCalendars)
            defaults.synchronize()
            notifyDidChange()
        }
    }

    public var unselectedTaskemGroups: Set<String> {
        get {
            let values = defaults.stringArray(forKey: keyUnselectedTaskemGroups) ?? []
            return Set(values)
        }
        set {
            defaults.set(newValue.array, forKey: keyUnselectedTaskemGroups)
            defaults.synchronize()
            notifyDidChange()
        }
    }
}
