//
//  TableCoordinatorTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/29/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class TableCoordinatorTestCaseBase: XCTestCase {
    fileprivate var coordinator: TableCoordinator!
    fileprivate var coordinatorDelegate: TableCoordinatorDelegateSpy!
    fileprivate var dataCoordinator: TableDataCoordinatorMock!
    
    fileprivate var oberverOne: TableCoordinatorObserverSpy!
    fileprivate var oberverTwo: TableCoordinatorObserverSpy!
    
    fileprivate var list: ListDoubles!
    
    fileprivate var silent: Bool!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        oberverOne = .init()
        oberverTwo = .init()
        
        list = ListDoublesStub.makeFullList()
        
        coordinatorDelegate = .init()
        dataCoordinator = .init(list: list)
        coordinator = TableCoordinator(delegate: coordinatorDelegate, dataCoordinator: dataCoordinator)
        coordinator.addObserver(oberverOne)
        coordinator.addObserver(oberverTwo)
    }
    
    fileprivate func expectEqualValue(at index: IndexPath, value: Int, line: UInt = #line) {
        expect(self.list[index].value, line: line).toEventually(equal(value))
    }
    
    fileprivate func expectNotEqualValue(at index: IndexPath, value: Int, line: UInt = #line) {
        expect(self.list[index].value, line: line).toEventuallyNot(equal(value))
    }
    
    fileprivate func expectEqualId(at index: IndexPath, id: EntityId, line: UInt = #line) {
        expect(self.list[index].id, line: line).toEventually(equal(id))
    }
    
    fileprivate func expectNotEqualId(at index: IndexPath, id: EntityId, line: UInt = #line) {
        expect(self.list[index].id, line: line).toEventuallyNot(equal(id))
    }
    
    fileprivate func expectCallMove(from: IndexPath, to index: IndexPath, line: UInt = #line) {
        expect(self.oberverOne.lastMoveRow?.0, line: line).toEventually(silent ? beNil() : equal(from))
        expect(self.oberverOne.lastMoveRow?.1, line: line).toEventually(silent ? beNil() : equal(index))
        expect(self.oberverTwo.lastMoveRow?.0, line: line).toEventually(silent ? beNil() : equal(from))
        expect(self.oberverTwo.lastMoveRow?.1, line: line).toEventually(silent ? beNil() : equal(index))
        expect(self.coordinatorDelegate.lastMoveRow?.0, line: line).toEventually(silent ? beNil() : equal(from))
        expect(self.coordinatorDelegate.lastMoveRow?.1, line: line).toEventually(silent ? beNil() : equal(index))
    }
    
    fileprivate func expectCallWillBeginUpdate(at index: IndexPath, line: UInt = #line) {
        expect(self.oberverOne.didCallBeginUpdate, line: line).toEventually(silent ? beFalse() : beTrue())
        expect(self.oberverTwo.didCallBeginUpdate, line: line).toEventually(silent ? beFalse() : beTrue())
        expect(self.coordinatorDelegate.didCallBeginUpdate, line: line).toEventually(silent ? beFalse() : beTrue())
    }
    
    fileprivate func expectCallWillEndUpdate(at index: IndexPath, line: UInt = #line) {
        expect(self.oberverOne.didCallEndUpdate, line: line).toEventually(silent ? beFalse() : beTrue())
        expect(self.oberverTwo.didCallEndUpdate, line: line).toEventually(silent ? beFalse() : beTrue())
        expect(self.coordinatorDelegate.didCallEndUpdate, line: line).toEventually(silent ? beFalse() : beTrue())
    }
    
    fileprivate func expectCallInsertSection(at indexes: IndexSet, line: UInt = #line) {
        expect(self.oberverOne.lastInsertedSections, line: line).toEventually(silent ? beNil() : equal(indexes))
        expect(self.oberverTwo.lastInsertedSections, line: line).toEventually(silent ? beNil() : equal(indexes))
        expect(self.coordinatorDelegate.lastInsertedSections, line: line).toEventually(silent ? beNil() : equal(indexes))
    }
    
    fileprivate func expectCallDeleteSections(at indexes: IndexSet, line: UInt = #line) {
        expect(self.oberverOne.lastDeletedSections, line: line).toEventually(silent ? beNil() : equal(indexes))
        expect(self.oberverTwo.lastDeletedSections, line: line).toEventually(silent ? beNil() : equal(indexes))
        expect(self.coordinatorDelegate.lastDeletedSections, line: line).toEventually(silent ? beNil() : equal(indexes))
    }
    
    fileprivate func expectCallInsert(at indexes: [IndexPath], line: UInt = #line) {
        expect(self.oberverOne.lastInsertedRows, line: line).toEventually(silent ? beEmpty() : equal(indexes))
        expect(self.oberverTwo.lastInsertedRows, line: line).toEventually(silent ? beEmpty() : equal(indexes))
        expect(self.coordinatorDelegate.lastInsertedRows, line: line).toEventually(silent ? beEmpty() : equal(indexes))
    }
    
    fileprivate func expectNotCallInsert(line: UInt = #line) {
        expect(self.oberverOne.lastInsertedRows, line: line).toEventually(silent ? beEmpty() : beEmpty())
        expect(self.oberverTwo.lastInsertedRows, line: line).toEventually(silent ? beEmpty() : beEmpty())
        expect(self.coordinatorDelegate.lastInsertedRows, line: line).toEventually(silent ? beEmpty() : beEmpty())
    }
    
    fileprivate func expectCallUpdate(at indexes: [IndexPath], line: UInt = #line) {
        expect(self.oberverOne.lastUpdatedRows, line: line).toEventually(silent ? beEmpty() : equal(indexes))
        expect(self.oberverTwo.lastUpdatedRows, line: line).toEventually(silent ? beEmpty() : equal(indexes))
        expect(self.coordinatorDelegate.lastUpdatedRows, line: line).toEventually(silent ? beEmpty() : equal(indexes))
    }
    
    fileprivate func expectNotCallUpdate(line: UInt = #line) {
        expect(self.oberverOne.lastUpdatedRows, line: line).toEventually(silent ? beEmpty() : beEmpty())
        expect(self.oberverTwo.lastUpdatedRows, line: line).toEventually(silent ? beEmpty() : beEmpty())
        expect(self.coordinatorDelegate.lastUpdatedRows, line: line).toEventually(silent ? beEmpty() : beEmpty())
    }
    
    fileprivate func expectCallRemove(at indexes: [IndexPath], line: UInt = #line) {
        expect(self.oberverOne.lastDeletedRows, line: line).toEventually(silent ? beEmpty() : equal(indexes))
        expect(self.oberverTwo.lastDeletedRows, line: line).toEventually(silent ? beEmpty() : equal(indexes))
        expect(self.coordinatorDelegate.lastDeletedRows, line: line).toEventually(silent ? beEmpty() : equal(indexes))
    }
    
    fileprivate func expectNotCallRemove(line: UInt = #line) {
        expect(self.oberverOne.lastDeletedRows, line: line).toEventually(silent ? beEmpty() : beEmpty())
        expect(self.oberverTwo.lastDeletedRows, line: line).toEventually(silent ? beEmpty() : beEmpty())
        expect(self.coordinatorDelegate.lastDeletedRows, line: line).toEventually(silent ? beEmpty() : beEmpty())
    }
}

