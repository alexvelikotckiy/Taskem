//
//  ReminderManualPresenterTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import Nimble
import TaskemFoundation

class ReminderManualPresenterBaseTestCase: TaskemTestCaseBase {

    fileprivate var presenter: ReminderManualPresenter!
    
    fileprivate var spyView: ReminderManualViewSpy!
    fileprivate var spyRouter: ReminderManualRouterSpy!
    fileprivate var spyInteractor: ReminderManualInteractorSpy!
    
    fileprivate var initialData: ReminderManualPresenter.InitialData!
    
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

class ReminderManualPresenterTestCase: ReminderManualPresenterBaseTestCase {
    override func setUp() {
        super.setUp()

        spyView.stubbedViewModel = ReminderManualViewModelStub().mock
        spyView.stubbedViewModel.reminder = initialData.reminder
    }
    
    func testShouldBeInteractorObserver() {
        expect(self.presenter).to(beAKindOf(ReminderManualInteractorOutput.self))
        expect(self.spyInteractor.invokedDelegate) === presenter
    }
    
    func testShouldBeViewDelegate() {
        expect(self.presenter).to(beAKindOf(ReminderManualViewDelegate.self))
        expect(self.spyView.invokedDelegate) === presenter
    }
    
    func testBackAndDismiss() {
        presenter.onViewWillDismiss()
        
        expect(self.callbackResult).to(beNil())
        expect(self.callbackCallCount) == 1
    }
    
    func testDisplayViewModelOnAppear() {
        presenter.onViewWillAppear()
        
        expect(self.spyView.invokedDisplayParameters?.viewModel) == spyView.stubbedViewModel
    }
    
    func testAskRemindPermission() {
        presenter.onTouchSave()
        
        expect(self.spyInteractor.invokedRegisterRemindPermission) == true
    }
    
    func testChangeAndSaveTime() {
        presenter.onChangeTime(date: DateProvider.current.now.addingTimeInterval(1))
        
        expect(self.spyView.viewModel.reminder.trigger.relativeOffset) == 1
        expect(self.spyView.invokedReloadParameters?.index) == .init(row: 0, section: 0)
        expect(self.spyView.viewModel.reminder.id) == initialData.reminder.id
    }
}

class ReminderManualPresenterInteractorOutputTestCase: ReminderManualPresenterBaseTestCase {
    override func setUp() {
        super.setUp()
        
        spyView.stubbedViewModel = .init(sections: [], reminder: initialData.reminder)
    }
    
    func testDismissAndCallbackOnSuccessGetPermission() {
        presenter.remindermanualIteractorDidGetRemindPermission(ReminderManualInteractorDummy())
        
        expect(self.spyRouter.invokedDismiss) == true
        expect(self.callbackResult) == initialData.reminder
    }
    
    func testAlertOnFailGetPermission() {
        spyRouter.shouldInvokeAlertCompletion = true
        
        presenter.remindermanualIteractor(ReminderManualInteractorDummy(), didFailGetRemindPermission: nil)
        
        expect(self.spyRouter.invokedAlert) == true
        expect(self.spyRouter.invokedDismiss) == true
    }
    
    func testAlertOnDenyGetPermission() {
        spyRouter.shouldInvokeAlertCompletion = true
        
        presenter.remindermanualIteractorDidDiniedRemindPermission(ReminderManualInteractorDummy())
        
        expect(self.spyRouter.invokedAlert) == true
        expect(self.spyRouter.invokedDismiss) == true
    }
}
