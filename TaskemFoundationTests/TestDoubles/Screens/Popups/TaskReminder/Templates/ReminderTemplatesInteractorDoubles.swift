//
//  ReminderTemplatesInteractorDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class ReminderTemplatesInteractorDummy: ReminderTemplatesInteractor {
    var delegate: ReminderTemplatesInteractorOutput? {
        set {
        }
        get {
            return nil
        }
    }
    func registerRemindPermission() {
    }
}

class ReminderTemplatesInteractorSpy: ReminderTemplatesInteractorDummy {
    var invokedDelegateSetter = false
    var invokedDelegateSetterCount = 0
    var invokedDelegate: ReminderTemplatesInteractorOutput?
    var invokedDelegateList = [ReminderTemplatesInteractorOutput?]()
    var invokedDelegateGetter = false
    var invokedDelegateGetterCount = 0
    var stubbedDelegate: ReminderTemplatesInteractorOutput!
    override var delegate: ReminderTemplatesInteractorOutput? {
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

class ReminderTemplatesInteractorObserverSpy: ReminderTemplatesInteractorOutput {
    var invokedRemindertemplatesIteractorDidGetRemindPermission = false
    var invokedRemindertemplatesIteractorDidGetRemindPermissionCount = 0
    var invokedRemindertemplatesIteractorDidGetRemindPermissionParameters: (interactor: ReminderTemplatesInteractor, Void)?
    var invokedRemindertemplatesIteractorDidGetRemindPermissionParametersList = [(interactor: ReminderTemplatesInteractor, Void)]()
    func remindertemplatesIteractorDidGetRemindPermission(_ interactor: ReminderTemplatesInteractor) {
        invokedRemindertemplatesIteractorDidGetRemindPermission = true
        invokedRemindertemplatesIteractorDidGetRemindPermissionCount += 1
        invokedRemindertemplatesIteractorDidGetRemindPermissionParameters = (interactor, ())
        invokedRemindertemplatesIteractorDidGetRemindPermissionParametersList.append((interactor, ()))
    }
    var invokedRemindertemplatesIteractor = false
    var invokedRemindertemplatesIteractorCount = 0
    var invokedRemindertemplatesIteractorParameters: (interactor: ReminderTemplatesInteractor, error: Error?)?
    var invokedRemindertemplatesIteractorParametersList = [(interactor: ReminderTemplatesInteractor, error: Error?)]()
    func remindertemplatesIteractor(_ interactor: ReminderTemplatesInteractor, didFailGetRemindPermission error: Error?) {
        invokedRemindertemplatesIteractor = true
        invokedRemindertemplatesIteractorCount += 1
        invokedRemindertemplatesIteractorParameters = (interactor, error)
        invokedRemindertemplatesIteractorParametersList.append((interactor, error))
    }
    var invokedRemindertemplatesIteractorDidDiniedRemindPermission = false
    var invokedRemindertemplatesIteractorDidDiniedRemindPermissionCount = 0
    var invokedRemindertemplatesIteractorDidDiniedRemindPermissionParameters: (interactor: ReminderTemplatesInteractor, Void)?
    var invokedRemindertemplatesIteractorDidDiniedRemindPermissionParametersList = [(interactor: ReminderTemplatesInteractor, Void)]()
    func remindertemplatesIteractorDidDiniedRemindPermission(_ interactor: ReminderTemplatesInteractor) {
        invokedRemindertemplatesIteractorDidDiniedRemindPermission = true
        invokedRemindertemplatesIteractorDidDiniedRemindPermissionCount += 1
        invokedRemindertemplatesIteractorDidDiniedRemindPermissionParameters = (interactor, ())
        invokedRemindertemplatesIteractorDidDiniedRemindPermissionParametersList.append((interactor, ()))
    }
}
