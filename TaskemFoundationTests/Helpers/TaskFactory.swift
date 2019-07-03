//
//  TaskFactory.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/23/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

struct TaskFactory {
    
    func make(
        _ setup: (inout Task) -> Void = { _ in}
        ) -> Task {
        var task = Task(
            id: .auto(),
            name: "Task",
            datePrefences: .init(assumedDate: Date.now, isAllDay: false),
            creationDate: Date.now,
            reminderConfig: .init(),
            idGroup: .auto(),
            repeatPref: .init(),
            notes: "Notes",
            completionDate: nil
        )
        setup(&task)
        return task
    }
}
