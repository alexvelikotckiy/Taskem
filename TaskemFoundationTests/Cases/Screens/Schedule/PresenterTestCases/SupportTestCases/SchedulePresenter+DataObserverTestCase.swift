//
//  ScheduleDataObserverTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/25/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class ScheduleDataObserverTestCaseBase: SchedulePresenterTestCaseBase {
    
    var viewModelMock: ScheduleListViewModel!
    
    var sectionWithTime: ScheduleSectionViewModel!
    var sectionWithoutTime: ScheduleSectionViewModel!
    var sectionWithTimeOnly: ScheduleSectionViewModel!
    
    override func setUp() {
        super.setUp()

        viewModelMock = ScheduleViewModelStub().mock
        spyView.stubbedViewModel = viewModelMock
                
        sectionWithTime = stubFactory.sectionWithTime
        sectionWithoutTime = stubFactory.sectionWithoutTime
        sectionWithTimeOnly = stubFactory.sectionWithTimeOnly
    }
    
    func expectInsertTime(notify: Bool, line: UInt = #line) {
        expect((self.spyTableCoordinator.inserted as? [CalendarTimeCell])?.first?.id, line: line) == "Time"
        expect((self.spyTableCoordinator.inserted as? [CalendarTimeCell])?.count, line: line) == 1
        expect(self.spyTableCoordinator.didNotifyLastAction, line: line) == notify
    }

    func expectTimeUpdate(_ date: Date, notify: Bool, line: UInt = #line) {
        expect((self.spyTableCoordinator.updated as? [CalendarTimeCell])?.first?.id, line: line) == "Time"
        expect((self.spyTableCoordinator.updated as? [CalendarTimeCell])?.first?.date.hour, line: line) == date.hour
        expect((self.spyTableCoordinator.updated as? [CalendarTimeCell])?.first?.date.minutes, line: line) == date.minutes
        expect((self.spyTableCoordinator.updated as? [CalendarTimeCell])?.count, line: line) == 1
        expect(self.spyTableCoordinator.didNotifyLastAction, line: line) == notify
    }

    func expectRemoveCells(_ removed: [ScheduleCellViewModel], nofity: Bool, line: UInt = #line) {
        expect(self.spyTableCoordinator.removed as? [ScheduleCellViewModel], line: line) == removed
        expect(self.spyTableCoordinator.didNotifyLastAction, line: line) == nofity
    }

    func expectHeaderReload(at indexes: [Int], models sections: [ScheduleSectionViewModel], line: UInt = #line) {
        expect(self.spyView.invokedDisplayHeaderParametersList.map { $0.index }) == indexes
        expect(self.spyView.invokedDisplayHeaderParametersList.map { $0.model }) == sections
    }

    func performObserverActions() {
        presenter.didInsertRow(at: .init())
        presenter.didDeleteRow(at: .init())
        presenter.didUpdateRow(at: .init())
        presenter.didDeleteRow(at: .init())
        presenter.didInsertSections(at: .init())
        presenter.didDeleteSections(at: .init())
        presenter.didMoveRow(from: .init(), to: .init())
    }
}

class ScheduleTimeDataObserverTestCase: ScheduleDataObserverTestCaseBase {
    override func setUp() {
        super.setUp()
        
        presenter.onViewWillAppear()
    }
    
    func testShouldStartTimer() {
        presenter.startTimer()
        
        expect(self.presenter.timer.isValid) == true
    }
    
    func testShouldStopTimer() {
        presenter.startTimer()
        presenter.stopTimer()
        
        expect(self.presenter.timer.isValid) == false
    }
    
    func testInsertTimInExpandedSectionWithinTimerCycle() {
        sectionWithoutTime.isExpanded = true
        viewModelMock.sections = [sectionWithoutTime]
        
        dateProvider.now = dateProvider.now.addingTimeInterval(60)
        spyTimer.tick()
        
        expectInsertTime(notify: true)
    }
    
    func testInsertTimeInUnexpandedSectionWithinTimerCycle() {
        sectionWithoutTime.isExpanded = false
        viewModelMock.sections = [sectionWithoutTime]
        
        dateProvider.now = dateProvider.now.addingTimeInterval(60)
        spyTimer.tick()
        
        expectInsertTime(notify: false)
    }
    
