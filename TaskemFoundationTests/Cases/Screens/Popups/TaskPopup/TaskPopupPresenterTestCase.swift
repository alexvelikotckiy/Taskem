//
//  TaskPopupPresenterTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 11/7/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import Nimble

class TaskPopupPresenterTestCaseBase: TaskemTestCaseBase {
    
    fileprivate var presenter: TaskPopupPresenter!
    
    fileprivate var spyView: TaskPopupViewSpy!
    fileprivate var spyRouter: TaskPopupRouterSpy!
    fileprivate var spyInteractor: TaskPopupInteractorSpy!
    
    fileprivate var spySourceTasks: TaskSourceSpy!
    fileprivate var spySourceGroups: GroupSourceSpy!
    
    override func setUp() {
        super.setUp()
        
        spySourceTasks = .init()
        spySourceGroups = .init()
        
        spyView = .init()
        spyRouter = .init()
        spyInteractor = .init(sourceTasks: spySourceTasks, sourceGroups: spySourceGroups)
        presenter = .init(view: spyView, router: spyRouter, interactor: spyInteractor, data: .initialize { $0.name = "qwerty" })
        
        setupStubs()
    }
    
    private func setupStubs() {
        spySourceGroups.allGroups = [GroupSourceMock.inboxDefaultGroup]
    }
    
    func expectViewModelDisplayCount(_ count: Int, file: FileString = #file, line: UInt = #line) {
        expect(self.spyView.displayViewModelCount, file: file, line: line).toEventually(equal(count))
    }
}

class TaskPopupPresenterTestCase: TaskPopupPresenterTestCaseBase {
    override func setUp() {
        super.setUp()
        
        spyView.viewModel = TaskPopupViewModelStub().mock
    }
    
    func testShouldBeInteractorObserver() {
        expect(self.presenter).to(beAKindOf(TaskPopupInteractorOutput.self))
        expect(self.spyInteractor.delegate) === presenter
    }
    
    func testShouldBeViewDelegate() {
        expect(self.presenter).to(beAKindOf(TaskPopupViewDelegate.self))
        expect(self.spyView.delegate) === presenter
    }
    
    func testStartInteractorOnLoad() {
        presenter.onViewWillAppear()
        presenter.onViewWillAppear()
        
        expect(self.spyInteractor.didStartCall) == 1
    }
    
    func testDiplayInitialValuesOnFirstLoad() {
        presenter.onViewWillAppear()
        
        expectName("qwerty")
    }
    
    func testDoNotDisplayInitialValuesOnSecondLoad() {
        presenter.onViewWillAppear()
        presenter.onChangeName(text: "azerty")
        
        presenter.onViewWillAppear()
        
        expectName("azerty")
    }
    
    func testChangeDateAndReminderTagOnCalendarCallback() {
        let expected = DatePreferences(assumedDate: dateProvider.now, isAllDay: true)
        spyRouter.stubbedPresentCalendarPopupCompletionResult = (expected, ())
        
        presenter.onTouchCalendar()
        
        expect(self.spyRouter.invokedPresentCalendarPopup) == true
        expect(self.spyView.viewModel.currentReminder?.remindDate) == expected.date
        expectDate(expected)
        expectReloadView()
    }
    
    func testChangeProjectOnPickerCallback() {
        let expected = Group(name: "")
        spyRouter.stubbedPresentGroupPopupCompletionResult = (expected, ())
        
        presenter.onTouchProject()
        
        expect(self.spyRouter.invokedPresentGroupPopup) == true
        expectProject(expected)
        expectReloadView()
    }
    
    func testChangeRepeatOnPickerCallback() {
        let expected = RepeatPreferences(rule: .daily)
        spyRouter.stubbedPresentRepeatPickerCallbackResult = (expected, ())
        
        presenter.onTouchRepeat()
        
        expectRepeat(expected)
        expectReloadView()
    }
    
    func testOnChangeRepeatAddDateIfNeed() {
        spyView.viewModel = .init()
        spyRouter.stubbedPresentRepeatPickerCallbackResult = (.init(), ())
        
        presenter.onTouchRepeat()
        
        expectDate(.init(assumedDate: dateProvider.now.tomorrow.morning, isAllDay: false))
    }
    
