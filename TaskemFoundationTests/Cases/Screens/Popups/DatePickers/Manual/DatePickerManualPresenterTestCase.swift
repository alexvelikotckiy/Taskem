//
//  DatePickerManualPresenterTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/12/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class DatePickerManualBaseTestCase: TaskemTestCaseBase {

    fileprivate var presenter: DatePickerManualPresenter!
    
    fileprivate var spyView: DatePickerManualViewSpy!
    fileprivate var spyRouter: DatePickerManualRouterSpy!
    
    fileprivate var initialData: DatePickerManualPresenter.InitialData!
    
    fileprivate var callback: DatePickerCallback!
    fileprivate var callbackResult: DatePreferences?
    fileprivate var callbackCallCount = 0
    
    override func setUp() {
        super.setUp()
        
        spyView = .init()
        spyRouter = .init()
        
        callback = { [weak self] in
            self?.callbackResult = $0
            self?.callbackCallCount += 1
        }
        
        initialData = .initialize {
            $0.dateConfig = .init(assumedDate: Date.now, isAllDay: true)
            $0.screen = .time
        }
        
        presenter = .init(
            view: spyView,
            router: spyRouter,
            interactor: DatePickerManualInteractorDummy(),
            data: initialData,
            callback: callback
        )
    }
    
    override func tearDown() {
        callbackResult = nil
        
        super.tearDown()
    }
}

class DatePickerManualPresenterOnLoadTestCase: DatePickerManualBaseTestCase {
    
    func testShouldBeInteractorObserver() {
        expect(self.presenter).to(beAKindOf(DatePickerManualInteractorOutput.self))
    }
    
    func testShouldBeViewDelegate() {
        expect(self.presenter).to(beAKindOf(DatePickerManualViewDelegate.self))
        expect(self.spyView.invokedDelegate) === presenter
    }
    
    func testDiplayInitialValuesOnFirstLoad() {
        presenter.onViewWillAppear()
        
        expect(self.spyView.invokedDisplayParameters?.viewModel.datePreferences) == initialData.dateConfig
        expect(self.spyView.invokedDisplayParameters?.viewModel.mode) == initialData.screen
    }
}

class DatePickerManualPresenterUserIneractionTestCase: DatePickerManualBaseTestCase {
    
    override func setUp() {
        super.setUp()
        
        presenter.onViewWillAppear()
        
        spyView.stubbedViewModel = DatePickerManualViewModelStub().viewModel
    }
    
    func testEmptyCallbackOnDismiss() {
        presenter.onViewWillDismiss()
        
        expect(self.callbackResult).to(beNil())
        expect(self.callbackCallCount) == 1
    }
    
    func testSelectDate() {
        presenter.onSelect(date: dateProvider.now.tomorrow, on: .calendar)
        
        expectDate(dateProvider.now.tomorrow)
        expectMode(.calendar)
    }
    
    func testSelectTime() {
        presenter.onSelect(date: dateProvider.now.addingTimeInterval(1), on: .time)
        
        expectDate(dateProvider.now.addingTimeInterval(1))
        expectMode(.time)
    }
    
    func testSwitchPickers() {
        spyView.stubbedViewModel.mode = .calendar
        
        presenter.onTouchChangePicker(.time)
        
        expectMode(.time)
        //
        spyView.stubbedViewModel.mode = .time
        
        presenter.onTouchChangePicker(.calendar)
        
        expectMode(.calendar)
    }
    
    func testShowCurrentDate() {
        spyView.stubbedViewModel.datePreferences.date = dateProvider.now.tomorrow
        spyView.stubbedViewModel.mode = .calendar
        
        presenter.onTouchChangePicker(.calendar)
        
        expect(self.spyView.invokedScrollToDateParameters?.date) == spyView.stubbedViewModel.date
    }
    
    func testShowCurrentTime() {
        spyView.stubbedViewModel.datePreferences.date = dateProvider.now.addingTimeInterval(1)
        spyView.stubbedViewModel.mode = .time
        
        presenter.onTouchChangePicker(.time)
        
        expect(self.spyView.invokedScrollToTimeParameters?.date) == dateProvider.now
    }
    
    func testSwitchAllDay() {
        spyView.stubbedViewModel.mode = .time
        
        presenter.onSwitchTime(isAllDay: true)
        
        expectMode(.calendar)
        expectAllday(true)
        //
        spyView.stubbedViewModel.mode = .time
        
        presenter.onSwitchTime(isAllDay: false)
        
        expectMode(.calendar)
        expectAllday(false)
    }
    
    func testSave() {
        spyRouter.shouldInvokeDismissCompletion = true
    
        presenter.onTouchSave()
        
        expect(self.spyRouter.invokedDismiss) == true
        expect(self.callbackResult) == spyView.stubbedViewModel.datePreferences
    }
    
    private func expectMode(_ value: DatePickerManualViewModel.Screen, line: UInt = #line) {
        expect(self.spyView.invokedDisplayParameters?.viewModel.mode, line: line) == value
    }
    
    private func expectDate(_ value: Date, line: UInt = #line) {
        expect(self.spyView.invokedDisplayParameters?.viewModel.datePreferences.date, line: line) == value
    }
    
    private func expectAllday(_ value: Bool, line: UInt = #line) {
        expect(self.spyView.invokedDisplayParameters?.viewModel.isAllDay, line: line) == value
    }
}
