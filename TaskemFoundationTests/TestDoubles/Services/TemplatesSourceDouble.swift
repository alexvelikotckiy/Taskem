//
//  TemplatesSourceDouble.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/22/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class TemplatesSourceMock: TemplatesSource {
    var defaultTemplateMock: PredefinedProject!
    var additionalTemplatesMock: [PredefinedProject] = []
    
    func defaultTemplate() -> PredefinedProject {
        return defaultTemplateMock
    }

    func additionalTemplates() -> [PredefinedProject] {
        return additionalTemplatesMock
    }
}

class TemplatesSourceStub: TemplatesSource {
    func defaultTemplate() -> PredefinedProject {
        return inboxTemplate()
    }
    
    func additionalTemplates() -> [PredefinedProject] {
        return [
            importantTemplate(),
            todoTemplate()
        ]
    }
    
    private func inboxTemplate() -> PredefinedProject {
        let inbox = Group(
            id: .auto(),
            name: "Inbox",
            isDefault: true,
            creationDate: Date.now,
            icon: Icon(Images.Lists.icEmailinbox),
            color: Color.defaultColor
        )
        
        let inboxTasks: [Task] = [
            Task(
                id: .auto(),
                name: "Task 1",
                datePrefences: DatePreferences(assumedDate: Date.now, isAllDay: true),
                creationDate: Date.now,
                reminderConfig: Reminder(),
                idGroup: inbox.id,
                repeatPref: RepeatPreferences()
            ),
            Task(
                id: .auto(),
                name: "Task 2",
                datePrefences: DatePreferences(assumedDate: Date.now.addingTimeInterval(60), isAllDay: false),
                creationDate: Date.now.tomorrow,
                reminderConfig: Reminder(),
                idGroup: inbox.id,
                repeatPref: RepeatPreferences()
            ),
            
            Task(
                id: .auto(),
                name: "Task 3",
                datePrefences: DatePreferences(assumedDate: Date.now.addingTimeInterval(120), isAllDay: false),
                creationDate: Date.now.tomorrow,
                reminderConfig: Reminder(),
                idGroup: inbox.id,
                repeatPref: RepeatPreferences()
            ),
            
            Task(
                id: .auto(),
                name: "Task 4",
                datePrefences: DatePreferences(assumedDate: Date.now.tomorrow, isAllDay: false),
                creationDate: Date.now,
                reminderConfig: Reminder(),
                idGroup: inbox.id,
                repeatPref: RepeatPreferences()
            ),
            
            Task(
                id: .auto(),
                name: "Task 5",
                datePrefences: DatePreferences(assumedDate: Date.now.yesterday, isAllDay: true),
                creationDate: Date.now,
                reminderConfig: Reminder(),
                idGroup: inbox.id,
                repeatPref: RepeatPreferences()
            ),
            
            ]
        
        return PredefinedProject(group: inbox, tasks: inboxTasks)
    }
    
    private func importantTemplate() -> PredefinedProject {
        let important = Group(
            id: .auto(),
            name: "Important",
            isDefault: false,
            creationDate: Date.now,
            icon: "icon_books",
            color: Color.defaultColor
        )
        
        let importantTasks: [Task] = [
            
        ]
        
        return PredefinedProject(group: important, tasks: importantTasks)
    }
    
    private func todoTemplate() -> PredefinedProject {
        let todo = Group(
            id: .auto(),
            name: "Todo",
            isDefault: false,
            creationDate: Date.now,
            icon: "icon_computer",
            color: Color.defaultColor
        )
        
        let todoTasks: [Task] = [
            
        ]
        
        return PredefinedProject(group: todo, tasks: todoTasks)
    }
}
