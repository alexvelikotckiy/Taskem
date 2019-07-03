//
//  TaskOverviewViewModel.swift
//  Taskem
//
//  Created by Wilson on 01/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public enum TaskOverviewViewModel: Equatable, Identifiable {
    case name(Name)
    case project(Project)
    case dateAndTime(DateAndTime)
    case reminders(Reminder)
    case reiteration(Repeat)
    case notes(Notes)

    public var id: EntityId {
        switch self {
        case .name(_):
            return "name"
        case .project(_):
            return "project"
        case .dateAndTime(_):
            return "dateAndTime"
        case .reminders(_):
            return "reminders"
        case .reiteration(_):
            return "reiteration"
        case .notes(_):
            return "notes"
        }
    }
    
    public struct Name: Equatable {
        public var title: String
        public var placeholder: String
        public var color: Color
        public var checked: Bool

        public init(title: String,
                    placeholder: String,
                    color: Color,
                    checked: Bool
            ) {
            self.title = title
            self.placeholder = placeholder
            self.color = color
            self.checked = checked
        }
        
        public init(model: TaskModel) {
            self.init(
                title: model.name,
                placeholder: "Add a to-do to the \(model.groupName)...",
                color: model.color,
                checked: model.isComplete
            )
        }
        
        public var subtitle: String {
            return "NAME"
        }
    }

    public struct Notes: Equatable {
        public var title: String

        public init(title: String) {
            self.title = title
        }
        
        public init(model: TaskModel) {
            self.init(
                title: model.task.notes
            )
        }
        
        public var subtitle: String {
            return "NOTES"
        }
        
        public var placeholder: String {
            return "Create a note..."
        }
        
        public var icon: Icon {
            return Images.Foundation.icTaskOverviewNotes.icon
        }
    }

    public struct Project: Equatable {
        public var title: String
        public var color: Color
        public var listIcon: Icon
        
        public init(title: String,
                    color: Color,
                    listIcon: Icon
            ) {
            self.title = title
            self.color = color
            self.listIcon = listIcon
        }
        
        public init(model: TaskModel) {
            self.init(
                title: model.groupName,
                color: model.group.color,
                listIcon: model.group.icon
            )
        }
        
        public var subtitle: String {
            return "LIST"
        }
        
        public var icon: Icon {
            return Images.Foundation.icTaskOverviewList.icon
        }
    }
    
    public struct Reminder: Equatable {
        public var title: String
        public var removable = true
        
        public init(title: String) {
            self.title = title
        }
        
        public init(model: TaskModel) {
            if model.reminder.isOn {
                let rule = ReminderRule(reminder: model.reminder)
                switch rule {
                case .customUsingDayTime:
                    self.title = "Reminder on: \(model.reminder.description)"
                default:
                    self.title = model.reminder.description
                }
            } else {
                self.title = "No Reminder"
            }
            self.removable = model.datePreference.date != nil && model.reminder.isOn
        }
        
        public var subtitle: String {
            return "REMINDER"
        }
        
        public var icon: Icon {
            return Images.Foundation.icTaskOverviewReminder.icon
        }
    }
    
    public struct Repeat: Equatable {
        public var title: String
        public var description: String?
        public var removable = true
        
        public init(title: String,
                    description: String?
            ) {
            self.title = title
            self.description = description
        }
        
        public init(model: TaskModel) {
            self.init(
                title: model.reiteration.isOn ? model.reiteration.repeatDescription : "No Repeat",
                description: model.reiteration.isOn ? model.reiteration.endPointDescription : nil
            )
            self.removable = model.datePreference.date != nil && model.reiteration.isOn
        }
        
        public var subtitle: String {
            return "REPEAT"
        }
        
        public var icon: Icon {
            return Images.Foundation.icTaskOverviewRepeat.icon
        }
    }
    
    public struct DateAndTime: Equatable {
        public var title: String
        public var description: String?
        public var removable: Bool
        
        public init(title: String,
                    description: String?,
                    removable: Bool
            ) {
            self.title = title
            self.description = description
            self.removable = removable
        }
        
        public init(model: TaskModel) {
            self.init(
                title: model.datePreference.description,
                description: model.datePreference.endPointDescription,
                removable: model.datePreference.date != nil
            )
        }
        
        public var icon: Icon {
            return Images.Foundation.icTaskOverviewDate.icon
        }
        
        public var subtitle: String {
            return "DATE AND TIME"
        }
    }
}

public class TaskOverviewSectionViewModel: Section {
    public var cells: [TaskOverviewViewModel]
    public var footer: String?

    public init() {
        self.cells = []
    }

    public init(cells: [TaskOverviewViewModel],
                footer: String? = nil) {
        self.cells = cells
        self.footer = footer
    }
}

public class TaskOverviewListViewModel: List {
    public typealias T = TaskOverviewViewModel
    public typealias U = TaskOverviewSectionViewModel
    
    public var sections: [TaskOverviewSectionViewModel]
    public var editing: Bool = false
    
    public var model: TaskViewModel
    internal var initialData: TaskViewModel
    
    public init() {
        self.sections = []
        self.initialData = .new(.init(task: .init(idGroup: ""), group: .init(name: "")))
        self.model = .new(.init(task: .init(idGroup: ""), group: .init(name: "")))
    }
    
    public init(model: TaskViewModel,
                initialData: TaskViewModel,
                editing: Bool,
                sections: [TaskOverviewSectionViewModel]) {
        self.editing = editing
        self.sections = sections
        self.initialData = initialData
        self.model = model
    }
    
    public var isNewTask: Bool {
        return initialData.isNew
    }
    
    public var canDelete: Bool {
        if isNewTask {
            return false
        }
        return true
    }
    
    internal func saveChanges() {
        initialData = model
    }
    
    internal func resetChanges() {
        model = initialData
    }
}
