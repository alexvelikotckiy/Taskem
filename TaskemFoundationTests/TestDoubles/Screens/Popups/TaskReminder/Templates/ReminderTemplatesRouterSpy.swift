//
//  ReminderTemplatesRouterSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class ReminderTemplatesRouterSpy: ReminderTemplatesRouter {
    var invokedDismiss = false
    var invokedDismissCount = 0
    func dismiss() {
        invokedDismiss = true
        invokedDismissCount += 1
    }
    var invokedAlert = false
    var invokedAlertCount = 0
    var invokedAlertParameters: (title: String, message: String)?
    var invokedAlertParametersList = [(title: String, message: String)]()
    var shouldInvokeAlertCompletion = false
    func alert(title: String, message: String, completion: @escaping (() -> Void)) {
        invokedAlert = true
        invokedAlertCount += 1
        invokedAlertParameters = (title, message)
        invokedAlertParametersList.append((title, message))
        if shouldInvokeAlertCompletion {
            completion()
        }
    }
    var invokedPresentManual = false
    var invokedPresentManualCount = 0
    var invokedPresentManualParameters: (data: ReminderManualPresenter.InitialData, Void)?
    var invokedPresentManualParametersList = [(data: ReminderManualPresenter.InitialData, Void)]()
    var stubbedPresentManualCallbackResult: (Reminder, Void)?
    func presentManual(data: ReminderManualPresenter.InitialData, callback: @escaping TaskReminderCallback) {
        invokedPresentManual = true
        invokedPresentManualCount += 1
        invokedPresentManualParameters = (data, ())
        invokedPresentManualParametersList.append((data, ()))
        if let result = stubbedPresentManualCallbackResult {
            callback(result.0)
        }
    }
}
