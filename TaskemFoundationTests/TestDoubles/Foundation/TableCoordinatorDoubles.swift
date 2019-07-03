//
//  TableCoordinatorDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/22/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class TableCoordinatorSpy: TableCoordinatorProtocol {
    var delegate: TableCoordinatorDelegate?
    var observers: ObserverCollection<TableCoordinatorObserver>
    var dataCoordinator: TableDataCoordinator
    
    var inserted: [Any] = []
    var updated: [Any] = []
    var removed: [Any] = []
    var removePredicate: Any?
    var removedEmptySections = false
  
    var didNotifyLastAction: Bool?
    
    var configuration: TableCoordinatorConfiguration = .default
    
    var isPaused = false
    
    init() {
        self.delegate = TableCoordinatorDelegateDummy()
        self.dataCoordinator = TableDataCoordinatorDummy()
        self.observers = .init()
    }
    
    func pause(cacheChanges: Bool) {
        isPaused = true
    }
    
    func proceed() {
        isPaused = false
    }
    
    func insert<T>(_ cells: [T], silent: Bool) {
        inserted = cells
        didNotifyLastAction = !silent
    }
    
    func update<T>(_ cells: [T], silent: Bool) {
        updated = cells
        didNotifyLastAction = !silent
    }
    
    func update<T>(_ cells: [Update<T>], silent: Bool) {
        updated = cells
        didNotifyLastAction = !silent
    }
    
    func remove<T>(_ cells: [T], silent: Bool) {
        removed = cells
        didNotifyLastAction = !silent
    }
    
    func remove<T>(_ predicate: @escaping (T) -> Bool, silent: Bool) {
        removePredicate = predicate
        didNotifyLastAction = !silent
    }
    
    func removeEmptySections(silent: Bool) {
        removedEmptySections = true
        didNotifyLastAction = !silent
    }
}
