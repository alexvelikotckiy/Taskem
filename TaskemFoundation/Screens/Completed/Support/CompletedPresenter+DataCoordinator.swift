//
//  CompletedDataUpdater.swift
//  TaskemFoundation
//
//  Created by Wilson on 3/31/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

extension CompletedPresenter: TableDataCoordinator {
    typealias Cell = CompletedViewModel
    
    private var list: CompletedListViewModel {
        get { return view?.viewModel ?? .init() }
        set { view?.viewModel = newValue }
    }
    
    private func wrap<T>(_ object: T) -> CompletedViewModel? {
        if let cell = object as? CompletedViewModel {
            return cell
        } else if let task = object as? TaskModel {
            return .init(model: task)
        }
        return nil
    }
    
    private func insertableIndex(for cell: Cell, in section: Int) -> IndexPath {
        if let index = list.sections[section].cells.firstIndex(where: { sorting(cell, $0) }) {
            return .init(row: index, section: section)
        }
        return .init(row: list.sections[section].cells.count, section: section)
    }
    
    private func insertableSectionIndex(for cell: Cell) -> Int? {
        guard let status = cell.model.completedStatus,
            !list.containtsSection(for: cell) else { return nil }
        
        if list.sections.isEmpty {
            return 0
        }
        
        for (n, section) in list.sections.enumerated() {
            if section.status.rawValue > status.rawValue {
                return n
            } else if n + 1 == list.sections.count {
                return n + 1
            }
        }
        return nil
    }
    
    public func removeEmptySections() -> IndexSet? {
        var emptySections = IndexSet()
        for (n, section) in list.sections.enumerated() where section.cells.isEmpty {
            emptySections.insert(n)
        }
        list.removeSections(at: emptySections)
        return emptySections
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
    
    public func shouldUpdate<T>(_ cell: T) -> Bool {
        guard let cell = wrap(cell) else { return false }
        return cell.model.isComplete
    }
    
    public func shouldMove<T>(_ cell: T) -> Bool {
        guard wrap(cell) != nil else { return false }
        return true
    }
    
    public func insertSectionIfNeed<T>(for cell: T) -> Int? {
        guard let cell = wrap(cell),
            let status = cell.model.completedStatus,
            let index = insertableSectionIndex(for: cell) else { return nil }
        let section = CompletedSectionViewModel(cells: [], status: status)
        list.insertSection(section, at: index)
        return index
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
    
    public func index<T>(for cell: T) -> IndexPath? {
        guard let cell = wrap(cell) else { return nil }
        if let index = list[cell] {
            return index
        }
        return nil
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
            let index = list.index(predicate) else { return nil }
        list.remove(at: index)
        return index
    }
    
    public func isEqual<T>(_ lhs: T, _ rhs: T) -> Bool {
        guard let lhs = wrap(lhs),
            let rhs = wrap(rhs) else { return false }
        return lhs == rhs
    }
}

private extension CompletedListViewModel {

    func indexOfSection(for cell: CompletedViewModel) -> Int? {
        guard let completionStatus = cell.model.completedStatus else { return nil }
        return sections.firstIndex(where: { $0.status == completionStatus })
    }

    func containtsSection(for cell: CompletedViewModel) -> Bool {
        guard indexOfSection(for: cell) != nil else { return false }
        return true
    }
}
