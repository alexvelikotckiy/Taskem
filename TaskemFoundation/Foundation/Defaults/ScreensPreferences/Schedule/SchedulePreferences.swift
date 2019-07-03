//
//  SchedulePrefences.swift
//  Taskem
//
//  Created by Wilson on 01.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol SchedulePreferencesProtocol: class {
    var selectedProjects: Set<EntityId> { get set }
    var sortPreference: ScheduleTableSort { get set }
    var typePreference: ScheduleTableType { get set }
    var scheduleUnexpanded: Set<ScheduleSection> { get set }
    var projectsUnexpanded: Set<EntityId> { get set }
    var flatUnexpanded: Set<ScheduleFlatSection> { get set }
}

public struct SchedulePreferences {
    public static var current: SchedulePreferencesProtocol = SystemSchedulePreferences()
    public static func resetCurrent() {
        current = SystemSchedulePreferences()
    }
}

public extension Notification.Name {
    static let ScheduleConfigurationDidChange = Notification.Name("ScheduleConfigurationDidChange")
    static let ScheduleSectionsConfigurationDidChange = Notification.Name("ScheduleSectionsConfigurationDidChange")
}

public enum ScheduleTableSort: Int, CustomStringConvertible {
    case date = 0
    case name

    public var description: String {
        switch self {
        case .date:
            return "Date"
        case .name:
            return "Name"
        }
    }
}

public enum ScheduleTableType: Int, CustomStringConvertible {
    case schedule = 0
    case project
    case flat

    public var description: String {
        switch self {
        case .schedule:
            return "Schedule"
        case .project:
            return "Project"
        case .flat:
            return "Flat"
        }
    }
}
