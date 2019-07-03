//
//  PredefinedProject.swift
//  TaskemFoundation
//
//  Created by Wilson on 10.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct PredefinedProject: Equatable {
    public let group: Group
    public let tasks: [Task]

    public init(group: Group, tasks: [Task]) {
        self.group = group
        self.tasks = tasks
    }
}

extension PredefinedProject: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(group.hashValue)
    }
}
