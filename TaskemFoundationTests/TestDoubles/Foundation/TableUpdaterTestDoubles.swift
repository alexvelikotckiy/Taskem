//
//  TableUpdaterTestDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/29/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class TableCoordinatorDelegateDummy: TableCoordinatorDelegate {
    func didBeginUpdate() {
        
    }
    
    func didEndUpdate() {
        
    }
    
    func insertSections(at indexes: IndexSet) {
        
    }
    
    func reloadSections(at indexes: IndexSet) {
        
    }
    
    func deleteSections(at indexes: IndexSet) {
        
    }
    
    func willBeginUpdate(at index: IndexPath) {
        
    }
    
    func willEndUpdate(at index: IndexPath) {
        
    }
    
    func insertRows(at indexes: [IndexPath]) {
        
    }
    
    func updateRows(at indexes: [IndexPath]) {
        
    }
    
    func deleteRows(at indexes: [IndexPath]) {
        
    }
    
    func moveRow(from: IndexPath, to index: IndexPath) {
        
    }
}

class TableCoordinatorDelegateSpy: TableCoordinatorDelegateDummy {
    var didCallBeginUpdate = false
    var didCallEndUpdate = false

    var lastInsertedSections: IndexSet?
    var lastReloadedSections: IndexSet?
    var lastDeletedSections: IndexSet?

    var lastWillBeginUpdateRow: IndexPath?
    var lastWillEndUpdateRow: IndexPath?

    var lastInsertedRows: [IndexPath] = []
    var lastUpdatedRows: [IndexPath] = []
    var lastDeletedRows: [IndexPath] = []

    var lastMoveRow: (IndexPath, IndexPath)?

    override func didBeginUpdate() {
        didCallBeginUpdate = true
    }

    override func didEndUpdate() {
        didCallEndUpdate = true
    }
    
    override func insertSections(at indexes: IndexSet) {
        lastInsertedSections = indexes
    }

    override func reloadSections(at indexes: IndexSet) {
        lastReloadedSections = indexes
    }

    override func deleteSections(at indexes: IndexSet) {
        lastDeletedSections = indexes
    }

    override func willBeginUpdate(at index: IndexPath) {
        lastWillBeginUpdateRow = index
    }
    
    override func willEndUpdate(at index: IndexPath) {
        lastWillEndUpdateRow = index
    }

    override func insertRows(at indexes: [IndexPath]) {
        lastInsertedRows.append(contentsOf: indexes)
    }

    override func updateRows(at indexes: [IndexPath]) {
        lastUpdatedRows.append(contentsOf: indexes)
    }

    override func deleteRows(at indexes: [IndexPath]) {
        lastDeletedRows.append(contentsOf: indexes)
    }

    override func moveRow(from: IndexPath, to index: IndexPath) {
        lastMoveRow = (from, index)
    }
}

class TableCoordinatorObserverSpy: TableCoordinatorObserver {
    var didCallBeginUpdate = false
    var didCallEndUpdate = false
    
    var lastInsertedSections: IndexSet?
    var lastUpdatedSections: IndexSet?
    var lastDeletedSections: IndexSet?

    var lastInsertedRows: [IndexPath] = []
    var lastUpdatedRows: [IndexPath] = []
    var lastDeletedRows: [IndexPath] = []

    var lastMoveRow: (IndexPath, IndexPath)?

    func didBeginUpdate() {
        didCallBeginUpdate = true
    }
    
    func didEndUpdate() {
        didCallEndUpdate = true
    }
    
    func didInsertSections(at indexes: IndexSet) {
        lastInsertedSections = indexes
    }
    
    func didDeleteSections(at indexes: IndexSet) {
        lastDeletedSections = indexes
    }
    
    func didInsertRow(at index: IndexPath) {
        lastInsertedRows.append(index)
    }
    
    func didUpdateRow(at index: IndexPath) {
        lastUpdatedRows.append(index)
    }
    
    func didDeleteRow(at index: IndexPath) {
        lastDeletedRows.append(index)
    }
    
    func didMoveRow(from: IndexPath, to index: IndexPath) {
        lastMoveRow = (from, index)
    }
}

class TableDataCoordinatorDummy: TableDataCoordinator {
    func insertSectionIfNeed<T>(for cell: T) -> Int? {
        return nil
    }
    
    func removeEmptySections() -> IndexSet? {
        return nil
    }
    
    func shouldInsert<T>(_ cell: T) -> Bool {
        return false
    }
    
    func shouldMove<T>(_ cell: T) -> Bool {
        return false
    }
    
    func shouldUpdate<T>(_ cell: T) -> Bool {
        return false
    }
    
    func shouldRemove<T>(_ cell: T) -> Bool {
        return false
    }
    
