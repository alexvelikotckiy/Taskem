//
//  DevDataSource.swift
//  TaskemFoundation
//
//  Created by Wilson on 7/13/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol DevDataSource: class {
    func devGroups() -> [Group]
    func devTasks(_ allGroups: [Group]) -> [Task]
}

public class SystemDevDataSource: DevDataSource {
    public init() {
        
    }
    
    public func devTasks(_ allGroups: [Group]) -> [Task] {
        return [
            Task(
                id: .auto(),
                name: "Overdue 1",
                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(-10), isAllDay: false),
                creationDate: Date.now.dateFromDays(-11),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: Date.now.dateFromDays(-11), relativeOffset: 0)),
                idGroup: allGroups[0].id,
                repeatPref: RepeatPreferences(rule: .daily)
            ),
            
            Task(
                id: .auto(),
                name: "Overdue 2",
                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(-8), isAllDay: false),
                creationDate: Date.now.dateFromDays(-8),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[1].id,
                repeatPref: RepeatPreferences(rule: .weekly, daysOfWeek: [1, 3, 5], endDate: Date.now)
            ),
            
            Task(
                id: .auto(),
                name: "Overdue 3",
                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(-6), isAllDay: true),
                creationDate: Date.now.dateFromDays(-7),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[2].id,
                repeatPref: RepeatPreferences(rule: .monthly)
            ),
            
            Task(
                id: .auto(),
                name: "Overdue 4",
                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(-3), isAllDay: false),
                creationDate: Date.now.dateFromDays(-4),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[3].id,
                repeatPref: RepeatPreferences()
            ),
            
            Task(
                id: .auto(),
                name: "Overdue 5",
                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(-1), isAllDay: true),
                creationDate: Date.now,
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[4].id,
                repeatPref: RepeatPreferences()
            ),
            
            Task(
                id: .auto(),
                name: "Today 1",
                datePrefences: DatePreferences(assumedDate: Date.now.startOfDay, isAllDay: false),
                creationDate: Date.now.dateFromDays(-11),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[0].id,
                repeatPref: RepeatPreferences(rule: .daily)
            ),
            
            Task(
                id: .auto(),
                name: "Today 2",
                datePrefences: DatePreferences(assumedDate: Date.now.noon, isAllDay: false),
                creationDate: Date.now.dateFromDays(-8),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[1].id,
                repeatPref: RepeatPreferences(rule: .weekly, daysOfWeek: [2, 4, 6], endDate: Date.now.tomorrow)
            ),
            
            Task(
                id: .auto(),
                name: "Today 3",
                datePrefences: DatePreferences(assumedDate: Date.now.evening, isAllDay: false),
                creationDate: Date.now.dateFromDays(-7),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[2].id,
                repeatPref: RepeatPreferences()
            ),
            
            Task(
                id: .auto(),
                name: "Today 4",
                datePrefences: DatePreferences(assumedDate: Date.now.endOfDay, isAllDay: false),
                creationDate: Date.now.dateFromDays(-4),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[3].id,
                repeatPref: RepeatPreferences()
            ),
            
            Task(
                id: .auto(),
                name: "Today Now",
                datePrefences: DatePreferences(assumedDate: Date.now, isAllDay: false),
                creationDate: Date.now,
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[4].id,
                repeatPref: RepeatPreferences()
            ),
            
            Task(
                id: .auto(),
                name: "Tomorrow 1",
                datePrefences: DatePreferences(assumedDate: Date.now.tomorrow.startOfDay, isAllDay: false),
                creationDate: Date.now.dateFromDays(-11),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[0].id,
                repeatPref: RepeatPreferences(rule: .daily)
            ),
            
            Task(
                id: .auto(),
                name: "Tomorrow 2",
                datePrefences: DatePreferences(assumedDate: Date.now.tomorrow.morning, isAllDay: true),
                creationDate: Date.now.dateFromDays(-8),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[1].id,
                repeatPref: RepeatPreferences(rule: .weekly, daysOfWeek: [3, 5, 7], endDate: Date.now.nextMonth)
            ),
            
            Task(
                id: .auto(),
                name: "Tomorrow 3",
                datePrefences: DatePreferences(assumedDate: Date.now.tomorrow.noon, isAllDay: false),
                creationDate: Date.now.dateFromDays(-7),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[2].id,
                repeatPref: RepeatPreferences()
            ),
            
            Task(
                id: .auto(),
                name: "Tomorrow 4",
                datePrefences: DatePreferences(assumedDate: Date.now.tomorrow.evening, isAllDay: true),
                creationDate: Date.now.dateFromDays(-4),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[3].id,
                repeatPref: RepeatPreferences()
            ),
            
            Task(
                id: .auto(),
                name: "Tomorrow 5",
                datePrefences: DatePreferences(assumedDate: Date.now.tomorrow, isAllDay: false),
                creationDate: Date.now,
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[4].id,
                repeatPref: RepeatPreferences()
            ),
            
            Task(
                id: .auto(),
                name: "Upcoming 1",
                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(10), isAllDay: false),
                creationDate: Date.now.dateFromDays(-11),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[0].id,
                repeatPref: RepeatPreferences(rule: .daily)
            ),
            
            Task(
                id: .auto(),
                name: "Upcoming 2",
                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(8), isAllDay: false),
                creationDate: Date.now.dateFromDays(-8),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[1].id,
                repeatPref: RepeatPreferences(rule: .monthly, daysOfWeek: [1, 3, 5], endDate: nil)
            ),
            
            Task(
                id: .auto(),
                name: "Upcoming 3",
                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(6), isAllDay: true),
                creationDate: Date.now.dateFromDays(-7),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[2].id,
                repeatPref: RepeatPreferences()
            ),
            
            Task(
                id: .auto(),
                name: "Upcoming 4",
                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(3), isAllDay: false),
                creationDate: Date.now.dateFromDays(-4),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[3].id,
                repeatPref: RepeatPreferences()
            ),
            
            Task(
                id: .auto(),
                name: "Upcoming 5",
                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(2), isAllDay: true),
                creationDate: Date.now,
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[4].id,
                repeatPref: RepeatPreferences()
            ),
            
            Task(
                id: .auto(),
                name: "Unplanned 1",
                datePrefences: DatePreferences(assumedDate: nil, isAllDay: false),
                creationDate: Date.now.dateFromDays(-11),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[0].id,
                repeatPref: RepeatPreferences()
            ),
            
            Task(
                id: .auto(),
                name: "Unplanned 2",
                datePrefences: DatePreferences(assumedDate: nil, isAllDay: false),
                creationDate: Date.now.dateFromDays(-8),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[1].id,
                repeatPref: RepeatPreferences()
            ),
            
            Task(
                id: .auto(),
                name: "Unplanned 3",
                datePrefences: DatePreferences(assumedDate: nil, isAllDay: true),
                creationDate: Date.now.dateFromDays(-7),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[2].id,
                repeatPref: RepeatPreferences()
            ),
            
            Task(
                id: .auto(),
                name: "Unplanned 4",
                datePrefences: DatePreferences(assumedDate: nil, isAllDay: false),
                creationDate: Date.now.dateFromDays(-4),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[3].id,
                repeatPref: RepeatPreferences()
            ),
            
            Task(
                id: .auto(),
                name: "Unplanned 5",
                datePrefences: DatePreferences(assumedDate: nil, isAllDay: true),
                creationDate: Date.now,
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[4].id,
                repeatPref: RepeatPreferences()
            ),
            
            Task(
                id: .auto(),
                name: "Completed 1",
                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(-10), isAllDay: false),
                creationDate: Date.now.dateFromDays(-11),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[0].id,
                repeatPref: RepeatPreferences(),
                completionDate: Date.now.dateFromDays(-9)
            ),
            
            Task(
                id: .auto(),
                name: "Completed 2",
                datePrefences: DatePreferences(assumedDate: Date.now.morning, isAllDay: true),
                creationDate: Date.now.dateFromDays(-8),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[1].id,
                repeatPref: RepeatPreferences(),
                completionDate: Date.now.yesterday.morning
            ),
            
            Task(
                id: .auto(),
                name: "Completed 3",
                datePrefences: DatePreferences(assumedDate: Date.now.tomorrow.noon, isAllDay: false),
                creationDate: Date.now.dateFromDays(-7),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[2].id,
                repeatPref: RepeatPreferences(),
                completionDate: Date.now.yesterday.noon
            ),
            
            Task(
                id: .auto(),
                name: "Completed 4",
                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(3), isAllDay: false),
                creationDate: Date.now.dateFromDays(-4),
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[3].id,
                repeatPref: RepeatPreferences(),
                completionDate: Date.now.yesterday.evening
            ),
            
            Task(
                id: .auto(),
                name: "Completed ",
                datePrefences: DatePreferences(assumedDate: nil, isAllDay: true),
                creationDate: Date.now,
                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
                idGroup: allGroups[4].id,
                repeatPref: RepeatPreferences(),
                completionDate: Date.now
            )
