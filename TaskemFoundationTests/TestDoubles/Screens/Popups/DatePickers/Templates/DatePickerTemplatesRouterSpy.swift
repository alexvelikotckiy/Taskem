//
//  DatePickerTemplatesRouterSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/12/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class DatePickerTemplatesRouterSpy: DatePickerTemplatesRouter {
    var invokedDismiss = false
    var invokedDismissCount = 0
    func dismiss() {
        invokedDismiss = true
        invokedDismissCount += 1
    }
    var invokedPresentManual = false
    var invokedPresentManualCount = 0
    var invokedPresentManualParameters: (initialData: DatePickerManualPresenter.InitialData, Void)?
    var invokedPresentManualParametersList = [(initialData: DatePickerManualPresenter.InitialData, Void)]()
    var stubbedPresentManualCallbackResult: (DatePreferences?, Void)?
    func presentManual(_ initialData: DatePickerManualPresenter.InitialData, callback: @escaping DatePickerCallback) {
        invokedPresentManual = true
        invokedPresentManualCount += 1
        invokedPresentManualParameters = (initialData, ())
        invokedPresentManualParametersList.append((initialData, ()))
        if let result = stubbedPresentManualCallbackResult {
            callback(result.0)
        }
    }
}
