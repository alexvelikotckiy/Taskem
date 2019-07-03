//
//  ScheduleControlFactory.swift
//  TaskemFoundation
//
//  Created by Wilson on 8/10/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

extension ScheduleControlPresenter: ViewModelFactory {
    public func produce<T>(from context: Context) -> T? {
        switch true {
        case T.self == ScheduleControlListViewModel.self:
            let value: ScheduleControlListViewModel = produce(context)
            return value as? T

        case T.self == [ScheduleControlSectionViewModel].self:
            let value: [ScheduleControlSectionViewModel] = produce(context)
            return value as? T

        default:
            return nil
        }
    }

    public struct Context: Equatable {
        public var groups: [Group]
        public var tasks: [Task]
        public var editing: Bool
        public var info: GroupsInfo

        public init(groups: [Group],
                    tasks: [Task],
                    editing: Bool,
                    info: GroupsInfo) {
            self.groups = groups.uniqueElements
            self.tasks = tasks.uniqueElements
            self.editing = editing
            self.info = info
        }

        fileprivate func group(by id: EntityId) -> Group? {
            return groups.first(where: { $0.id == id })
        }

        fileprivate func task(in group: Group) -> Set<Task> {
            return tasks.filter { $0.idGroup == group.id }.set
        }
    }
}

private extension ScheduleControlPresenter {
    func produce(_ context: Context) -> ScheduleControlListViewModel {
        return .init(
            sections: produce(context),
            editing: context.editing
        )
    }
    
    func produce(_ context: Context) -> [ScheduleControlSectionViewModel] {
        return [.init(cells: wrapToModel(context))]
    }
    
    func wrapToModel(_ context: Context) -> [ScheduleControlViewModel] {
        return context.info.order.reduce(into: []) { result, id in
            guard let group = context.group(by: id) else { return }
            
            result.append(.init(group, context.task(in: group), isSelected(id: id)))
        }
    }
    
    func isSelected(id: EntityId) -> Bool {
        switch config.selectedProjects.isEmpty {
        case true:
            return false
        case false:
            return config.selectedProjects.contains(id)
        }
    }
}

fileprivate extension ScheduleControlViewModel {
    init(
        _ group: Group,
        _ tasks: Set<Task>,
        _ selected: Bool
        ) {
        self.init(
            group: group,
            tasks: tasks,
            isSelected: selected
        )
    }
}
