//
//  ScheduleViewModel.swift
//  Taskem
//
//  Created by Wilson on 23.12.2017.
//  Copyright © 2017 Wilson. All rights reserved.
//

import UIKit

public struct TaskModel: Identifiable, Hashable {
    public var task: Task
    
    public var group: Group {
        didSet {
            task.idGroup = group.id
        }
    }

    public init(task: Task,
                group: Group) {
        self.task = task
        self.group = group
    }

    public var idTask: String {
        return task.id
    }
    
    public var id: EntityId {
        return idTask
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(idTask)
    }

    public var name: String {
        get { return task.name }
        set { task.name = newValue }
    }

    public var reiteration: RepeatPreferences {
        get { return task.repeatPreferences }
        set { task.repeatPreferences = newValue }
    }
    
    public var notes: String {
        get { return task.notes }
        set { task.notes = newValue }
    }
    
    public var datePreference: DatePreferences {
        return task.datePreference
    }

    public var estimateDate: Date? {
        return task.datePreference.date
    }

    public var isAllDay: Bool {
        return task.datePreference.isAllDay
    }

    public var isComplete: Bool {
        return task.completionDate != nil
    }

    public var completionDate: Date? {
        return task.completionDate
    }

    public var groupName: String {
        return group.name
    }

    public var creationDate: Date {
        return task.creationDate
    }

    public var idGroup: String {
        return self.group.id
    }

    public var projectColor: Color {
        return group.color
    }
    
    public var reminder: Reminder {
        return task.reminder
    }
}

public extension TaskModel {
    var color: Color {
        return ColorCalculator.colorFlag(for: task)
    }

    var timeFormatted: String? {
        if !task.datePreference.isAllDay,
            let date = task.datePreference.occurrenceDate {
            let dateFormatted = DateFormatter()
            dateFormatted.dateStyle = .none
            dateFormatted.timeStyle = .short
            return dateFormatted.string(from: date)
        }
        return nil
    }

    var dateFormatted: String? {
        if let date = task.datePreference.occurrenceDate {
            let dateFormatter = DateFormatter()
            if task.datePreference.isAllDay {
                dateFormatter.timeStyle = .none
                dateFormatter.dateStyle = .medium
            } else {
                dateFormatter.timeStyle = .short
                dateFormatter.dateStyle = .medium
            }
            return dateFormatter.string(from: date)
        }
        return nil
    }
}

public extension TaskModel {
    var status: ScheduleSection {
        if task.isComplete {
            return .complete
        } else {
            return ScheduleSection.dateToStatus(date: task.datePreference.date)
        }
    }

    var flatStatus: ScheduleFlatSection {
        return task.isComplete ? .complete : .uncomplete
    }

    var completedStatus: CompletedStatus? {
        if let completionDate = self.completionDate {
            if completionDate >= DateProvider.current.now.yesterday {
                return .recent
            } else {
                return .old
            }
        }
        return nil
    }
}

public extension Array where Element == Task {
    func compose(with lists: [Group]) -> [TaskModel] {
        return lists.map { value in
             return self
                .filter { $0.idGroup == value.id }
                .map { TaskModel(task: $0, group: value) }
        }.flatMap { $0 }
    }
}
