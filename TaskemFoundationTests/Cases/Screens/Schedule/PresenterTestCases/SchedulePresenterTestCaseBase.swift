//
//  SchedulePresenterTestCaseBase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/25/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import Nimble

class SchedulePresenterTestCaseBase: ScheduleTestCaseBase {
    
    var presenter: SchedulePresenter!
    
    // Test Doubles
    var spyView: ScheduleViewSpy!
    var spyRouter: ScheduleRouterSpy!
    var spyInteractor: ScheduleInteractorSpy!

    var spySourceTasks: TaskSourceSpy!
    var spySourceGroups: GroupSourceSpy!

    var spyTableCoordinator: TableCoordinatorSpy!
    var spyTimer: TimerMock!
    
    var stubsModels: [TaskModel]!
    
    override func setUp() {
        super.setUp()

        spyView = .init()
        spyRouter = .init()
        spyInteractor = .init()
        presenter = .init(view: spyView, router: spyRouter, interactor: spyInteractor)
        
        spyTableCoordinator = .init()
        presenter.coordinator = spyTableCoordinator
        
        spyTimer = .init()
        presenter.timer = spyTimer
        
        spySourceTasks = .init()
        spySourceGroups = .init()
        spyInteractor.sourceTasks = spySourceTasks
        spyInteractor.sourceGroups = spySourceGroups
        
        setupStubs()
    }
    
    private func setupStubs() {
        let stubData = ScheduleCellStubs.init().allTasks()
        stubsModels = stubData.map { $0 }
        
        spySourceTasks.allTasks = stubsModels.map { $0.task }.uniqueElements
        spySourceGroups.allGroups = stubsModels.map { $0.group }.uniqueElements
        spySourceGroups.info = .init(defaultGroup: id_group_1, order: [id_group_1, id_group_2])
    }
    
    func expectViewModelDisplayCount(_ count: Int, file: FileString = #file, line: UInt = #line) {
        expect(self.spyView.invokedDisplayViewModelCount, file: file, line: line).toEventually(equal(count))
    }

    func expectAllDone(_ isVisible: Bool, file: FileString = #file, line: UInt = #line) {
        expect(self.spyView.invokedDisplayAllDoneParameters?.isVisible, file: file, line: line).toEventually(equal(isVisible))
    }

    func expectSpinner(_ isVisible: Bool, file: FileString = #file, line: UInt = #line) {
        expect(self.spyView.invokedDisplaySpinnerParameters?.isVisible, file: file, line: line).toEventually(equal(isVisible))
    }

    func expectEmptyViewModel(file: FileString = #file, line: UInt = #line) {
        expect(self.spyView.invokedDisplayViewModelParameters?.viewModel, file: file, line: line).toEventually(beNil())
    }

    func expectViewModel(_ viewModel: ScheduleListViewModel, file: FileString = #file, line: UInt = #line) {
        expect(self.spyView.invokedDisplayViewModelParameters?.viewModel, file: file, line: line).toEventually(equal(viewModel))
    }
}
