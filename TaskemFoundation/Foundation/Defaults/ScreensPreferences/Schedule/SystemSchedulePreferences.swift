//
//  SchedulePrefences.swift
//  TaskemFoundation
//
//  Created by Wilson on 13.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

private let rootKey = Bundle.taskemFoundation.bundleIdentifier! + ".SchedulePreferences"

public class SystemSchedulePreferences: SchedulePreferencesProtocol {

    public var defaults: UserDefaults = .standard

    private let keySortPreference = "\(rootKey):sortPreference"
    private let keyTypePreference = "\(rootKey):typePreference"
    private let keySelectedProjects = "\(rootKey):selectedProjects"
    
    private let keyScheduleUnexpanded = "\(rootKey):scheduleUnexpanded"
    private let keyProjectsUnexpanded = "\(rootKey):projectsUnexpanded"
    private let keyFlatUnexpanded = "\(rootKey):flatUnexpanded"

    public init() {
        
    }
    
    private func notifyDidChange() {
        NotificationCenter.default.post(name: .ScheduleConfigurationDidChange, object: self)
    }

    private func notifyDidChangeSections() {
        NotificationCenter.default.post(name: .ScheduleSectionsConfigurationDidChange, object: self)
    }

    public var selectedProjects: Set<EntityId> {
        get {
            let value = defaults.stringArray(forKey: keySelectedProjects) ?? []
            return Set(value)
        }
        set {
            defaults.set(newValue.array, forKey: keySelectedProjects)
            defaults.synchronize()
            notifyDidChange()
        }
    }

    public var sortPreference: ScheduleTableSort {
        get {
            let value = ScheduleTableSort(rawValue: defaults.integer(forKey: keySortPreference)) ?? .date
            return value
        }
        set {
            defaults.set(newValue.rawValue, forKey: keySortPreference)
            defaults.synchronize()
            notifyDidChange()
        }
    }

    public var typePreference: ScheduleTableType {
        get {
            let value = ScheduleTableType(rawValue: defaults.integer(forKey: keyTypePreference)) ?? .schedule
            return value
        }
        set {
            defaults.set(newValue.rawValue, forKey: keyTypePreference)
            defaults.synchronize()
            notifyDidChange()
        }
    }

    public var scheduleUnexpanded: Set<ScheduleSection> {
        get {
            let values = defaults.array(forKey: keyScheduleUnexpanded)?
                .compactMap { $0 as? Int }
                .compactMap { ScheduleSection(rawValue: $0) } ?? []
            return Set(values)
        }
        set {
            defaults.set(newValue.map { $0.rawValue }, forKey: keyScheduleUnexpanded)
            defaults.synchronize()
            notifyDidChangeSections()
        }
    }

    public var projectsUnexpanded: Set<EntityId> {
        get {
            let values = defaults.stringArray(forKey: keyProjectsUnexpanded) ?? []
            return Set(values)
        }
        set {
            defaults.set(newValue.array, forKey: keyProjectsUnexpanded)
            defaults.synchronize()
            notifyDidChangeSections()
        }
    }

    public var flatUnexpanded: Set<ScheduleFlatSection> {
        get {
            let values = defaults.array(forKey: keyFlatUnexpanded)?
                .compactMap { $0 as? Int }
                .compactMap { ScheduleFlatSection(rawValue: $0) } ?? []
            return Set(values)
        }
        set {
            defaults.set(newValue.map { $0.rawValue }, forKey: keyFlatUnexpanded)
            defaults.synchronize()
            notifyDidChangeSections()
        }
    }
}
