//
//  TaskEntity.swift
//  Taskem
//
//  Created by Wilson on 11.11.2017.
//  Copyright © 2017 Wilson. All rights reserved.
//

import Foundation

public struct Task: Codable, Identifiable, Equatable {
    public var id: EntityId
    public var name: String
    public var creationDate: Date
    public var idGroup: EntityId
    public var repeatPreferences: RepeatPreferences
    public var notes: String

    public private(set) var reminder: Reminder
    public private(set) var datePreference: DatePreferences
    public private(set) var completionDate: Date?
    
    public init(
        idGroup: EntityId
        ) {
        self.id = .auto()
        self.name = ""
        self.reminder = .init()
        self.datePreference = .init()
        self.creationDate = .init()
        self.idGroup = idGroup
        self.repeatPreferences = .init()
        self.completionDate = nil
        self.notes = ""
    }

    public init(
        id: EntityId,
        name: String,
        datePrefences: DatePreferences,
        creationDate: Date,
        reminderConfig: Reminder,
        idGroup: EntityId,
        repeatPref: RepeatPreferences,
        notes: String = "",
        completionDate: Date? = nil
        ) {
        self.id = id
        self.name = name
        self.reminder = reminderConfig
        self.datePreference = datePrefences
        self.creationDate = creationDate
        self.idGroup = idGroup
        self.repeatPreferences = repeatPref
        self.notes = notes
        self.completionDate = completionDate
    }
    
    public var isOverdue: Bool {
        if completionDate == nil && datePreference.date != nil {
            if datePreference.isAllDay {
                return datePreference.date! < Date.now.startOfDay
            } else {
                return datePreference.date! < Date.now
            }
        }
        return false
    }

    public var isAllDay: Bool {
        return datePreference.isAllDay
    }
    
    public var isComplete: Bool {
        return completionDate != nil
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case creationDate
        case idGroup
        case repeatPreferences
        case notes
        case reminder
        case datePreference
        case completionDate
    }
}

extension Task: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public extension Task {
    mutating func modify(repeat rule: RepeatRule) {
        repeatPreferences.change(rule: rule)
    }
    
    mutating func modify(remind rule: ReminderRule) {
        reminder.trigger.validate(isAllDay: datePreference.isAllDay)
        reminder.trigger.change(absoluteDate: datePreference.date, rule: rule)
    }
    
    mutating func modify(remind trigger: ReminderTrigger) {
        reminder.trigger = trigger
        reminder.trigger.validate(isAllDay: datePreference.isAllDay)
        reminder.trigger.change(absoluteDate: datePreference.date)
    }
    
    mutating func modify(idGroup: EntityId) {
        self.idGroup = idGroup
    }
    
    mutating func modify(assumedDate: Date?) {
        modify(datePreferences: .init(assumedDate: assumedDate, isAllDay: isAllDay))
    }
    
    mutating func modify(complete: Bool, considerRepeat: Bool = true) {
        guard isComplete != complete else { return }
        
        switch (complete, considerRepeat) {
        case (true, true):
            guard let last = self.datePreference.occurrenceDate,
                let first = self.datePreference.firstOccurrenceDate,
                let nextRepeat = self.repeatPreferences.nextRepeatDate(firstTrack: first, currentTrack: last) else { fallthrough }
            
            var datePreferences = self.datePreference
            datePreferences.date = nextRepeat
            
            modify(datePreferences: datePreferences)
            
        default:
            completionDate = complete ? Date.now : nil
        }
    }
    
    mutating func modify(datePreferences: DatePreferences) {
        // Resolve next remind trigger
        switch true {
        case reminder.trigger.absoluteDate == nil:
            break
            
        case self.datePreference.isAllDay != datePreferences.isAllDay:
            guard let relativeDifference = self.datePreference.difference(to: datePreferences) else { fallthrough }
            
            let relativeOffset = relativeDifference - reminder.relativeOffset
            reminder.trigger = .init(absoluteDate: datePreferences.date, relativeOffset: relativeOffset)
            
        default:
            reminder.trigger.validate(isAllDay: datePreferences.isAllDay)
            reminder.trigger.change(absoluteDate: datePreferences.date)
        }
        //
        self.datePreference = datePreferences
    }
}

public extension Task {
    func change(repeat rule: RepeatRule) -> Task {
        return modify {
            $0.modify(repeat: rule)
        }
    }
    
    func change(remind rule: ReminderRule) -> Task {
        return modify {
            $0.modify(remind: rule)
        }
    }
    
    func change(remind trigger: ReminderTrigger) -> Task {
        return modify {
            $0.modify(remind: trigger)
        }
    }
    
    func change(assumedDate: Date?) -> Task {
        return modify {
            $0.modify(assumedDate: assumedDate)
        }
    }
    
    func change(complete: Bool, considerRepeat: Bool = true) -> Task {
        return modify {
            $0.modify(complete: complete, considerRepeat: considerRepeat)
        }
    }
    
    func change(datePreferences: DatePreferences) -> Task {
        return modify {
            $0.modify(datePreferences: datePreferences)
        }
    }

    func change(idGroup: EntityId) -> Task {
        return modify {
            $0.modify(idGroup: idGroup)
        }
    }
}

public extension Array where Element == Task {
    func changeToogleCompletion(considerRepeat: Bool = true) -> [Element] {
        return map {
            $0.change(complete: !$0.isComplete, considerRepeat: considerRepeat)
        }
    }
    
    func change(complete: Bool, considerRepeat: Bool = true) -> [Element] {
        return map {
            $0.change(complete: complete, considerRepeat: considerRepeat)
        }
    }
    
    func change(datePreferences: DatePreferences) -> [Element] {
        return map {
            $0.change(datePreferences: datePreferences)
        }
    }
    
    func change(idGroup: EntityId) -> [Element] {
        return map {
            $0.change(idGroup: idGroup)
        }
    }
}

public extension Task {
    mutating func modify(status: ScheduleSection, considerRepeat: Bool = true) {
        switch status {
        case .overdue:
//            assert(false, "Unsupported modification")
            return
        case .complete:
            modify(complete: true, considerRepeat: considerRepeat)
        case .unplanned:
            modify(assumedDate: nil)
            modify(complete: false, considerRepeat: considerRepeat)
        case .today, .tomorrow, .upcoming:
            modify(assumedDate: ScheduleSection.statusToDate(status: status)!)
            modify(complete: false, considerRepeat: considerRepeat)
        }
    }
    
    mutating func modify(status: ScheduleFlatSection, considerRepeat: Bool = true) {
        switch status {
        case .uncomplete:
            modify(complete: false, considerRepeat: considerRepeat)
            break
        case .complete:
            modify(complete: true, considerRepeat: considerRepeat)
        }
    }
}

public extension Task {
    func change(status: ScheduleSection, considerRepeat: Bool = true) -> Task {
        return modify {
            $0.modify(status: status, considerRepeat: considerRepeat)
        }
    }
    
    func change(status: ScheduleFlatSection, considerRepeat: Bool = true) -> Task {
        return modify {
            $0.modify(status: status, considerRepeat: considerRepeat)
        }
    }
}

fileprivate extension Task {
    func modify(_ setup: (inout Task) -> Void) -> Task {
        var mutable = self
        setup(&mutable)
        return mutable
    }
}

//#if TESTING
public extension Task {
    var test_reminder: Reminder {
        get { return reminder }
        set { reminder = newValue }
    }
    var test_datePreference: DatePreferences {
        get { return datePreference }
        set { datePreference = newValue }
    }
    var test_completionDate: Date? {
        get { return completionDate }
        set { completionDate = newValue }
    }
}
//#endif