class TableCoordinatorTestCase: TableCoordinatorTestCaseBase {

    override var silent: Bool! {
        get { return false }
        set { }
    }
    
    func testAddObserver() {
        let observer = TableCoordinatorObserverSpy()

        coordinator.addObserver(observer)

        expect(self.coordinator.observers.count) == 3
        expect(self.coordinator.observers.last) === observer
    }

    func testRemoveObserver() {
        coordinator.removeObserver(oberverTwo)

        expect(self.coordinator.observers.count) == 1
        expect(self.coordinator.observers.last) === oberverOne
    }

    func testPause() {
        coordinator.pause(cacheChanges: true)
        expect(self.coordinator.isPaused) == true
        
        coordinator.proceed()
        expect(self.coordinator.isPaused) == false
    }
    
    func testProceedWithoutCache() {
        coordinator.pause(cacheChanges: false)
        let cellOne = ListCellDoubles(value: 1)
        coordinator.insert([cellOne], silent: silent)
        
        coordinator.proceed()
        
        expectCallInsert(at: [])
    }
    
    func testProceedWithCache() {
        coordinator.pause(cacheChanges: true)
        let cellOne = ListCellDoubles(value: 1)
        coordinator.insert([cellOne], silent: silent)
        
        coordinator.proceed()
        
        expectCallInsert(at: [.init(row: 0, section: 0)])
    }
    
    func testInsert() {
        let cellOne = ListCellDoubles(value: 1)
        let cellTwo = ListCellDoubles(value: 0)

        coordinator.insert([cellOne, cellTwo], silent: silent)

        expectEqualId(at: .init(row: 1, section: 0), id: cellOne.id)
        expectEqualId(at: .init(row: 0, section: 0), id: cellTwo.id)
        expectCallInsert(at: [.init(row: 0, section: 0), .init(row: 0, section: 0)])
    }

    func testInsertCellAndSection() {
        let expectedIndex = IndexPath(row: 0, section: 0)
        let cell = ListCellDoubles(value: 1)

        coordinator.insert([cell], silent: silent)

        expectCallInsertSection(at: .init(integer: 0))
        expectCallInsert(at: [expectedIndex])
    }

    func testShouldNotInsert() {
        let expectedIndex = IndexPath(row: 0, section: 0)
        let cell = ListCellDoubles(value: 0)

        dataCoordinator.shouldInsertCells = false
        coordinator.insert([cell], silent: silent)

        expectNotCallInsert()
        expectNotEqualId(at: expectedIndex, id: cell.id)
    }

