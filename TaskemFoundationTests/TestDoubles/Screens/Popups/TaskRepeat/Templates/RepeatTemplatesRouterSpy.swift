//
//  RepeatTemplatesRouterSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 11/6/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class RepeatTemplatesRouterSpy: RepeatTemplatesRouter {
    var invokedDismiss = false
    var invokedDismissCount = 0
    func dismiss() {
        invokedDismiss = true
        invokedDismissCount += 1
    }
    var invokedPresentManual = false
    var invokedPresentManualCount = 0
    var invokedPresentManualParameters: (data: RepeatManualPresenter.InitialData, Void)?
    var invokedPresentManualParametersList = [(data: RepeatManualPresenter.InitialData, Void)]()
    var stubbedPresentManualCallbackResult: (RepeatPreferences?, Void)?
    func presentManual(data: RepeatManualPresenter.InitialData, callback: @escaping TaskRepeatCallback) {
        invokedPresentManual = true
        invokedPresentManualCount += 1
        invokedPresentManualParameters = (data, ())
        invokedPresentManualParametersList.append((data, ()))
        if let result = stubbedPresentManualCallbackResult {
            callback(result.0)
        }
    }
}
