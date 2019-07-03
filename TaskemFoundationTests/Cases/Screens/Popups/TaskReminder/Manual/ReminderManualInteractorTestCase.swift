//
//  ReminderManualInteractorTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import Nimble
import TaskemFoundation

class ReminderManualInteractorTestCase: TaskemTestCaseBase {

    private var interactor: ReminderManualDefaultInteractor!
    
    // Test Doubles
    private var spyObserver: ReminderManualInteractorObserverSpy!
    
    override func setUp() {
        super.setUp()
        
        spyObserver = .init()
        
        interactor = .init(remindScheduler: RemindScheduleManagerDummy())
        interactor.delegate = spyObserver
    }

    func testShouldBeInteractor() {
        expect(self.interactor).to(beAKindOf(ReminderManualInteractor.self))
    }
    
    func testShouldCallbakOnSuccessGetPermission() {
        interactor.remindScheduler = AuthorizedRemindSchedulerManagerStub()
        
        interactor.registerRemindPermission()
        
        expect(self.spyObserver.invokedRemindermanualIteractorDidGetRemindPermission) == true
    }
    
    func testShouldCallbakOnFailGetPermission() {
        interactor.remindScheduler = UnauthorizedRemindSchedulerManagerStub()
        
        interactor.registerRemindPermission()
        
        expect(self.spyObserver.invokedRemindermanualIteractorDidDiniedRemindPermission) == true
    }
    
    func testShouldCallbakOnSuccessAskPermission() {
        let manager = NotDeterminedRemindSchedulerManagerMock()
        manager.permissionsResult = .allowed
        interactor.remindScheduler = manager
        
        interactor.registerRemindPermission()
        
        expect(self.spyObserver.invokedRemindermanualIteractorDidGetRemindPermission) == true
    }
    
    func testShouldCallbakOnFailAskPermission() {
        let manager = NotDeterminedRemindSchedulerManagerMock()
        manager.permissionsResult = .prohibited
        interactor.remindScheduler = manager
        
        interactor.registerRemindPermission()
        
        expect(self.spyObserver.invokedRemindermanualIteractorDidDiniedRemindPermission) == true
    }
}