//            Task(
//                id: .auto(),
//                name: "Overdue 1",
//                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(-10), isAllDay: false),
//                creationDate: Date.now.dateFromDays(-11),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: Date.now.dateFromDays(-11), relativeOffset: 0)),
//                idGroup: allGroups[0].id,
//                repeatPref: RepeatPreferences(rule: .daily)
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Overdue 2",
//                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(-8), isAllDay: false),
//                creationDate: Date.now.dateFromDays(-8),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[1].id,
//                repeatPref: RepeatPreferences(rule: .weekly, daysOfWeek: [1, 3, 5], endDate: Date.now)
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Overdue 3",
//                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(-6), isAllDay: true),
//                creationDate: Date.now.dateFromDays(-7),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[2].id,
//                repeatPref: RepeatPreferences(rule: .monthly)
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Overdue 4",
//                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(-3), isAllDay: false),
//                creationDate: Date.now.dateFromDays(-4),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[3].id,
//                repeatPref: RepeatPreferences()
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Overdue 5",
//                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(-1), isAllDay: true),
//                creationDate: Date.now,
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[4].id,
//                repeatPref: RepeatPreferences()
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Today 1",
//                datePrefences: DatePreferences(assumedDate: Date.now.startOfDay, isAllDay: false),
//                creationDate: Date.now.dateFromDays(-11),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[0].id,
//                repeatPref: RepeatPreferences(rule: .daily)
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Today 2",
//                datePrefences: DatePreferences(assumedDate: Date.now.noon, isAllDay: false),
//                creationDate: Date.now.dateFromDays(-8),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[1].id,
//                repeatPref: RepeatPreferences(rule: .weekly, daysOfWeek: [2, 4, 6], endDate: Date.now.tomorrow)
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Today 3",
//                datePrefences: DatePreferences(assumedDate: Date.now.evening, isAllDay: false),
//                creationDate: Date.now.dateFromDays(-7),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[2].id,
//                repeatPref: RepeatPreferences()
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Today 4",
//                datePrefences: DatePreferences(assumedDate: Date.now.endOfDay, isAllDay: false),
//                creationDate: Date.now.dateFromDays(-4),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[3].id,
//                repeatPref: RepeatPreferences()
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Today Now",
//                datePrefences: DatePreferences(assumedDate: Date.now, isAllDay: false),
//                creationDate: Date.now,
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[4].id,
//                repeatPref: RepeatPreferences()
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Tomorrow 1",
//                datePrefences: DatePreferences(assumedDate: Date.now.tomorrow.startOfDay, isAllDay: false),
//                creationDate: Date.now.dateFromDays(-11),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[0].id,
//                repeatPref: RepeatPreferences(rule: .daily)
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Tomorrow 2",
//                datePrefences: DatePreferences(assumedDate: Date.now.tomorrow.morning, isAllDay: true),
//                creationDate: Date.now.dateFromDays(-8),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[1].id,
//                repeatPref: RepeatPreferences(rule: .weekly, daysOfWeek: [3, 5, 7], endDate: Date.now.nextMonth)
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Tomorrow 3",
//                datePrefences: DatePreferences(assumedDate: Date.now.tomorrow.noon, isAllDay: false),
//                creationDate: Date.now.dateFromDays(-7),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[2].id,
//                repeatPref: RepeatPreferences()
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Tomorrow 4",
//                datePrefences: DatePreferences(assumedDate: Date.now.tomorrow.evening, isAllDay: true),
//                creationDate: Date.now.dateFromDays(-4),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[3].id,
//                repeatPref: RepeatPreferences()
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Tomorrow 5",
//                datePrefences: DatePreferences(assumedDate: Date.now.tomorrow, isAllDay: false),
//                creationDate: Date.now,
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[4].id,
//                repeatPref: RepeatPreferences()
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Upcoming 1",
//                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(10), isAllDay: false),
//                creationDate: Date.now.dateFromDays(-11),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[0].id,
//                repeatPref: RepeatPreferences(rule: .daily)
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Upcoming 2",
//                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(8), isAllDay: false),
//                creationDate: Date.now.dateFromDays(-8),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[1].id,
//                repeatPref: RepeatPreferences(rule: .monthly, daysOfWeek: [1, 3, 5], endDate: nil)
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Upcoming 3",
//                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(6), isAllDay: true),
//                creationDate: Date.now.dateFromDays(-7),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[2].id,
//                repeatPref: RepeatPreferences()
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Upcoming 4",
//                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(3), isAllDay: false),
//                creationDate: Date.now.dateFromDays(-4),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[3].id,
//                repeatPref: RepeatPreferences()
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Upcoming 5",
//                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(2), isAllDay: true),
//                creationDate: Date.now,
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[4].id,
//                repeatPref: RepeatPreferences()
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Unplanned 1",
//                datePrefences: DatePreferences(assumedDate: nil, isAllDay: false),
//                creationDate: Date.now.dateFromDays(-11),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[0].id,
//                repeatPref: RepeatPreferences()
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Unplanned 2",
//                datePrefences: DatePreferences(assumedDate: nil, isAllDay: false),
//                creationDate: Date.now.dateFromDays(-8),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[1].id,
//                repeatPref: RepeatPreferences()
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Unplanned 3",
//                datePrefences: DatePreferences(assumedDate: nil, isAllDay: true),
//                creationDate: Date.now.dateFromDays(-7),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[2].id,
//                repeatPref: RepeatPreferences()
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Unplanned 4",
//                datePrefences: DatePreferences(assumedDate: nil, isAllDay: false),
//                creationDate: Date.now.dateFromDays(-4),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[3].id,
//                repeatPref: RepeatPreferences()
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Unplanned 5",
//                datePrefences: DatePreferences(assumedDate: nil, isAllDay: true),
//                creationDate: Date.now,
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[4].id,
//                repeatPref: RepeatPreferences()
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Completed 1",
//                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(-10), isAllDay: false),
//                creationDate: Date.now.dateFromDays(-11),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[0].id,
//                repeatPref: RepeatPreferences(),
//                completionDate: Date.now.dateFromDays(-9)
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Completed 2",
//                datePrefences: DatePreferences(assumedDate: Date.now.morning, isAllDay: true),
//                creationDate: Date.now.dateFromDays(-8),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[1].id,
//                repeatPref: RepeatPreferences(),
//                completionDate: Date.now.yesterday.morning
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Completed 3",
//                datePrefences: DatePreferences(assumedDate: Date.now.tomorrow.noon, isAllDay: false),
//                creationDate: Date.now.dateFromDays(-7),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[2].id,
//                repeatPref: RepeatPreferences(),
//                completionDate: Date.now.yesterday.noon
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Completed 4",
//                datePrefences: DatePreferences(assumedDate: Date.now.dateFromDays(3), isAllDay: false),
//                creationDate: Date.now.dateFromDays(-4),
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[3].id,
//                repeatPref: RepeatPreferences(),
//                completionDate: Date.now.yesterday.evening
//            ),
//
//            Task(
//                id: .auto(),
//                name: "Completed 5",
//                datePrefences: DatePreferences(assumedDate: nil, isAllDay: true),
//                creationDate: Date.now,
//                reminderConfig: Reminder(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0)),
//                idGroup: allGroups[4].id,
//                repeatPref: RepeatPreferences(),
//                completionDate: Date.now
//            )
            ].reduce(into: []) { (result, item) in
                var task = item
                task.notes = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
                result.append(task)
        }
    }
    
    public func devGroups() -> [Group] {
        let calendar = Calendar.current
        return [
            Group(
                id: .auto(),
                name: "Inbox",
                isDefault: true,
                creationDate: calendar.taskem_dateFromDays(Date.now, days: -10),
                icon: Icon(Images.Lists.icEmailinbox),
                color: Color.TaskemLists.blue.color
            ),
                
            Group(
                id: .auto(),
                name: "Habits",
                isDefault: false,
                creationDate: calendar.taskem_dateFromDays(Date.now, days: -7),
                icon: Icon(Images.Lists.icBuddhistYogaPose),
                color: Color.TaskemLists.blueDark.color
            ),
            
            Group(
                id: .auto(),
                name: "Study",
                isDefault: false,
                creationDate: calendar.taskem_dateFromDays(Date.now, days: -6),
                icon: Icon(Images.Lists.icCollegeGraduation),
                color: Color.TaskemLists.blueDeep.color
            ),
            
            Group(
                id: .auto(),
                name: "House",
                isDefault: false,
                creationDate: calendar.taskem_dateFromDays(Date.now, days: -5),
                icon: Icon(Images.Lists.icOpenBook),
                color: Color.TaskemLists.green.color
            ),
            
            Group(
                id: .auto(),
                name: "Work",
                isDefault: false,
                creationDate: calendar.taskem_dateFromDays(Date.now, days: -4),
                icon: Icon(Images.Lists.icBriefcase),
                color: Color.TaskemLists.grey.color
            ),
            
            Group(
                id: .auto(),
                name: "Places to visit",
                isDefault: false,
                creationDate: calendar.taskem_dateFromDays(Date.now, days: -2),
                icon: Icon(Images.Lists.icAirTransport),
                color: Color.TaskemLists.greyDark.color
            ),
            
            Group(
                id: .auto(),
                name: "Glocery",
                isDefault: false,
                creationDate: Date.now,
                icon: Icon(Images.Lists.icShoppingCart),
                color: Color.TaskemLists.orange.color
            ),
            
            Group(
                id: .auto(),
                name: "Music",
                isDefault: false,
                creationDate: Date.now,
                icon: Icon(Images.Lists.icMusicPlayer),
                color: Color.TaskemLists.yellow.color
            ),
            
            Group(
                id: .auto(),
                name: "Medicine",
                isDefault: false,
                creationDate: Date.now,
                icon: Icon(Images.Lists.icDrugs),
                color: Color.TaskemLists.green.color
            )
        ]
    }
}
