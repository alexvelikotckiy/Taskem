//
//  CalendarPresenter+DataCoordinator.swift
//  Taskem
//
//  Created by Wilson on 4/11/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

fileprivate typealias Cell = CalendarCellViewModel

extension CalendarPresenter: TableDataCoordinator {
    
    private var list: CalendarListViewModel {
        return view?.viewModel ?? .init()
    }
    
    public func insertSectionIfNeed<T>(for cell: T) -> Int? {
        guard let cell = wrap(cell),
            let index = insertableSectionIndex(for: cell),
            let date = cell.date?.timeless else { return nil }
        let section = CalendarSectionViewModel(date: date, cells: [])
        list.insertSection(section, at: index)
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
    
    public func shouldInsert<T>(_ cell: T) -> Bool {
        guard let cell = wrap(cell),
            list[cell] == nil else { return false }
        return shouldUpdate(cell)
    }
    
    public func shouldMove<T>(_ cell: T) -> Bool {
        return true
    }
    
    public func shouldUpdate<T>(_ cell: T) -> Bool {
        guard let cell = wrap(cell) else { return false }
        let predicate: (CalendarCellViewModel) -> Bool = filterPredicate(at: config.style == .bydate ? list.currentDate : nil)
        return predicate(cell)
    }
    
    public func shouldRemove<T>(_ cell: T) -> Bool {
        guard wrap(cell) != nil else { return false }
        return true
    }
    
    public func shouldRemove<T>(next predicate: @escaping (T) -> Bool) -> Bool {
        guard predicate as? (CalendarCellViewModel) -> Bool != nil else { return false }
        return true
    }
    
    public func shouldRemoveEmptySections() -> Bool {
        return true
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
    
    public func move<T>(_ cell: T) -> (IndexPath, IndexPath)? {
        guard let cell = wrap(cell),
            let removableIndex = remove(cell),
            let insertableIndex = insert(cell) else { return nil }
        return (removableIndex, insertableIndex)
    }
    
    public func contain<T>(_ cell: T) -> Bool {
        guard let cell = wrap(cell),
            index(for: cell) != nil else { return false }
        return true
    }
    
    public func index<T>(for cell: T) -> IndexPath? {
        guard let cell = wrap(cell),
            let index = list[cell] else { return nil }
        return index
    }
    
    public func makeUpdate<T>(newCell: T) -> Update<Any>? {
        guard let newCell = wrap(newCell),
            let oldCell = list[newCell.id] else { return nil }
        return .make(new: newCell, old: oldCell)
    }
    
    public func isEqual<T>(_ lhs: T, _ rhs: T) -> Bool {
        guard let lhs = wrap(lhs),
            let rhs = wrap(rhs) else { return false }
        return lhs == rhs
    }
}

private extension CalendarPresenter {
    func wrap<T>(_ object: T) -> CalendarCellViewModel? {
        if let cell = object as? CalendarCellConvertible {
            return cell.convertToCalendar
        }
        return nil
    }
    
    func insertableIndex(for cell: CalendarCellViewModel, in section: Int) -> IndexPath {
        switch cell {
        case .freeday:
            return .init(row: 0, section: section)

        default:
            if let index = list.sections[section].cells.firstIndex(where: { sortPredicate(cell, $0) }) {
                return .init(row: index, section: section)
            }
            return .init(row: list.sections[section].cells.count, section: section)
        }
    }
    
    func insertableSectionIndex(for cell: Cell) -> Int? {
        guard let cellDate = cell.date?.timeless else { return nil }
        
        switch true {
        case list.containSection(for: cell):
            return nil
            
        case list.sections.isEmpty:
            return 0
            
        default:
            if let index = list.sections.firstIndex(where: { cellDate < $0.date }) {
                return index
            } else {
                return list.sections.count
            }
        }
    }
}

private extension CalendarListViewModel {
    func containSection(for cell: CalendarCellViewModel) -> Bool {
        guard indexOfSection(for: cell) != nil else { return false }
        return true
    }

    func indexOfSection(for cell: CalendarCellViewModel) -> Int? {
        switch cell {
        case let .task(task):
            if let date = task.estimateDate?.timeless {
                return sections.firstIndex(where: { $0.date == date })
            }

        case let .event(event):
            let date = event.occurrenceDate.timeless
            return sections.firstIndex(where: { $0.date == date })

        case .time(let time):
            return sections.firstIndex(where: { $0.date == time.date.timeless })

        case .freeday(let freeday):
            return sections.firstIndex(where: { $0.date == freeday.date })
        }
        return nil
    }

    func indexes(where predicate: (CalendarCellViewModel) -> Bool) -> [IndexPath] {
        return sections.enumerated().reduce(into: []) { result, section in
            for cell in section.element.cells.enumerated() where predicate(cell.element) {
                result.append(.init(row: cell.offset, section: section.offset))
            }
        }
    }
}