    func shouldRemove<T>(next predicate: @escaping (T) -> Bool) -> Bool {
        return false
    }
    
    func shouldRemoveEmptySections() -> Bool {
        return false
    }
    
    func insert<T>(_ cell: T) -> IndexPath? {
        return nil
    }
    
    func update<T>(_ cell: T) -> IndexPath? {
        return nil
    }
    
    func remove<T>(_ cell: T) -> IndexPath? {
        return nil
    }
    
    func remove<T>(next predicate: @escaping (T) -> Bool) -> IndexPath? {
        return nil
    }
    
    func move<T>(_ cell: T) -> (IndexPath, IndexPath)? {
        return nil
    }
    
    func contain<T>(_ cell: T) -> Bool {
        return false
    }
    
    func index<T>(for cell: T) -> IndexPath? {
        return nil
    }
    
    func makeUpdate<T>(newCell: T) -> Update<Any>? {
        return nil
    }
    
    func isEqual<T>(_ lhs: T, _ rhs: T) -> Bool {
        return false
    }
}

class TableDataCoordinatorSpy: TableDataCoordinatorDummy {
    
    var inserted: Any?
    var updated: Any?
    var removed: Any?
    var removePredicate: Any?
    var moved: Any?
    
    override func insert<T>(_ cell: T) -> IndexPath? {
        inserted = cell
        return nil
    }
    
    override func update<T>(_ cell: T) -> IndexPath? {
        updated = cell
        return nil
    }
    
    override func remove<T>(_ cell: T) -> IndexPath? {
        removed = cell
        return nil
    }
    
    override func remove<T>(next predicate: @escaping (T) -> Bool) -> IndexPath? {
        removePredicate = predicate
        return nil
    }
    
    override func move<T>(_ cell: T) -> (IndexPath, IndexPath)? {
        moved = cell
        return nil
    }
}

class TableDataCoordinatorMock: TableDataCoordinatorDummy {
    var shouldInsertCells = true
    var shouldMoveCells = true
    var shouldUpdateCells = true
    var shouldRemoveCells = true
    var shouldRemoveEmptyTableSections = true
    var shouldEqual = true
    
    let sectionIndex = IndexSet(integer: 0)
    let rowIndex = IndexPath(row: 0, section: 0)
    let moveDestination = IndexPath(row: 0, section: 1)
    
    var list: ListDoubles
    
    init(list: ListDoubles) {
        self.list = list
    }
    
    override func insertSectionIfNeed<T>(for cell: T) -> Int? {
        return 0
    }
    
    override func removeEmptySections() -> IndexSet? {
        return sectionIndex
    }
    
    override func shouldInsert<T>(_ cell: T) -> Bool {
        return shouldInsertCells
    }

    override func shouldMove<T>(_ cell: T) -> Bool {
        return shouldMoveCells
    }
    
    override func shouldUpdate<T>(_ cell: T) -> Bool {
        return shouldUpdateCells
    }

    override func shouldRemove<T>(_ cell: T) -> Bool {
        return shouldRemoveCells
    }

    override func shouldRemove<T>(next predicate: @escaping (T) -> Bool) -> Bool {
        return shouldRemoveCells
    }
    
    override func shouldRemoveEmptySections() -> Bool {
        return shouldRemoveEmptyTableSections
    }
    
    override func insert<T>(_ cell: T) -> IndexPath? {
        list[0].cells.insert(cell as! ListCellDoubles, at: 0)
        return rowIndex
    }
    
    override func update<T>(_ cell: T) -> IndexPath? {
        list[0].cells.remove(at: 0)
        list[0].cells.insert(cell as! ListCellDoubles, at: 0)
        return rowIndex
    }
    
    override func remove<T>(_ cell: T) -> IndexPath? {
        list[0].cells.remove(at: 0)
        return rowIndex
    }
    
    override func remove<T>(next predicate: @escaping (T) -> Bool) -> IndexPath? {
        if list[0].cells.isEmpty { return nil }
        list[0].cells.remove(at: 0)
        return rowIndex
    }
    
    override func move<T>(_ cell: T) -> (IndexPath, IndexPath)? {
        list[0].cells.remove(at: 0)
        list[1].cells.insert(cell as! ListCellDoubles, at: 0)
        return (rowIndex, moveDestination)
    }
    
    override func contain<T>(_ cell: T) -> Bool {
        return true
    }
    
    override func index<T>(for cell: T) -> IndexPath? {
        return rowIndex
    }
    
    override func makeUpdate<T>(newCell: T) -> Update<Any>? {
        return .make(new: newCell, old: newCell)
    }
    
    override func isEqual<T>(_ lhs: T, _ rhs: T) -> Bool {
        return shouldEqual
    }
}
