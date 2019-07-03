//
//  ScheduleDataUpdater.swift
//  TaskemFoundation
//
//  Created by Wilson on 3/24/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

fileprivate typealias Cell = ScheduleCellViewModel

extension SchedulePresenter: TableDataCoordinator {
    
    private var list: ScheduleListViewModel {
        return view?.viewModel ?? .init()
    }
    
    public func makeUpdate<T>(newCell: T) -> Update<Any>? {
        guard let newCell = wrap(newCell),
            let oldCell = list[newCell.id] else { return nil }
        return .make(new: newCell, old: oldCell)
    }
    
    public func contain<T>(_ cell: T) -> Bool {
        guard let cell = wrap(cell),
            index(for: cell) != nil else { return false }
        return true
    }
    
    public func shouldInsert<T>(_ cell: T) -> Bool {
        guard let cell = wrap(cell),
            list[cell] == nil else { return false }
        return shouldUpdate(cell)
    }
    
    public func insertSectionIfNeed<T>(for cell: T) -> Int? {
        guard let cell = wrap(cell),
            let index = insertableSectionIndex(for: cell),
            let section = produceEmptySection(listType: list.type, cell: cell) else { return nil }
        list.insertSection(section, at: index)
        return index
    }
    
    public func shouldMove<T>(_ cell: T) -> Bool {
        guard wrap(cell) != nil else { return false }
        return true
    }
    
    public func shouldRemove<T>(_ cell: T) -> Bool {
        guard wrap(cell) != nil else { return false }
        return true
    }
    
    public func shouldRemove<T>(next predicate: @escaping (T) -> Bool) -> Bool {
        guard predicate as? (Cell) -> Bool != nil else { return false }
        return true
    }
    
    public func shouldRemoveEmptySections() -> Bool {
        return true
    }
    
    public func shouldUpdate<T>(_ cell: T) -> Bool {
        guard let cell = wrap(cell) else { return false }
        let predicate = filterPredicate(sectionType: nil)
        return predicate(cell)
    }
    
    public func index<T>(for cell: T) -> IndexPath? {
        guard let cell = wrap(cell),
            let index = list[cell] else { return nil }
        return index
    }
    
    public func insert<T>(_ cell: T) -> IndexPath? {
        guard let cell = wrap(cell),
            let section = list.indexOfSection(for: cell) else { return nil }
        let index = insertableIndex(for: cell, in: section)
        list.insertCell(cell, at: index)
        return index
    }
    
    public func update<T>(_ cell: T) -> IndexPath? {
        guard let cell = wrap(cell),
            let index = index(for: cell) else { return nil }
        list.replace(cell, at: index)
        return index
    }
    
    public func move<T>(_ cell: T) -> (IndexPath, IndexPath)? {
        guard let cell = wrap(cell),
            let removableIndex = remove(cell),
            let insertableIndex = insert(cell) else { return nil }
        return (removableIndex, insertableIndex)
    }
    
    public func remove<T>(_ cell: T) -> IndexPath? {
        guard let cell = wrap(cell),
            let index = index(for: cell) else { return nil }
        list.remove(at: index)
        return index
    }
    
    public func remove<T>(next predicate: @escaping (T) -> Bool) -> IndexPath? {
        guard let predicate = predicate as? (Cell) -> Bool,
            let index = list.indexes(where: predicate).first else { return nil }
        list.remove(at: index)
        return index
    }
    
    public func removeEmptySections() -> IndexSet? {
        var emptySections = IndexSet()
        for (n, section) in list.sections.enumerated() where section.cells.isEmpty {
            emptySections.insert(n)
        }
        list.removeSections(at: emptySections)
        return emptySections
    }
    
    public func isEqual<T>(_ lhs: T, _ rhs: T) -> Bool {
        guard let lhs = wrap(lhs),
            let rhs = wrap(rhs) else { return false }
        return lhs == rhs
    }
}

private extension SchedulePresenter {
    func wrap<T>(_ object: T) -> ScheduleCellViewModel? {
        if let cell = object as? ScheduleCellConvertible {
            return cell.convertToSchedule
        }
        return nil
    }
    
    func insertableIndex(for cell: Cell, in section: Int) -> IndexPath {
        if let index = insertableRowIndex(for: cell, in: section) {
            return .init(row: index, section: section)
        }
        return .init(row: rowsCount(in: section), section: section)
    }
    
