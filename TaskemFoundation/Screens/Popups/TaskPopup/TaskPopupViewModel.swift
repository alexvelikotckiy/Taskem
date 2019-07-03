//
//  TaskPopupViewModel.swift
//  Taskem
//
//  Created by Wilson on 12/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

open class TaskPopupViewModel {
    open var name: String
    open var tags: [TaskPopupTagViewModel]

    public init() {
        self.name = ""
        self.tags = []
    }

    public init(name: String, tags: [TaskPopupTagViewModel]) {
        self.name = name
        self.tags = tags
    }
    
    public var currentDateAntTime: DatePreferences? {
        return get { $0.isDateAndTimeTag }?.unwrap()
    }
    
    public var currentProject: Group? {
        return get { $0.isProjectTag }?.unwrap()
    }
    
    public var currentReminder: Reminder? {
        return get { $0.isReminderTag }?.unwrap()
    }
    
    public var currentRepetition: RepeatPreferences? {
        return get { $0.isRepetitionTag }?.unwrap()
    }
    
    public func remove(_ predicate: (TaskPopupTagViewModel) -> Bool) {
        tags.removeAll(where: predicate)
    }
    
    public func updateOrInsert(_ model: TaskPopupTagViewModel) {
        var wasUpdate = false
        
        for pair in tags.enumerated() {
            switch (model.tag, pair.element.tag) {
            case (.project,     .project),
                 (.dateAndTime, .dateAndTime),
                 (.repetition,  .repetition),
                 (.reminder,    .reminder):

                tags[pair.offset] = model
                wasUpdate = true

            default:
                continue
            }
        }
        
        if !wasUpdate {
            tags.append(model)
        }
    }
    
    public func set(_ value: TaskPopupTagViewModel, _ predicate: (TaskPopupTagViewModel) -> Bool) {
        guard let index = tags.firstIndex(where: predicate) else { return }
        tags[index] = value
    }
    
    private func get(_ predicate: (TaskPopupTagViewModel.Tag) -> Bool) -> TaskPopupTagViewModel.Tag? {
        for model in tags where predicate(model.tag) {
            return model.tag
        }
        return nil
    }
 }

public struct TaskPopupTagViewModel: Equatable {
    public var tag: Tag
    public var color: Color
    public var title: String
    
    public init(tag: Tag,
                color: Color,
                title: String) {
        self.tag = tag
        self.title = title
        self.color = color
    }

    public var removable: Bool {
        return tag.canRemove
    }
    
    public enum Tag: Equatable {
        case project(Group)
        case dateAndTime(DatePreferences)
        case reminder(Reminder)
        case repetition(RepeatPreferences)
        
        public var isProjectTag: Bool {
            switch self {
            case .project:
                return true
            default:
                return false
            }
        }
        
        public var isDateAndTimeTag: Bool {
            switch self {
            case .dateAndTime:
                return true
            default:
                return false
            }
        }
        
        public var isReminderTag: Bool {
            switch self {
            case .reminder:
                return true
            default:
                return false
            }
        }
        
        public var isRepetitionTag: Bool {
            switch self {
            case .repetition:
                return true
            default:
                return false
            }
        }
        
        public var canRemove: Bool {
            switch self {
            case .project:
                return false
            default:
                return true
            }
        }
        
        public func unwrap() -> Group? {
            guard case let .project(value) = self else { return nil }
            return value
        }
        
        public func unwrap() -> DatePreferences? {
            guard case let .dateAndTime(value) = self else { return nil }
            return value
        }
        
        public func unwrap() -> Reminder? {
            guard case let .reminder(value) = self else { return nil }
            return value
        }
        
        public func unwrap() -> RepeatPreferences? {
            guard case let .repetition(value) = self else { return nil }
            return value
        }
    }
}
