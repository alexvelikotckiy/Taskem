//
//  CompletedDataUpdaterTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class CompletedDataUpdaterTestCase: CompletedPresenterTestCaseBase {
    
    override func setUp() {
        super.setUp()
        
        let viewModel: CompletedListViewModel = presenter.produce(from: .list(stubsModels))!
        spyView.stubbedViewModel = viewModel
    }
    
    func testShouldInsert() {
        let newCompleted = produceTaskModel(produceTask(status: .recent))
        let newUncompleted = produceTaskModel(factoryTasks.make())
        let old = spyView.stubbedViewModel.allCells.first!
        let any = 0
        
        let shouldInsertCompleted = presenter.shouldInsert(newCompleted)
        let shouldInsertUncompleted = presenter.shouldInsert(newUncompleted)
        let shouldInsertOld = presenter.shouldInsert(old)
        let shouldInsertAny = presenter.shouldInsert(any)
        
        expect(shouldInsertCompleted) == true
        expect(shouldInsertUncompleted) == false
        expect(shouldInsertOld) == false
        expect(shouldInsertAny) == false
    }
    
    func testShouldUpdate() {
        let newCompleted = produceTaskModel(produceTask(status: .recent))
        let newUncompleted = produceTaskModel(factoryTasks.make())
        
        let shouldInsertCompleted = presenter.shouldUpdate(newCompleted)
        let shouldInsertUncompleted = presenter.shouldUpdate(newUncompleted)
        
        expect(shouldInsertCompleted) == true
        expect(shouldInsertUncompleted) == false
    }
    
    func testShouldRemove() {
        let cellToRemove = spyView.stubbedViewModel[.init(row: 0, section: 0)]
        
        let shouldRemove = presenter.shouldRemove(cellToRemove)
        
        expect(shouldRemove) == true
    }
    
    func testShouldRemoveWithinPredicate() {
        let predicate: (CompletedViewModel) -> Bool = { _ in return true }
        
        let shouldRemoveWithinPredicate = presenter.shouldRemove(next: predicate)
        
        expect(shouldRemoveWithinPredicate) == true
    }
    
    func testShouldRemoveEmptySections() {
        let shouldRemoveEmptySections = presenter.shouldRemoveEmptySections()
        
        expect(shouldRemoveEmptySections) == true
    }
    
    func testInsert() {
        spyView.stubbedViewModel.sections = []
        
        let firstRecentCell = produceTaskModel(factoryTasks.make {
            $0.test_completionDate = dateProvider.now
        })
        let secondRecentCell = produceTaskModel(factoryTasks.make {
            $0.test_completionDate = dateProvider.now.addingTimeInterval(-100)
        })
        let thirdRecentCell = produceTaskModel(factoryTasks.make {
            $0.test_completionDate = dateProvider.now.addingTimeInterval(-10)
        })
        let firstOldCell = produceTaskModel(factoryTasks.make {
            $0.test_completionDate = dateProvider.now.previousWeek
        })
        let secondOldCell = produceTaskModel(factoryTasks.make {
            $0.test_completionDate = dateProvider.now.previousMonth
        })
        
        let sectionIndexOfFirstRecentCell = presenter.insertSectionIfNeed(for: firstRecentCell)
        let sectionIndexOfFirstOldCell = presenter.insertSectionIfNeed(for: firstOldCell)
        let sectionIndexOfSecondRecentCell = presenter.insertSectionIfNeed(for: secondRecentCell)
        let sectionIndexOfSecondOldCell = presenter.insertSectionIfNeed(for: secondOldCell)
        
        let indexOfFirstRecentCell = presenter.insert(firstRecentCell)!
        let indexOfFirstOldCell = presenter.insert(firstOldCell)!
        let indexOfSecondRecentCell = presenter.insert(secondRecentCell)!
        let indexOfSecondOldCell = presenter.insert(secondOldCell)!
        let indexOfThirdRecentCell = presenter.insert(thirdRecentCell)!
        
        expect(sectionIndexOfFirstRecentCell) == 0
        expect(sectionIndexOfSecondRecentCell).to(beNil())
        expect(sectionIndexOfFirstOldCell) == 1
        expect(sectionIndexOfSecondOldCell).to(beNil())
        
        expect(indexOfFirstRecentCell) == .init(row: 0, section: 0)
        expect(indexOfFirstOldCell) == .init(row: 0, section: 1)
        expect(indexOfSecondRecentCell) == .init(row: 1, section: 0)
        expect(indexOfSecondOldCell) == .init(row: 1, section: 1)
        expect(indexOfThirdRecentCell) == .init(row: 1, section: 0)
        
        expectCellAtIndex(firstRecentCell, at: .init(row: 0, section: 0))
        expectCellAtIndex(thirdRecentCell, at: .init(row: 1, section: 0))
        expectCellAtIndex(secondRecentCell, at: .init(row: 2, section: 0))
        expectCellAtIndex(firstOldCell, at: .init(row: 0, section: 1))
        expectCellAtIndex(secondOldCell, at: .init(row: 1, section: 1))
    }
    
    func testUpdate() {
        let expectedIndex = IndexPath(row: 0, section: 0)
        var newCell = spyView.stubbedViewModel[expectedIndex]
        newCell.model.name = "New"
        
        let indexOfUpdate = presenter.update(newCell)!
        
        expect(indexOfUpdate) == expectedIndex
        expectCellAtIndex(newCell, at: indexOfUpdate)
    }
    
    func testRemove() {
        let expectedIndex = IndexPath(row: 0, section: 0)
        let cell = spyView.stubbedViewModel[expectedIndex]
        
        let indexOfRemove = presenter.remove(cell)!
        
        expect(indexOfRemove) == expectedIndex
        expectRemoveCell(cell)
    }
    
    func testRemoveWithinPredicate() {
        let expectedIndex = IndexPath(row: 0, section: 0)
        let cell = spyView.stubbedViewModel[expectedIndex]
        let predicate: (CompletedViewModel) -> Bool = { $0.id == cell.id }
        
        let indexOfRemove = presenter.remove(next: predicate)
        
        expect(indexOfRemove) == expectedIndex
        expectRemoveCell(cell)
        expect(self.presenter.remove(predicate)).to(beNil())
    }
    
    func testRemoveEmptySections() {
        spyView.stubbedViewModel.sections[0].cells.removeAll()
        
        let indexesOfEmptySection = presenter.removeEmptySections()!
        
        expect(indexesOfEmptySection) == .init(integer: 0)
    }
    
    func testShouldContainCell() {
        let cell = spyView.stubbedViewModel[.init(row: 0, section: 0)]
        
        let isContain = presenter.contain(cell)
        
        expect(isContain) == true
    }
    
    func testShouldFindCellIndex() {
        let expectedIndex = IndexPath(row: 0, section: 0)
        let cell = spyView.stubbedViewModel[expectedIndex]
        
        let index = presenter.index(for: cell)
        
        expect(index) == expectedIndex
    }
    
    func testShouldMakeUpdate() {
        let oldCell = spyView.stubbedViewModel[.init(row: 0, section: 0)]
        var newCell = oldCell
        newCell.model.name = "New"
        
        let update = presenter.makeUpdate(newCell: newCell)
        
        expect(update!.old as? CompletedViewModel) == oldCell
        expect(update!.new as? CompletedViewModel) == newCell
    }
    
    private func expectCellAtIndex(_ cell: CompletedViewModel, at index: IndexPath, line: UInt = #line) {
        expect(cell, line: line) == spyView.stubbedViewModel[index]
    }
    
    private func expectCellAtIndex(_ cell: TaskModel, at index: IndexPath, line: UInt = #line) {
        expect(cell, line: line) == spyView.stubbedViewModel[index].model
    }
    
    private func expectRemoveCell(_ cell: CompletedViewModel, line: UInt = #line) {
        expect(self.spyView.stubbedViewModel.allCells.first(where: { $0.id == cell.id }), line: line).to(beNil())
    }
}
