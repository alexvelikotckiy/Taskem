//
//  TableUpdater.swift
//  TaskemFoundation
//
//  Created by Wilson on 3/22/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import Foundation

public protocol TableCoordinatorDelegate: class {
    func didBeginUpdate()
    func didEndUpdate()
    
    func insertSections(at indexes: IndexSet)
    func reloadSections(at indexes: IndexSet)
    func deleteSections(at indexes: IndexSet)
    
    func willBeginUpdate(at index: IndexPath)
    func willEndUpdate(at index: IndexPath)
    
    func insertRows(at indexes: [IndexPath])
    func updateRows(at indexes: [IndexPath])
    func deleteRows(at indexes: [IndexPath])
    func moveRow(from: IndexPath, to index: IndexPath)
}

public protocol TableCoordinatorObserver: class {
    func didBeginUpdate()
    func didEndUpdate()
    
    func didInsertSections(at indexes: IndexSet)
    func didDeleteSections(at indexes: IndexSet)
    
    func didInsertRow(at index: IndexPath)
    func didUpdateRow(at index: IndexPath)
    func didDeleteRow(at index: IndexPath)
    func didMoveRow(from: IndexPath, to index: IndexPath)
}

public protocol TableDataCoordinator: class {
    func insertSectionIfNeed<T>(for cell: T) -> Int?
    func removeEmptySections() -> IndexSet?
    
    func shouldInsert<T>(_ cell: T) -> Bool
    func shouldUpdate<T>(_ cell: T) -> Bool
    func shouldMove<T>(_ cell: T) -> Bool
    func shouldRemove<T>(_ cell: T) -> Bool
    func shouldRemove<T>(next predicate: @escaping (T) -> Bool) -> Bool
    func shouldRemoveEmptySections() -> Bool
    
    func insert<T>(_ cell: T) -> IndexPath?
    func update<T>(_ cell: T) -> IndexPath?
    func remove<T>(_ cell: T) -> IndexPath?
    func remove<T>(next predicate: @escaping (T) -> Bool) -> IndexPath?
    func move<T>(_ cell: T) -> (IndexPath, IndexPath)?
    
    func contain<T>(_ cell: T) -> Bool
    func index<T>(for cell: T) -> IndexPath?
    func makeUpdate<T>(newCell: T) -> Update<Any>?
    func isEqual<T>(_ lhs: T, _ rhs: T) -> Bool
}

public protocol TableCoordinatorProtocol: class {
    var delegate: TableCoordinatorDelegate? { get set }
    var observers: ObserverCollection<TableCoordinatorObserver> { get set }
    
    var dataCoordinator: TableDataCoordinator { get set }
    
    var configuration: TableCoordinatorConfiguration { get set }

    var isPaused: Bool { get }
    func pause(cacheChanges: Bool)
    func proceed()
    
    func insert<T>(_ cells: [T], silent: Bool)
    func update<T>(_ cells: [T], silent: Bool)
    func update<T>(_ cells: [Update<T>], silent: Bool)
    func remove<T>(_ cells: [T], silent: Bool)
    func remove<T>(_ predicate: @escaping (T) -> Bool, silent: Bool)
    func removeEmptySections(silent: Bool)
}

public extension TableCoordinatorProtocol {
    func addObserver(_ oberver: TableCoordinatorObserver) {
        observers.append(oberver)
    }
    
    func removeObserver(_ observer: TableCoordinatorObserver) {
        observers.remove(observer)
    }
}

private extension TableCoordinatorProtocol {
    func notifyBeginUpdate() {
        delegate?.didBeginUpdate()
        observers.forEach { $0?.didBeginUpdate() }
    }
    
    func notifyEndUpdate() {
        delegate?.didEndUpdate()
        observers.forEach { $0?.didEndUpdate() }
    }
    
    func notifyInsertSections(at indexes: IndexSet) {
        delegate?.insertSections(at: indexes)
        observers.forEach { $0?.didInsertSections(at: indexes) }
    }
    