    func testUpdateTimeInExpandedSectionWithinTimerCycle() {
        sectionWithTime.isExpanded = true
        viewModelMock.sections = [sectionWithTime]
        
        dateProvider.now = dateProvider.now.addingTimeInterval(60)
        spyTimer.tick()
        
        expectTimeUpdate(dateProvider.now, notify: true)
    }
    
    func testUpdateTimeInUnexpandedSectionWithinTimerCycle() {
        sectionWithTime.isExpanded = false
        viewModelMock.sections = [sectionWithTime]
        
        dateProvider.now = dateProvider.now.addingTimeInterval(60)
        spyTimer.tick()
        
        expectTimeUpdate(dateProvider.now, notify: false)
    }
    
    func testShouldReloadAllOnMidnight() {
        dateProvider.now = dateProvider.now.endOfDate
        spyTimer.tick()
        dateProvider.now = dateProvider.now.tomorrow.startOfDay
        spyTimer.tick()
        
        expect(self.spyView.invokedDisplayViewModelCount) == 1
    }
    
    func testAfterSectionInsertionShouldCheckIfInsertTime() {
        viewModelMock.sections = [sectionWithoutTime]
        
        presenter.didInsertSections(at: .init(integer: 0))
        
        expectInsertTime(notify: true)
    }
    
    func testAfterCellsInsertionShouldCheckIfInsertTime() {
        viewModelMock.sections = [sectionWithoutTime]
        
        presenter.didInsertRow(at: .init(row: 0, section: 0))
        
        expectInsertTime(notify: true)
    }
    
    func testAfterCellsDeletionWhenSectionExpandedShouldRemoveSingleTimeCellInSection() {
        viewModelMock.sections = [sectionWithTimeOnly]
        viewModelMock.sections[0].isExpanded = true
        
        presenter.didDeleteRow(at: .init(row: 0, section: 0))
        
        expectRemoveCells(viewModelMock.sections[0].cells, nofity: true)
    }
    
    func testAfterCellsDeletionWhenSectionCollapsedShouldRemoveSingleTimeCellInSection() {
        viewModelMock.sections = [sectionWithTimeOnly]
        viewModelMock.sections[0].isExpanded = false
        
        presenter.didDeleteRow(at: .init(row: 0, section: 0))
        
        expectRemoveCells(viewModelMock.sections[0].cells, nofity: false)
    }
    
    func testAfterCellsRearrangeShouldRemoveSingleTimeCellInSection() {
        viewModelMock.sections[0].cells = [stubFactory.produceViewModelTime()]
        viewModelMock.sections[0].isExpanded = true
        
        presenter.didMoveRow(from: .init(row: 0, section: 0), to: .init(row: 0, section: 1))
        
        expectRemoveCells(viewModelMock.sections[0].cells, nofity: true)
    }
}

class ScheduleDataObserverTestCase: ScheduleDataObserverTestCaseBase {
    func testShouldBeTableCoordinatorObserver() {
        expect(self.presenter).to(beAKindOf(TableCoordinatorObserver.self))
    }
    
    func testReloadHeaderAfterCellsInsertion() {
        let index = IndexPath(row: 0, section: 0)
        
        presenter.didInsertRow(at: index)
        
        expectHeaderReload(at: [index.section], models: [viewModelMock[index.section]])
    }
    
    func testReloadHeaderAfterCellsDeletion() {
        let index = IndexPath(row: 0, section: 0)
        
        presenter.didDeleteRow(at: index)
        
        expectHeaderReload(at: [index.section], models: [viewModelMock[index.section]])
    }
    
    func testReloadHeaderAfterCellsRearrange() {
        let indexes = [IndexPath(row: 0, section: 0), IndexPath(row: 0, section: 1)]
        
        presenter.didMoveRow(from: indexes[0], to: indexes[1])
        
        expectHeaderReload(at: indexes.map { $0.section } , models: [viewModelMock[0], viewModelMock[1]])
    }
    
    func testNotDisplayAllDoneWithinNotEmptyList() {
        viewModelMock.sections = [sectionWithTime]
        
        performObserverActions()
        
        expect(self.spyView.invokedDisplayAllDoneParametersList.map { $0.isVisible }.uniqueElements).toNot(contain([true]))
    }
    
    func testDisplayAllDoneWithinEmptyList() {
        viewModelMock.sections = []
        
        performObserverActions()
        
        expect(self.spyView.invokedDisplayAllDoneParametersList.map { $0.isVisible }.uniqueElements).toNot(contain([false]))
    }
}
