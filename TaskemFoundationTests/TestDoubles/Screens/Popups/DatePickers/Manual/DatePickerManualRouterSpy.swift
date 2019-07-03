//
//  DatePickerManualRouterSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/12/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class DatePickerManualRouterSpy: DatePickerManualRouter {
    var invokedDismiss = false
    var invokedDismissCount = 0
    var shouldInvokeDismissCompletion = false
    func dismiss(_ completion: @escaping (() -> Void)) {
        invokedDismiss = true
        invokedDismissCount += 1
        if shouldInvokeDismissCompletion {
            completion()
        }
    }
}
