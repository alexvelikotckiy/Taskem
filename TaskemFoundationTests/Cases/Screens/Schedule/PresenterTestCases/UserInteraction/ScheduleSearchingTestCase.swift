//
//  ScheduleSearchingTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 11/6/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class ScheduleSearchingTestCase: SchedulePresenterTestCaseBase {

    override func setUp() {
        super.setUp()
        
        spyView.stubbedViewModel = ScheduleFlatModelStub().mock
        schedulePreferences.typePreference = .flat
        
        spySourceTasks.state = .loaded
        spySourceGroups.state = .loaded
        
        spySourceTasks.allTasks = spyView.stubbedViewModel.allTasksModel.map { $0.task }
        spySourceGroups.allGroups = spyView.stubbedViewModel.allTasksModel.map { $0.group }
        
        presenter.onViewWillAppear()
    }
    
    func testShouldExpandAllSectionsOnBeginEdit() {
        spyView.stubbedViewModel.sections.forEach { $0.isExpanded = false }
        
        presenter.onBeginSearch()
        
        expectExpandedSection(at: 0, isExpanded: true)
        expectExpandedSection(at: 1, isExpanded: true)
        expectState(.searching(""))
    }
    
    func testShouldResolveExpandedSectionsOnEndEdit() {
        schedulePreferences.flatUnexpanded = [.uncomplete]
        presenter.onBeginSearch()
        
        presenter.onEndSearch()
        
        expectInvokedExpandedSection(at: 0, isExpanded: false)
        expectInvokedExpandedSection(at: 1, isExpanded: true)
        expectState(.none)
    }
    
    func testSearch() {
        spySourceTasks.allTasks[0].name = id_group_1
        spySourceTasks.allTasks[0].test_completionDate = Date.now //Prevent to insert a time cell
        presenter.onBeginSearch()
        
        presenter.onSearch(id_group_1)
        
        expectCellWithName(id_group_1)
        expectState(.searching(id_group_1))
    }
    
    private func expectExpandedSection(at index: Int, isExpanded: Bool, line: UInt = #line) {
        expect(self.spyView.stubbedViewModel.sections[index].isExpanded) == isExpanded
    }
    
    private func expectInvokedExpandedSection(at index: Int, isExpanded: Bool, line: UInt = #line) {
        expect(self.spyView.invokedDisplayViewModelParameters?.viewModel.sections[index].isExpanded).toEventually(equal(isExpanded))
    }
    
    private func expectCellWithName(_ name: String, line: UInt = #line) {
        expect(self.spyView.invokedDisplayViewModelParameters?.viewModel.allCells.map { $0.name }, line: line).toEventually(contain(id_group_1))
    }
    
    private func expectState(_ state: SchedulePresenter.State, line: UInt = #line) {
        expect(self.presenter.state, line: line) == state
    }
}
