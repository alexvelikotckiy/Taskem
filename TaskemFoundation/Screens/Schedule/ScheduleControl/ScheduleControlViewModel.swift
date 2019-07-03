//
//  ScheduleControlListViewModel.swift
//  Taskem
//
//  Created by Wilson on 03/01/2018.
//  Copyright © 2018 WIlson. All rights reserved.
//

import Foundation

public struct ScheduleControlViewModel: Equatable, Identifiable {
    public var group: Group
    public var tasks: Set<Task>
    public var isSelected: Bool
    
    public init(group: Group,
                tasks: Set<Task>,
                isSelected: Bool) {
        self.group = group
        self.tasks = tasks
        self.isSelected = isSelected
    }
    
    public var idGroup: String {
        return group.id
    }
    
    public var name: String {
        return group.name
    }

    public var icon: Icon {
        return group.icon
    }

    public var isRemovable: Bool {
        return !group.isDefault
    }
    
    public var id: EntityId {
        return group.id
    }

    public var uncompletedCount: Int {
        return tasks
            .filter { !$0.isComplete }
            .count
    }

    public var overdueCount: Int {
        return tasks
            .filter { !$0.isComplete }
            .compactMap { $0.datePreference.date }
            .filter { $0 < .now }
            .count
    }
}

public class ScheduleControlSectionViewModel: Section {
    public typealias T = ScheduleControlViewModel
    
    public var cells: [ScheduleControlViewModel]
    
    public init(cells: [ScheduleControlViewModel]) {
        self.cells = cells
    }
}

public class ScheduleControlListViewModel: List {
    public typealias T = ScheduleControlViewModel
    public typealias U = ScheduleControlSectionViewModel
    
    public var sections: [ScheduleControlSectionViewModel]
    public var isEditing = false
    
    public init() {
        self.sections = []
    }
    
    public init(sections: [ScheduleControlSectionViewModel],
                editing: Bool) {
        self.sections = sections
        self.isEditing = editing
    }
    
    public var subtitle: String {
        return "TASKS TOTAL \(undoneTasksCount) / \(countAllTasks)"
    }
    
    public var navbarContent: [ScheduleNavbarCell] {
        return allCells.filter { $0.isSelected }.map { .init(group: $0.group) }
    }

    public func deselect(_ cell: ScheduleControlViewModel) {
        guard let index = index(for: cell.id) else { return }
        self[index].isSelected = false
    }

    public var selected: [ScheduleControlViewModel] {
        return allCells.filter { $0.isSelected }
    }
    
    private var countAllTasks: Int {
        return allCells.map { $0.tasks.array }.compactMap { $0 }.flatMap { $0 }.count
    }
    
    private var undoneTasksCount: Int {
        return allCells.filter { $0.isSelected }.map { $0.tasks.array }.compactMap { $0 }.flatMap { $0 }.filter { !$0.isComplete }.uniqueElements.count
    }
}
