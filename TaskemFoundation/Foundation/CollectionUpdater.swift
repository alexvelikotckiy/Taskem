//
//  CollectionUpdater.swift
//  TaskemFoundation
//
//  Created by Wilson on 8/11/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import Foundation

public protocol CollectionUpdaterDelegate: class {
    func didBeginUpdate()
    func didEndUpdate()
    
    func insertSections(at indexes: IndexSet)
    func reloadSections(at indexes: IndexSet)
    func deleteSections(indexes: IndexSet)
    
    func willBeginUpdate(at index: IndexPath)
    func insertRows(at indexes: [IndexPath])
    func updateRows(at indexes: [IndexPath])
    func deleteRows(at indexes: [IndexPath])
    func moveRow(from: IndexPath, to index: IndexPath)
}

public protocol CollectionUpdaterObserver: class {
    func didInsertSections(at indexes: IndexSet)
    func didDeleteSections(indexes: IndexSet)
    
    func didInsertRows(at indexes: [IndexPath])
    func didUpdateRows(at indexes: [IndexPath])
    func didDeleteRows(at indexes: [IndexPath])
    func didMoveRow(from: IndexPath, to index: IndexPath)
}

public protocol CollectionDataUpdater {
    func insertSection<T>(for cell: T) -> Int?
    func removeEmptySections() -> IndexSet?
    
    func contain<T>(_ cell: T) -> Bool
    func shouldInsert<T>(_ cell: T) -> Bool
    func shouldUpdate<T>(_ cell: T) -> Bool
    func index<T>(for cell: T) -> IndexPath?
    func insert<T>(_ cell: T) -> IndexPath?
    func update<T>(_ cell: T) -> IndexPath?
    func move<T>(_ cell: T) -> (IndexPath, IndexPath)?
    func remove<T>(_ cell: T) -> IndexPath?
    func remove<T>(next predicate: @escaping (T) -> Bool) -> IndexPath?
}

// REDONE
public class CollectionUpdater {
    public var source: CollectionDataUpdater
    public var shouldUpdate = true
    
    weak var delegate: CollectionUpdaterDelegate?
    weak var observer: CollectionUpdaterObserver?
    
    init(
        source: CollectionDataUpdater,
        delegate: CollectionUpdaterDelegate,
        shouldUpdate: Bool = true
        ) {
        self.source = source
        self.delegate = delegate
        self.shouldUpdate = shouldUpdate
    }
    
    private func beginUpdates() {
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in self?.delegate?.didEndUpdate() }
        self.delegate?.didBeginUpdate()
    }
    
    private func endUpdates() {
        removeEmpty()
        CATransaction.commit()
    }
    
    func insert<T>(_ cells: [T]) {
        guard shouldUpdate else { return }
        beginUpdates()
        for cell in cells where source.shouldInsert(cell) {
            if let sectionIndex = source.insertSection(for: cell) {
                delegate?.insertSections(at: IndexSet(integer: sectionIndex))
            }
            
            if let rowIndex = source.insert(cell) {
                delegate?.insertRows(at: [rowIndex])
            }
        }
        endUpdates()
    }
    
    func update<T>(_ cells: [Update<T>]) {
        guard shouldUpdate else { return }
        beginUpdates()
        for cell in cells where source.contain(cell.old) {
            if source.shouldUpdate(cell.new) {
                
                if let sectionIndex = source.insertSection(for: cell.new) {
                    let indexes = IndexSet(integer: sectionIndex)
                    delegate?.insertSections(at: indexes)
                    observer?.didInsertSections(at: indexes)
                }
                
                if let updatableIndex = source.update(cell.new) {
                    delegate?.willBeginUpdate(at: updatableIndex)
                    delegate?.updateRows(at: [updatableIndex])
                    observer?.didUpdateRows(at: [updatableIndex])
                    
                    if let indexes = source.move(cell.new) {
                        delegate?.moveRow(from: indexes.0, to: indexes.1)
                        observer?.didMoveRow(from: indexes.0, to: indexes.1)
                    }
                }
            } else {
                if let oldIndex = source.remove(cell.old) {
                    delegate?.deleteRows(at: [oldIndex])
                    observer?.didDeleteRows(at: [oldIndex])
                }
            }
        }
        endUpdates()
    }
    
    func remove<T>(_ cells: [T]) {
        guard shouldUpdate else { return }
        beginUpdates()
        for cell in cells {
            if let rowIndex = source.remove(cell) {
                delegate?.deleteRows(at: [rowIndex])
                observer?.didDeleteRows(at: [rowIndex])
            }
        }
        endUpdates()
    }
    
    func remove<T>(_ predicate: @escaping (T) -> Bool) {
        guard shouldUpdate else { return }
        beginUpdates()
        while let rowIndex = source.remove(next: predicate) {
            delegate?.deleteRows(at: [rowIndex])
            observer?.didDeleteRows(at: [rowIndex])
        }
        endUpdates()
    }
    
    func removeEmptySections() {
        guard shouldUpdate else { return }
        beginUpdates()
        if let indexes = source.removeEmptySections() {
            delegate?.deleteSections(indexes: indexes)
            observer?.didDeleteSections(indexes: indexes)
        }
        endUpdates()
    }
    
    private func removeEmpty() {
        if let indexes = source.removeEmptySections(), !indexes.isEmpty {
            delegate?.deleteSections(indexes: indexes)
            observer?.didDeleteSections(indexes: indexes)
        }
    }
    
}