    func insertableRowIndex(for cell: Cell, in section: Int) -> Int? {
        return list.sections[section].cells.firstIndex(where: { sortPredicate(cell, $0) })
    }
    
    func rowsCount(in section: Int) -> Int {
        return list.sections[section].cells.count
    }
    
    func insertableSectionIndex(for cell: Cell) -> Int? {
        switch true {
        case list.containSection(for: cell):
            return nil
        case list.sections.isEmpty:
            return 0
        default:
            switch cell {
            case .task(let task):
                return findNextSectionIndex(for: task)
                
            case .time:
                return nil
            }
        }
    }
    
    func findNextSectionIndex(for task: TaskModel) -> Int? {
        for (index, section) in list.sections.enumerated() {
            
            switch section.type {
            case .schedule(let status):
                if isBiggerStatus(status, than: task.status) {
                    return index
                } else if isEndOfListAfter(index) {
                    return index + 1
                }
                
            case .project(let id):
                if isBiggerIdProject(in: id, than: task.idGroup) {
                    return index
                } else if isEndOfListAfter(index) {
                    return index + 1
                }
                
            case .flat(let flatStatus):
                if isBiggerStatus(flatStatus, than: task.flatStatus) {
                    return index
                } else if isEndOfListAfter(index) {
                    return index + 1
                }
            }
        }
        return nil
    }
    
    func isBiggerStatus(_ lhs: ScheduleSection, than rhs: ScheduleSection) -> Bool {
        return lhs > rhs
    }
    
    func isBiggerIdProject(in section: EntityId, than cell: EntityId) -> Bool {
        let order = interactor.sourceGroups.info.order
        
        if let nIndex = order.firstIndex(where: { section == $0 }),
            let cellIndex = order.firstIndex(where: { cell == $0 }),
            nIndex == cellIndex {
            return true
        }
        return false
    }
    
    func isBiggerStatus(_ lhs: ScheduleFlatSection, than rhs: ScheduleFlatSection) -> Bool {
        return lhs > rhs
    }
    
    func isEndOfListAfter(_ index: Int) -> Bool {
        return index + 1 == list.sections.count
    }
}

private extension ScheduleListViewModel {
    
    func indexOfSection(for cell: ScheduleCellViewModel) -> Int? {
        switch cell {
        case .task(let cell):
            switch type {
            case .schedule:
                return sections.firstIndex(where: { $0.type.unwrapSchedule() == cell.status })

            case .project:
                return sections.firstIndex(where: { $0.type.unwrapProject() == cell.idGroup })

            case .flat:
                return sections.firstIndex(where: { $0.type.unwrapFlat() == cell.flatStatus })
            }

        case .time:
            switch type {
            case .schedule:
                return sections.firstIndex(where: { $0.type.unwrapSchedule() == .today })

            case .project:
                return nil

            case .flat:
                return sections.firstIndex(where: { $0.type.unwrapFlat() == .uncomplete })

            }
        }
    }

    func containSection(for cell: ScheduleCellViewModel) -> Bool {
        guard indexOfSection(for: cell) != nil else { return false }
        return true
    }
}

private extension SchedulePresenter {

    func produceEmptySection(listType: ScheduleTableType, cell: ScheduleCellViewModel) -> ScheduleSectionViewModel? {
        switch cell {
            case .task(let cell):
                switch listType {
                case .schedule:
                    return schedule(cell)

                case .project:
                    return project(cell)

                case .flat:
                    return flat(cell)
                }
            case .time:
                return nil
        }
    }

    func schedule(_ model: TaskModel) -> ScheduleSectionViewModel {
        return .init(
            cells: [],
            title: model.status.description,
            type: .schedule(model.status),
            actionType: .action(for: model.status)
        )
    }

    func project(_ model: TaskModel) -> ScheduleSectionViewModel {
        return .init(
            cells: [],
            title: model.groupName,
            type: .project(model.idGroup),
            actionType: .action(for: model.idGroup)
        )
    }

    func flat(_ model: TaskModel) -> ScheduleSectionViewModel {
        return .init(
            cells: [],
            title: model.flatStatus.description,
            type: .flat(model.flatStatus),
            actionType: .action(for: model.flatStatus)
        )
    }
}
