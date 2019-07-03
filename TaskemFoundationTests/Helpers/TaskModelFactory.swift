//
//  TaskModelFactory.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

struct TaskModelFactory {
    func make(from task: Task) -> TaskModel {
        return .init(task: task, group: GroupFactory().make())
    }
}
