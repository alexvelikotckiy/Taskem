//
//  SchedulePreferencesDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/25/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class SchedulePreferencesStub: SchedulePreferencesProtocol {
    var selectedProjects: Set<EntityId> = .init()
    var sortPreference: ScheduleTableSort = .date
    var typePreference: ScheduleTableType = .schedule
    var scheduleUnexpanded: Set<ScheduleSection> = .init()
    var projectsUnexpanded: Set<EntityId> = .init()
    var flatUnexpanded: Set<ScheduleFlatSection> = .init()
}
