//
//  ReminderManualInteractorDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class ReminderManualInteractorDummy: ReminderManualInteractor {
    var delegate: ReminderManualInteractorOutput? {
        set {
        }
        get {
            return nil
        }
    }
    func registerRemindPermission() {
    }
}

class ReminderManualInteractorSpy: ReminderManualInteractorDummy {
    var invokedDelegateSetter = false
    var invokedDelegateSetterCount = 0
    var invokedDelegate: ReminderManualInteractorOutput?
    var invokedDelegateList = [ReminderManualInteractorOutput?]()
    var invokedDelegateGetter = false
    var invokedDelegateGetterCount = 0
    var stubbedDelegate: ReminderManualInteractorOutput!
    override var delegate: ReminderManualInteractorOutput? {
        set {
            invokedDelegateSetter = true
            invokedDelegateSetterCount += 1
            invokedDelegate = newValue
            invokedDelegateList.append(newValue)
        }
        get {
            invokedDelegateGetter = true
            invokedDelegateGetterCount += 1
            return stubbedDelegate
        }
    }
    var invokedRegisterRemindPermission = false
    var invokedRegisterRemindPermissionCount = 0
    override func registerRemindPermission() {
        invokedRegisterRemindPermission = true
        invokedRegisterRemindPermissionCount += 1
    }
}

class ReminderManualInteractorObserverSpy: ReminderManualInteractorOutput {
    var invokedRemindermanualIteractorDidGetRemindPermission = false
    var invokedRemindermanualIteractorDidGetRemindPermissionCount = 0
    var invokedRemindermanualIteractorDidGetRemindPermissionParameters: (interactor: ReminderManualInteractor, Void)?
    var invokedRemindermanualIteractorDidGetRemindPermissionParametersList = [(interactor: ReminderManualInteractor, Void)]()
    func remindermanualIteractorDidGetRemindPermission(_ interactor: ReminderManualInteractor) {
        invokedRemindermanualIteractorDidGetRemindPermission = true
        invokedRemindermanualIteractorDidGetRemindPermissionCount += 1
        invokedRemindermanualIteractorDidGetRemindPermissionParameters = (interactor, ())
        invokedRemindermanualIteractorDidGetRemindPermissionParametersList.append((interactor, ()))
    }
    var invokedRemindermanualIteractor = false
    var invokedRemindermanualIteractorCount = 0
    var invokedRemindermanualIteractorParameters: (interactor: ReminderManualInteractor, error: Error?)?
    var invokedRemindermanualIteractorParametersList = [(interactor: ReminderManualInteractor, error: Error?)]()
    func remindermanualIteractor(_ interactor: ReminderManualInteractor, didFailGetRemindPermission error: Error?) {
        invokedRemindermanualIteractor = true
        invokedRemindermanualIteractorCount += 1
        invokedRemindermanualIteractorParameters = (interactor, error)
        invokedRemindermanualIteractorParametersList.append((interactor, error))
    }
    var invokedRemindermanualIteractorDidDiniedRemindPermission = false
    var invokedRemindermanualIteractorDidDiniedRemindPermissionCount = 0
    var invokedRemindermanualIteractorDidDiniedRemindPermissionParameters: (interactor: ReminderManualInteractor, Void)?
    var invokedRemindermanualIteractorDidDiniedRemindPermissionParametersList = [(interactor: ReminderManualInteractor, Void)]()
    func remindermanualIteractorDidDiniedRemindPermission(_ interactor: ReminderManualInteractor) {
        invokedRemindermanualIteractorDidDiniedRemindPermission = true
        invokedRemindermanualIteractorDidDiniedRemindPermissionCount += 1
        invokedRemindermanualIteractorDidDiniedRemindPermissionParameters = (interactor, ())
        invokedRemindermanualIteractorDidDiniedRemindPermissionParametersList.append((interactor, ()))
    }
}
