//
//  CompletedRouterSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class CompletedRouterSpy: CompletedRouter {
    var invokedDismiss = false
    var invokedDismissCount = 0
    func dismiss() {
        invokedDismiss = true
        invokedDismissCount += 1
    }
    var invokedPresentDatePicker = false
    var invokedPresentDatePickerCount = 0
    var invokedPresentDatePickerParameters: (data: DatePickerTemplatesPresenter.InitialData, Void)?
    var invokedPresentDatePickerParametersList = [(data: DatePickerTemplatesPresenter.InitialData, Void)]()
    var stubbedPresentDatePickerCompletionResult: (DatePreferences?, Void)?
    func presentDatePicker(data: DatePickerTemplatesPresenter.InitialData, completion: @escaping DatePickerCallback) {
        invokedPresentDatePicker = true
        invokedPresentDatePickerCount += 1
        invokedPresentDatePickerParameters = (data, ())
        invokedPresentDatePickerParametersList.append((data, ()))
        if let result = stubbedPresentDatePickerCompletionResult {
            completion(result.0)
        }
    }
    var invokedPresentTask = false
    var invokedPresentTaskCount = 0
    var invokedPresentTaskParameters: (data: TaskOverviewPresenter.InitialData, frame: CGRect)?
    var invokedPresentTaskParametersList = [(data: TaskOverviewPresenter.InitialData, frame: CGRect)]()
    func presentTask(data: TaskOverviewPresenter.InitialData, frame: CGRect) {
        invokedPresentTask = true
        invokedPresentTaskCount += 1
        invokedPresentTaskParameters = (data, frame)
        invokedPresentTaskParametersList.append((data, frame))
    }
    var invokedAlertDelete = false
    var invokedAlertDeleteCount = 0
    var invokedAlertDeleteParameters: (title: String, message: String)?
    var invokedAlertDeleteParametersList = [(title: String, message: String)]()
    var stubbedAlertDeleteCompletionResult: (Bool, Void)?
    func alertDelete(title: String, message: String, completion: @escaping ((Bool) -> Void)) {
        invokedAlertDelete = true
        invokedAlertDeleteCount += 1
        invokedAlertDeleteParameters = (title, message)
        invokedAlertDeleteParametersList.append((title, message))
        if let result = stubbedAlertDeleteCompletionResult {
            completion(result.0)
        }
    }
}
