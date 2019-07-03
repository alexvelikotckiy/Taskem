//
//  ReminderTemplatesPresenterTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import Nimble
import TaskemFoundation

class ReminderTemplatesPresenterBaseTestCase: TaskemTestCaseBase {

    fileprivate var presenter: ReminderTemplatesPresenter!
    
    // Test Doubles
    fileprivate var spyView: ReminderTemplatesViewSpy!
    fileprivate var spyRouter: ReminderTemplatesRouterSpy!
    fileprivate var spyInteractor: ReminderTemplatesInteractorSpy!
    
    fileprivate var initialData: ReminderTemplatesPresenter.InitialData!

    fileprivate var callback: TaskReminderCallback!
    fileprivate var callbackResult: Reminder?
    fileprivate var callbackCallCount = 0
    
    override func setUp() {
        super.setUp()
        
        spyView = .init()
        spyRouter = .init()
        spyInteractor = .init()
        
        initialData = .initialize {
            $0.datePreferences = .init(assumedDate: dateProvider.now, isAllDay: false)
            $0.reminder = .init(id: .auto(), trigger: .init(absoluteDate: dateProvider.now, relativeOffset: 0))
        }
        
        callback = { [weak self] in
            self?.callbackResult = $0
            self?.callbackCallCount += 1
        }
        
        presenter = .init(
            view: spyView,
            router: spyRouter,
            interactor: spyInteractor,
            data: initialData,
            callback: callback
        )
    }
    
    override func tearDown() {
        callbackResult = nil
        
        super.tearDown()
    }
}

class ReminderTemplatesPresenterTestCase: ReminderTemplatesPresenterBaseTestCase {
    override func setUp() {
        super.setUp()
        
        spyView.stubbedViewModel = ReminderTemplatesViewModelStub().mock
    }
    
    func testShouldBeInteractorObserver() {
        expect(self.presenter).to(beAKindOf(ReminderTemplatesInteractorOutput.self))
    }
    
    func testShouldBeViewDelegate() {
        expect(self.presenter).to(beAKindOf(ReminderTemplatesViewDelegate.self))
        expect(self.spyView.invokedDelegate) === presenter
    }
    
    func testDisplayViewModelOnAppear() {
        presenter.onViewWillAppear()
        
        ReminderRule.allCases.forEach { expectViewModelContainCellWithRule($0) }
    }
    
    func testBackAndDismiss() {
        presenter.onTouchBack()
        
        expect(self.callbackResult).to(beNil())
        expect(self.callbackCallCount) == 1
    }
    
    func testPresentManualSetup() {
        presenter.onTouchCell(at: .init(row: 1, section: 0))
        
        expect(self.spyRouter.invokedPresentManual) == true
        expect(self.spyRouter.invokedPresentManualParameters?.data.datePreferences) == initialData.datePreferences
        expect(self.spyRouter.invokedPresentManualParameters?.data.reminder) == initialData.reminder
    }
    
    func testAskRemindPermission() {
        presenter.onTouchCell(at: .init(row: 0, section: 0))
        
        expect(self.spyInteractor.invokedRegisterRemindPermission) == true
    }
    
    func testResolveReminderTriggerOnSelection() {
        presenter.onTouchCell(at: .init(row: 0, section: 0))
        
        expect(self.spyView.viewModel.reminder.trigger.relativeOffset) == -300
    }
    
    private func expectViewModelContainCellWithRule(_ rule: ReminderRule, line: UInt = #line) {
        expect({
            guard self.spyView.invokedDisplayParameters!.viewModel.allCells.contains(where: { $0.model == rule }) else {
                return .failed(reason: "Should contain cell with a reminder rule")
            }
            return .succeeded
        }, line: line).to(succeed())
    }
}

class ReminderTemplatesPresenterInteractorOutputTestCase: ReminderTemplatesPresenterBaseTestCase {
    override func setUp() {
        super.setUp()
        
        spyView.stubbedViewModel = .init(reminder: initialData.reminder, sections: [])
    }
    
    func testDismissAndCallbackOnSuccessGetPermission() {
        presenter.remindertemplatesIteractorDidGetRemindPermission(ReminderTemplatesInteractorDummy())
        
        expect(self.spyRouter.invokedDismiss) == true
        expect(self.callbackResult) == initialData.reminder
    }
    
    func testAlertOnFailGetPermission() {
        spyRouter.shouldInvokeAlertCompletion = true
        
        presenter.remindertemplatesIteractor(ReminderTemplatesInteractorDummy(), didFailGetRemindPermission: nil)
        
        expect(self.spyRouter.invokedAlert) == true
        expect(self.spyRouter.invokedDismiss) == true
    }
    
    func testAlertOnDenyGetPermission() {
        spyRouter.shouldInvokeAlertCompletion = true
        
        presenter.remindertemplatesIteractorDidDiniedRemindPermission(ReminderTemplatesInteractorDummy())
        
        expect(self.spyRouter.invokedAlert) == true
        expect(self.spyRouter.invokedDismiss) == true
    }
}
