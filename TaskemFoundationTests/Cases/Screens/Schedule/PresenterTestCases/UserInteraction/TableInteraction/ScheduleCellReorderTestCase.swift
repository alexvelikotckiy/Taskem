//
//  ScheduleCellReorderTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 11/2/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class ScheduleCellReorderTestCaseBase: SchedulePresenterTestCaseBase {
    override func setUp() {
        super.setUp()
        
        spyView.stubbedViewModel = ScheduleViewModelStub().mock
    }
    
    fileprivate func expectPostAlert(count: Int, line: UInt = #line) {
        expect(self.spyRouter.invokedAlertViewCount, line: line) == count
    }
    
    fileprivate func expectPauseCoordinator(_ isPaused: Bool, line: UInt = #line) {
        expect(self.spyTableCoordinator.isPaused, line: line) == isPaused
    }
    
    fileprivate func expectPostIncorrentReorder(line: UInt = #line) {
        expect(self.spyRouter.invokedAlertView, line: line) == true
    }
    
    fileprivate func expectMove(cell: ScheduleCellViewModel, to: IndexPath, line: UInt = #line) {
        expect(self.spyView.stubbedViewModel[to], line: line) == cell
    }
    
    fileprivate func expectCell(_ cell: ScheduleCellViewModel, at: IndexPath, line: UInt = #line) {
        expect(self.spyView.stubbedViewModel[at], line: line) == cell
    }
    
    fileprivate func expectUpdateTask(_ cell: ScheduleCellViewModel, at: IndexPath, line: UInt = #line) {
        expect(self.spySourceTasks.lastUpdatedTask?.id, line: line) == cell.unwrapTask()?.id
    }
    
    fileprivate func expectResetPosition(_ cell: ScheduleCellViewModel, line: UInt = #line) {
        expect((self.spyTableCoordinator.updated as? [Update<ScheduleCellViewModel>])?.first?.old, line: line) == cell
        expect((self.spyTableCoordinator.updated as? [Update<ScheduleCellViewModel>])?.first?.new, line: line) == cell
        expect((self.spyTableCoordinator.updated as? [Update<ScheduleCellViewModel>])?.count, line: line) == 1
    }
}

class ScheduleCellReorderCoordinatorStateTestCase: ScheduleCellReorderTestCase {
    func testShouldPauseCoordinatorOnBeginReordering() {
        presenter.onReorderingWillBegin(initial: .init())
        
        expectPauseCoordinator(true)
    }
    
    func testShouldProceedCoordinatorOnEndReordering() {
        presenter.onReorderingWillBegin(initial: .init())
        presenter.onReorderingDidEnd(source: .init(row: 0, section: 0), destination: .init(row: 0, section: 0))
        
        expectPauseCoordinator(false)
    }
}

class ScheduleCellReorderTestCase: ScheduleCellReorderTestCaseBase {
    
    private var overdueIndex: Int!
    private var completedIndex: Int!
    private var todayIndex: Int!
    
    override func setUp() {
        super.setUp()
        
        spyView.stubbedViewModel = ScheduleViewModelStub().mock
        
        overdueIndex = spyView.stubbedViewModel.sections.firstIndex(where: { $0.type.unwrapSchedule()! == .overdue })
        completedIndex = spyView.stubbedViewModel.sections.firstIndex(where: { $0.type.unwrapSchedule()! == .complete })
        todayIndex = spyView.stubbedViewModel.sections.firstIndex(where: { $0.type.unwrapSchedule()! == .today })
        
        schedulePreferences.typePreference = .schedule
    }
    
    func testShouldResetPositionOnReorderToSameSection() {
        let cell = spyView.stubbedViewModel[IndexPath(todayIndex)]
            
        presenter.onReorderingDidEnd(source: .init(todayIndex), destination: .init(todayIndex))
        
        expectMove(cell: cell, to: .init(todayIndex))
        expectResetPosition(cell)
    }
    
    func testShouldAlertAndResetPositionOnReorderToOverdueSection() {
        let cell = spyView.stubbedViewModel[IndexPath(todayIndex)]
        
        presenter.onReorderingDidEnd(source: .init(todayIndex), destination: .init(overdueIndex))
        
        expectMove(cell: cell, to: .init(overdueIndex))
        expectPostAlert(count: 1)
        expectResetPosition(cell)
    }
    
    func testShouldUpdateOnReorderToValidSection() {
        let cell = spyView.stubbedViewModel[IndexPath(todayIndex)]
        
        presenter.onReorderingDidEnd(source: .init(todayIndex), destination: .init(completedIndex))
        
        expectMove(cell: cell, to: .init(completedIndex))
        expectUpdateTask(cell, at: .init(completedIndex))
    }
}

class ScheduleProjectCellReorderTestCase: ScheduleCellReorderTestCaseBase {
    
    private var group_1_index: Int!
    private var group_2_index: Int!
    
    override func setUp() {
        super.setUp()
        
        spyView.stubbedViewModel = ScheduleProjectsModelStub().mock
        
        group_1_index = spyView.stubbedViewModel.sections.firstIndex(where: { $0.type.unwrapProject()! == id_group_1 })
        group_2_index = spyView.stubbedViewModel.sections.firstIndex(where: { $0.type.unwrapProject()! == id_group_2 })
        
        schedulePreferences.typePreference = .project
    }
    
    func testShouldResetPositionOnReorderToSameSection() {
        let cell = spyView.stubbedViewModel[IndexPath(group_1_index)]
        
        presenter.onReorderingDidEnd(source: .init(group_1_index), destination: .init(group_1_index))
        
        expectMove(cell: cell, to: .init(group_1_index))
        expectResetPosition(cell)
    }
    
    func testShouldUpdateOnReorderToValidSection() {
        let cell = spyView.stubbedViewModel[IndexPath(group_1_index)]
        
        presenter.onReorderingDidEnd(source: .init(group_1_index), destination: .init(group_2_index))
        
        expectMove(cell: cell, to: .init(group_2_index))
        expectUpdateTask(cell, at: .init(group_2_index))
    }
}

class ScheduleFlatCellReorderTestCase: ScheduleCellReorderTestCaseBase {
    
    private var uncompletedIndex: Int!
    private var completedIndex: Int!
    
    override func setUp() {
        super.setUp()
        
        spyView.stubbedViewModel = ScheduleFlatModelStub().mock
        
        uncompletedIndex = spyView.stubbedViewModel.sections.firstIndex(where: { $0.type.unwrapFlat()! == .uncomplete })
        completedIndex = spyView.stubbedViewModel.sections.firstIndex(where: { $0.type.unwrapFlat()! == .complete })
        
        schedulePreferences.typePreference = .flat
    }
    
    func testShouldResetPositionOnReorderToSameSection() {
        let cell = spyView.stubbedViewModel[IndexPath(uncompletedIndex)]
        
        presenter.onReorderingDidEnd(source: .init(uncompletedIndex), destination: .init(uncompletedIndex))
        
        expectMove(cell: cell, to: .init(uncompletedIndex))
        expectResetPosition(cell)
    }
    
    func testShouldUpdateOnReorderToValidSection() {
        let cell = spyView.stubbedViewModel[IndexPath(uncompletedIndex)]
        
        presenter.onReorderingDidEnd(source: .init(uncompletedIndex), destination: .init(completedIndex))
        
        expectMove(cell: cell, to: .init(completedIndex))
        expectUpdateTask(cell, at: .init(completedIndex))
    }
}

fileprivate extension IndexPath {
    init(_ section: Int) {
        self.init(row: 0, section: section)
    }
}
