
//
//  ScheduleDataUpdaterTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/28/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class ScheduleDataCoordinatorTestCaseBase: SchedulePresenterTestCaseBase {
    
    var viewModelMock: ScheduleListViewModel!
    var viewModelStub: ScheduleListViewModel!
    
    var stubs: ScheduleCellStubs! = .init()
    
    override func setUp() {
        super.setUp()
        
        let stub = ScheduleViewModelStub()
        viewModelStub = stub
        viewModelMock = stub.mock
    }

    func expectCellAtIndex(_ cell: ScheduleCellViewModel, in viewModel: ScheduleListViewModel, at index: IndexPath, line: UInt = #line) {
        expect(cell, line: line) == viewModel[index]
    }

    func expectCellAtIndex(_ model: TaskModel, in viewModel: ScheduleListViewModel, at index: IndexPath, line: UInt = #line) {
        expect({
            guard case let .task(item) = viewModel[index] else { return .failed(reason: "Its not a task cell") }
            return item == model ? .succeeded : .failed(reason: "The cell contain a wrong model")
        }, line: line).to(succeed())
    }

    func expectRemoveCell(_ cell: ScheduleCellViewModel, in viewModel: ScheduleListViewModel, line: UInt = #line) {
        expect(viewModel.allCells.first(where: { $0.id == cell.id }), line: line).to(beNil())
    }
}

class ScheduleDataCoordinatorStubTestCase: ScheduleDataCoordinatorTestCaseBase {
    
    override func setUp() {
        super.setUp()
        
        spyView.stubbedViewModel = viewModelStub
    }
    
    func testShouldInsert() {
        let newCompleted = stubFactory.produceViewModel(status: ScheduleSection.complete)
        let newUncompleted = stubFactory.produceViewModel(status: ScheduleSection.today)
        let old = viewModelStub.allCells.first!
        let any = 0
        
        let shouldInsertCompleted = presenter.shouldInsert(newCompleted)
        let shouldInsertUncompleted = presenter.shouldInsert(newUncompleted)
        let shouldInsertOld = presenter.shouldInsert(old)
        let shouldInsertAny = presenter.shouldInsert(any)
        
        expect(shouldInsertCompleted) == true
        expect(shouldInsertUncompleted) == true
        expect(shouldInsertOld) == false
        expect(shouldInsertAny) == false
    }
    
    func testShouldInsertTasksWithSelectedProject() {
        schedulePreferences.selectedProjects = [id_group_1]
        let newExpected = stubs.allProjectStubs()[0]
        let newUnexpected = stubs.allProjectStubs()[1]
        
        let shouldInsertExpected = presenter.shouldInsert(newExpected)
        let shouldInsertUnexpected = presenter.shouldInsert(newUnexpected)
        
        expect(shouldInsertExpected) == true
        expect(shouldInsertUnexpected) == false
    }
    
    func testShouldUpdate() {
        let newCompleted = stubFactory.produceViewModel(status: ScheduleSection.complete)
        let newUncompleted = stubFactory.produceViewModel(status: ScheduleSection.today)
        let old = viewModelStub.allCells.first!
        let any = 0
        
        let shouldUpdateCompleted = presenter.shouldUpdate(newCompleted)
        let shouldUpdateUncompleted = presenter.shouldUpdate(newUncompleted)
        let shouldUpdateOld = presenter.shouldUpdate(old)
        let shouldUpdateAny = presenter.shouldUpdate(any)
        
        expect(shouldUpdateCompleted) == true
        expect(shouldUpdateUncompleted) == true
        expect(shouldUpdateOld) == true
        expect(shouldUpdateAny) == false
    }
    
    func testShouldRemove() {
        let cellToRemove = viewModelStub[.init(row: 0, section: 0)]
        
        let shouldRemove = presenter.shouldRemove(cellToRemove)
        
        expect(shouldRemove) == true
    }
    
    func testShouldRemoveWithinPredicate() {
        let predicate: (ScheduleCellViewModel) -> Bool = { _ in return true }
        
        let shouldRemoveWithinPredicate = presenter.shouldRemove(next: predicate)
        
        expect(shouldRemoveWithinPredicate) == true
    }
    