    func notifyDeleteSections(at indexes: IndexSet) {
        delegate?.deleteSections(at: indexes)
        observers.forEach { $0?.didDeleteSections(at: indexes) }
    }
    
    func notifyWillBeginUpdate(at index: IndexPath) {
        delegate?.willBeginUpdate(at: index)
    }
    
    func notifyWillEndUpdate(at index: IndexPath) {
        delegate?.willEndUpdate(at: index)
    }
    
    func notifyInsertRow(at index: IndexPath) {
        delegate?.insertRows(at: [index])
        observers.forEach { $0?.didInsertRow(at: index) }
    }
    
    func notifyUpdateRow(at index: IndexPath) {
        delegate?.updateRows(at: [index])
        observers.forEach { $0?.didUpdateRow(at: index) }
    }
    
    func notifyDeleteRow(at index: IndexPath) {
        delegate?.deleteRows(at: [index])
        observers.forEach { $0?.didDeleteRow(at: index) }
    }
    
    func notifyDidMoveRow(from: IndexPath, to index: IndexPath) {
        delegate?.moveRow(from: from, to: index)
        observers.forEach { $0?.didMoveRow(from: from, to: index) }
    }
}

public struct TableCoordinatorConfiguration: Equatable {
    public var shouldUpdateEqual: Bool
    public var shouldClearEmptySections: Bool
    
    public init(shouldUpdateEqual: Bool = true,
                shouldClearEmptySections: Bool = true) {
        self.shouldClearEmptySections = shouldClearEmptySections
        self.shouldUpdateEqual = shouldUpdateEqual
    }
    
    public static var `default`: TableCoordinatorConfiguration {
        return TableCoordinatorConfiguration(
            shouldUpdateEqual: true,
            shouldClearEmptySections: true
        )
    }
}

public class TableCoordinator: TableCoordinatorProtocol {
    
    public weak var delegate: TableCoordinatorDelegate?
    
    public var observers: ObserverCollection<TableCoordinatorObserver>
    public var dataCoordinator: TableDataCoordinator
    
    private var queue: PendingQueue = .init()
    private var silent: Bool = false
    
    public var configuration: TableCoordinatorConfiguration = .default
    
    public var isPaused: Bool {
        return queue.isPaused
    }
    
    public init(
        delegate: TableCoordinatorDelegate,
        dataCoordinator: TableDataCoordinator,
        observers: ObserverCollection<TableCoordinatorObserver> = .init()
        ) {
        self.delegate = delegate
        self.dataCoordinator = dataCoordinator
        self.observers = observers
    }
    
    public func pause(cacheChanges: Bool) {
        queue.pause(cacheOperations: cacheChanges)
    }
    
    public func proceed() {
        queue.proceed()
    }
    
    public func insert<T>(_ cells: [T], silent: Bool = false) {
        queue.add { [weak self] in
            self?.process(silent: silent) { self?.insert(cells) }
        }
    }
    
    public func update<T>(_ cells: [Update<T>], silent: Bool = false) {
        queue.add { [weak self] in
            self?.process(silent: silent) { self?.update(cells) }
        }
    }
    
    public func remove<T>(_ cells: [T], silent: Bool = false) {
        queue.add { [weak self] in
            self?.process(silent: silent) { self?.remove(cells) }
        }
    }
    
    public func remove<T>(_ predicate: @escaping (T) -> Bool, silent: Bool = false) {
        queue.add { [weak self] in
            self?.process(silent: silent) { self?.remove(next: predicate) }
        }
    }
    
    public func removeEmptySections(silent: Bool = false) {
        queue.add { [weak self] in
            let shouldClearEmptySections = self?.configuration.shouldClearEmptySections ?? false
            
            self?.configuration.shouldClearEmptySections = false
            self?.process(silent: silent) { self?.removeEmptySections() }
            self?.configuration.shouldClearEmptySections = shouldClearEmptySections
        }
    }
    
