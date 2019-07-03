//
//  ScheduleEditingTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 11/6/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class ScheduleEditingTestCase: SchedulePresenterTestCaseBase {

    override func setUp() {
        super.setUp()
        
        spyView.stubbedViewModel = ScheduleFlatModelStub().mock
        schedulePreferences.typePreference = .flat
        
        spySourceTasks.state = .loaded
        spySourceGroups.state = .loaded
        
        presenter.onViewWillAppear()
    }

    private let testIndex = IndexPath(row: 0, section: 0)
    
    func testShouldExpandAllSectionsOnBeginEdit() {
        spyView.stubbedViewModel.sections.forEach { $0.isExpanded = false }
        
        presenter.onBeginEditing()
        
        expectExpandedSection(at: 0, isExpanded: true)
        expectExpandedSection(at: 1, isExpanded: true)
    }
    
    func testShouldResolveExpandedSectionsOnEndEdit() {
        schedulePreferences.flatUnexpanded = [.uncomplete]
        presenter.onBeginEditing()
        
        presenter.onEndEditing()
        
        expectExpandedSection(at: 0, isExpanded: false)
        expectExpandedSection(at: 1, isExpanded: true)
    }
    
    func testShouldDelete() {
        let id = spyView.viewModel[testIndex].id
        spyRouter.stubbedAlertDeleteCompletionResult = (true, ())
        
        presenter.onEditDelete(at: [testIndex])
        
        expect(self.spyRouter.invokedAlertDelete) == true
        expect(self.spySourceTasks.removedTasks) == [id]
    }
    
    func testShouldChangeGroup() {
        let expectedTask = spyView.viewModel[testIndex].unwrapTask()!.task
        let expectedGroup = GroupFactory().make { $0.id = id_group_1 }
        spyRouter.stubbedPresentGroupPopupCompletionResult = (expectedGroup, ())
        
        presenter.onEditGroup(at: [testIndex])
        
        expect(self.spySourceTasks.updatedTasks.first!.id) == expectedTask.id
        expect(self.spySourceTasks.updatedTasks.first!.idGroup) == expectedGroup.id
    }
    
    func testShouldShare() {
        let expectedTask = spyView.viewModel[testIndex].unwrapTask()!.task
        
        presenter.onShare(at: [testIndex])
        
        expect(self.spyInteractor.didShareTasks!.first) == expectedTask
    }
    
    private func expectExpandedSection(at index: Int, isExpanded: Bool, line: UInt = #line) {
        expect(self.spyView.stubbedViewModel.sections[index].isExpanded) == isExpanded
    }
    
    private func expectInvokedExpandedSection(at index: Int, isExpanded: Bool, line: UInt = #line) {
        expect(self.spyView.invokedDisplayViewModelParameters?.viewModel.sections[index].isExpanded).toEventually(equal(isExpanded))
    }
    
    private func expectState(_ state: SchedulePresenter.State, line: UInt = #line) {
        expect(self.presenter.state, line: line) == state
    }
}