    func testUpdate() {
        let expectedUpdateIndex = IndexPath(row: 0, section: 0)
        let expectedMoveIndex = IndexPath(row: 0, section: 1)
        var cell = list[0].cells[0]
        cell.value = -1

        coordinator.update([cell], silent: silent)

        expectEqualValue(at: expectedMoveIndex, value: -1)
        expectEqualId(at: expectedMoveIndex, id: cell.id)
        expectCallUpdate(at: [expectedUpdateIndex])
        expectCallMove(from: expectedUpdateIndex, to: expectedMoveIndex)
        expectCallWillBeginUpdate(at: expectedUpdateIndex)
        expectCallWillEndUpdate(at: expectedUpdateIndex)
    }

    func testUpdateResolved() {
        let expectedUpdateIndex = IndexPath(row: 0, section: 0)
        let expectedMoveIndex = IndexPath(row: 0, section: 1)
        var cell = list[0].cells[0]
        cell.value = -1
        let update: Update<ListCellDoubles> = .make(new: cell, old: list[0].cells[0])
        
        coordinator.update([update], silent: silent)
        
        expectEqualValue(at: expectedMoveIndex, value: -1)
        expectEqualId(at: expectedMoveIndex, id: cell.id)
        expectCallUpdate(at: [expectedUpdateIndex])
        expectCallMove(from: expectedUpdateIndex, to: expectedMoveIndex)
        expectCallWillBeginUpdate(at: expectedUpdateIndex)
        expectCallWillEndUpdate(at: expectedUpdateIndex)
    }
    
    func testShouldNotUpdate() {
        let expectedIndex = IndexPath(row: 0, section: 0)
        var cell = list[expectedIndex]
        cell.value = -1

        dataCoordinator.shouldUpdateCells = false
        coordinator.update([cell], silent: silent)

        expectNotEqualValue(at: expectedIndex, value: -1)
        expectNotEqualId(at: expectedIndex, id: cell.id)
        expectNotCallUpdate()
        expectCallRemove(at: [expectedIndex])
    }
    
    func testRemove() {
        let expectedIndex = IndexPath(row: 0, section: 0)
        let cell = list[expectedIndex]

        coordinator.remove([cell], silent: silent)

        expectNotEqualId(at: expectedIndex, id: cell.id)
        expectCallRemove(at: [expectedIndex])
    }

    func testShouldNotRemove() {
        let expectedIndex = IndexPath(row: 0, section: 0)
        let cell = list[expectedIndex]

        dataCoordinator.shouldRemoveCells = false
        coordinator.remove([cell], silent: silent)

        expectEqualId(at: expectedIndex, id: cell.id)
        expectNotCallRemove()
    }

    func testRemoveWithPredicate() {
        let expectedRemoveIndex = IndexPath(row: 0, section: 0)
        let predicate: (ListCellDoubles) -> Bool = { _ in return true }

        coordinator.remove(predicate, silent: silent)

        expect(self.list[0].cells).toEventually(beEmpty())
        expectCallRemove(at: [expectedRemoveIndex, expectedRemoveIndex])
    }

    func testShouldNotRemoveWithPredicate() {
        let expectedIndex = IndexPath(row: 0, section: 0)
        let predicate: (ListCellDoubles) -> Bool = { _ in return true }
        let cell = list[expectedIndex]

        dataCoordinator.shouldRemoveCells = false
        coordinator.remove(predicate, silent: silent)

        expectEqualId(at: expectedIndex, id: cell.id)
        expectNotCallRemove()
    }

    func testRemoveEmptySections() {
        list.sections[0].cells.removeAll()

        coordinator.removeEmptySections(silent: silent)

        expectCallDeleteSections(at: .init(integer: 0))
    }
}

class TableCoordinatorConfigurationTestCase: TableCoordinatorTestCaseBase {
    override var silent: Bool! {
        get { return false }
        set { }
    }
    
    func testShouldNotUpdateEqual() {
        let cell = list.allCells.first!
        coordinator.configuration.shouldUpdateEqual = false
        
        coordinator.update([cell], silent: silent)
        
        expectNotCallUpdate()
        expectNotCallRemove()
    }
    
    func testShouldNotDeleteEmptySections() {
        coordinator.configuration.shouldClearEmptySections = false
        
        coordinator.remove(list.sections[0].cells, silent: silent)
        
        expect(self.oberverOne.lastDeletedSections).toEventually(beNil())
        expect(self.oberverTwo.lastDeletedSections).toEventually(beNil())
        expect(self.coordinatorDelegate.lastDeletedSections).toEventually(beNil())
    }
}

class TableCoordinatorSilentTestCase: TableCoordinatorTestCase {
    override var silent: Bool! {
        get { return true }
        set { }
    }
}