    public func update<T>(_ cells: [T], silent: Bool = false) {
        let cells = resolveUpdate(cells)
        queue.add { [weak self] in
            self?.process(silent: silent) { self?.update(cells) }
        }
    }
    
    private func process(silent: Bool, _ block: @escaping () -> Void) {
        self.silent = silent
        
        beginUpdates()
        block()
        endUpdates()
    }
    
    private func beginUpdates() {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if !self.silent {
                self.notifyEndUpdate()
            }
        }
        if !silent {
            notifyBeginUpdate()
        }
    }
    
    private func endUpdates() {
        if configuration.shouldClearEmptySections {
            removeEmptySections(silent: silent)
        }
        CATransaction.commit()
    }
    
    private func insert<T>(_ cells: [T]) {
        for cell in cells where dataCoordinator.shouldInsert(cell) {
            insertSectionForCellIfNeed(cell)
            insertCell(cell)
        }
    }
    
    private func update<T>(_ cells: [Update<T>]) {
        for cell in cells {
            switch dataCoordinator.shouldUpdate(cell.new) {
            case true:
                if dataCoordinator.isEqual(cell.old, cell.new) &&
                    !configuration.shouldUpdateEqual {
                    continue
                }
                
                updateCell(cell.new)
                
                if dataCoordinator.shouldMove(cell.old) {
                    insertSectionForCellIfNeed(cell.new)
                    moveCellIfNeed(cell.new)
                }
                
            case false:
                remove([cell.old])
            }
        }
    }
    
    private func insertCell<T>(_ cell: T) {
        guard let rowIndex = dataCoordinator.insert(cell) else {
            assert(false, "Error when trying to insert a cell")
            return
        }
        if !silent {
            notifyInsertRow(at: rowIndex)
        }
    }
    
    private func updateCell<T>(_ cell: T) {
        guard let rowIndex = dataCoordinator.update(cell) else {
            assert(false, "Error when trying to update a cell")
            return
        }
        if !silent {
            notifyWillBeginUpdate(at: rowIndex)
            notifyUpdateRow(at: rowIndex)
            notifyWillEndUpdate(at: rowIndex)
        }
    }
    
    private func remove<T>(_ cells: [T]) {
        for cell in cells where dataCoordinator.shouldRemove(cell) {
            guard let rowIndex = dataCoordinator.remove(cell) else {
                assert(false, "Error when trying to remove a cell")
                return
            }
            if !silent {
                notifyDeleteRow(at: rowIndex)
            }
        }
    }
    
    private func remove<T>(next predicate: @escaping (T) -> Bool) {
        if dataCoordinator.shouldRemove(next: predicate) {
            while let rowIndex = dataCoordinator.remove(next: predicate) {
                if !silent {
                    notifyDeleteRow(at: rowIndex)
                }
            }
        }
    }
    
    private func removeEmptySections() {
        guard dataCoordinator.shouldRemoveEmptySections(),
            let sectionsIndex = dataCoordinator.removeEmptySections() else { return }
        
        if !silent {
            notifyDeleteSections(at: sectionsIndex)
        }
    }
    
    private func moveCellIfNeed<T>(_ cell: T) {
        guard let indexes = dataCoordinator.move(cell) else {
            assert(false, "Error when trying to move a cell")
            return
        }
        if !silent {
            notifyDidMoveRow(from: indexes.0, to: indexes.1)
        }
    }
    
    private func insertSectionForCellIfNeed<T>(_ cell: T) {
        guard let sectionIndex = dataCoordinator.insertSectionIfNeed(for: cell) else { return }
        if !silent {
            notifyInsertSections(at: .init(integer: sectionIndex))
        }
    }
    
    private func resolveUpdate<T>(_ newCells: [T]) -> [Update<Any>] {
        return newCells.map { dataCoordinator.makeUpdate(newCell: $0) }.compactMap { $0 }
    }
}