    func testChangeReminderOnPickerCallback() {
        let expected = Reminder()
        spyRouter.stubbedPresentReminderTemplatesCallbackResult = (expected, ())
        
        presenter.onTouchReminder()
        
        expectReminder(expected)
        expectReloadView()
    }
    
    func testAddDateTagIfNeedOnChangeReminder() {
        spyView.viewModel = .init()
        spyRouter.stubbedPresentReminderManualCallbackResult = (.init(), ())
        
        presenter.onTouchReminder()
        
        expectDate(.init(assumedDate: dateProvider.now.tomorrow.morning, isAllDay: false))
    }
    
    func testInsertTask() {
        presenter.onTouchAdd()
        
        expect(self.spySourceTasks.addedTasks.count) == 1
    }
    
    func testShouldClearNameAfterInsertTask() {
        presenter.onTouchAdd()
        
        expectName("")
    }
    
    func testShouldNotRemoveProjectTag() {
        presenter.onTouchRemoveTag(at: 0)
        
        expectReloadView()
        expect(self.spyView.viewModel.currentProject).toNot(beNil())
    }
    
    func testShouldRemoveReminderAndRepeatTagWithinDateTag() {
        presenter.onTouchRemoveTag(at: 1)
        
        expectDate(nil)
        expectRepeat(nil)
        expectReminder(nil)
        expectReloadView()
    }
    
    func testShouldRemoveRepeat() {
        presenter.onTouchRemoveTag(at: 2)
        
        expectRepeat(nil)
    }
    
    func testSholdRemoveReminder() {
        presenter.onTouchRemoveTag(at: 3)
        
        expectReminder(nil)
    }
    
    func testDismissOnCancel() {
        presenter.onTouchCancel()
        
        expect(self.spyRouter.invokedDismiss) == true
    }

    private func expectName(_ value: String, line: UInt = #line) {
        expect(self.spyView.viewModel.name, line: line) == value
    }
    
    private func expectReminder(_ value: Reminder?, line: UInt = #line) {
        if let value = value {
            expect(self.spyView.viewModel.currentReminder, line: line) == value
        } else {
            expect(self.spyView.viewModel.currentReminder, line: line).to(beNil())
        }
    }
    
    private func expectRepeat(_ value: RepeatPreferences?, line: UInt = #line) {
        if let value = value {
            expect(self.spyView.viewModel.currentRepetition, line: line) == value
        } else {
            expect(self.spyView.viewModel.currentRepetition, line: line).to(beNil())
        }
    }
    
    private func expectProject(_ value: Group?, line: UInt = #line) {
        if let value = value {
            expect(self.spyView.viewModel.currentProject, line: line) == value
        } else {
            expect(self.spyView.viewModel.currentProject, line: line).to(beNil())
        }
    }
    
    private func expectDate(_ value: DatePreferences?, line: UInt = #line) {
        if let value = value {
            expect(self.spyView.viewModel.currentDateAntTime, line: line) == value
        } else {
            expect(self.spyView.viewModel.currentDateAntTime, line: line).to(beNil())
        }
    }
    
    private func expectReloadView(line: UInt = #line) {
        expect(self.spyView.reloadCount, line: line) == 1
    }
}

class TaskPopupPresenterInteractorOutputTestCase: TaskPopupPresenterTestCaseBase {
    override func setUp() {
        super.setUp()
        
        presenter.onViewWillAppear()
    }
    
    func testShouldReloadOnLoadGroups() {
        presenter.interactorDidChangeStateGroups(spyInteractor, state: .loaded)
        
        expectViewModelDisplayCount(1)
    }
    
    func testShouldReloadOnUpdateGroups() {
        presenter.interactor(spyInteractor, didUpdate: Array<Group>())
        
        expectViewModelDisplayCount(1)
    }
    
    func testShouldReloadOnRemoveGroups() {
        presenter.interactor(spyInteractor, didRemoveGroups: [])
        
        expectViewModelDisplayCount(1)
    }
}