    func testShouldRemoveEmptySections() {
        let shouldRemoveEmptySections = presenter.shouldRemoveEmptySections()
        
        expect(shouldRemoveEmptySections) == true
    }
    
    func testShouldContainCell() {
        let cell = viewModelStub[.init(row: 0, section: 0)]

        let isContain = presenter.contain(cell)

        expect(isContain) == true
    }

    func testShouldFindCellIndex() {
        let expectedIndex = IndexPath(row: 0, section: 0)
        let cell = viewModelStub[expectedIndex]

        let index = presenter.index(for: cell)

        expect(index) == expectedIndex
    }

    func testShouldMakeUpdate() {
        let oldCell = viewModelStub[.init(row: 0, section: 0)]
        var task = oldCell.unwrapTask()!.task
        task.name = "New"
        let newCell = stubFactory.produceViewModel(task)

        let update = presenter.makeUpdate(newCell: newCell)

        expect(update!.old as? ScheduleCellViewModel) == oldCell
        expect(update!.new as? ScheduleCellViewModel) == newCell
    }
}

class ScheduleDataCoordinatorMockTestCase: ScheduleDataCoordinatorTestCaseBase {
    
    override func setUp() {
        super.setUp()
        
        spyView.stubbedViewModel = viewModelMock
    }
    
    func testInsertInScheduleTable() {
        viewModelMock = ScheduleListViewModel(sections: [], title: "", navbarData: [], type: .schedule)
        spyView.stubbedViewModel = viewModelMock
        viewModelStub = ScheduleViewModelStub()

        viewModelStub.allCells.forEach {
            _ = presenter.insertSectionIfNeed(for: $0)
            _ = presenter.insert($0)
        }

        expect(self.viewModelMock.sections) == viewModelStub.sections
    }

    func testInsertInProjectsTable() {
        viewModelMock = ScheduleListViewModel(sections: [], title: "", navbarData: [], type: .project)
        spyView.stubbedViewModel = viewModelMock
        viewModelStub = ScheduleProjectsModelStub()

        viewModelStub.allCells.forEach {
            _ = presenter.insertSectionIfNeed(for: $0)
            _ = presenter.insert($0)
        }

        expect(self.viewModelMock.sections) == viewModelStub.sections
    }

    func testInsertInFlatTable() {
        viewModelMock = ScheduleListViewModel(sections: [], title: "", navbarData: [], type: .flat)
        spyView.stubbedViewModel = viewModelMock
        viewModelStub = ScheduleFlatModelStub()

        viewModelStub.allCells.forEach {
            _ = presenter.insertSectionIfNeed(for: $0)
            _ = presenter.insert($0)
        }

        expect(self.viewModelMock.sections) == viewModelStub.sections
    }

    func testUpdate() {
        let expectedIndex = IndexPath(row: 0, section: 0)
        var newCell = viewModelMock[expectedIndex].unwrapTask()!
        newCell.name = "New"

        let indexOfUpdate = presenter.update(ScheduleCellViewModel.task(newCell))!

        expect(indexOfUpdate) == expectedIndex
        expectCellAtIndex(.task(newCell), in: viewModelMock, at: indexOfUpdate)
    }

    func testRemove() {
        let expectedIndex = IndexPath(row: 0, section: 0)
        let cell = viewModelMock[expectedIndex]

        let indexOfRemove = presenter.remove(cell)!

        expect(indexOfRemove) == expectedIndex
        expectRemoveCell(cell, in: viewModelMock)
    }

    func testRemoveWithinPredicate() {
        let expectedIndex = IndexPath(row: 0, section: 0)
        let cell = viewModelMock[expectedIndex]
        let predicate: (ScheduleCellViewModel) -> Bool = { $0.id == cell.id }

        let indexToRemove = presenter.remove(next: predicate)

        expect(indexToRemove) == expectedIndex
        expectRemoveCell(cell, in: viewModelMock)
        expect(self.presenter.remove(predicate)).to(beNil())
    }

    func testRemoveEmptySections() {
        viewModelMock.sections[0].cells.removeAll()

        let indexesOfEmptySection = presenter.removeEmptySections()!

        expect(indexesOfEmptySection) == .init(integer: 0)
    }
}
