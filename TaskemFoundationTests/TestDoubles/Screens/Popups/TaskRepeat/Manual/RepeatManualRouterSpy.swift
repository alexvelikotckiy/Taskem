//
//  RepeatManualRouterSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 11/6/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class RepeatManualRouterSpy: RepeatManualRouter {
    var invokedDismiss = false
    var invokedDismissCount = 0
    func dismiss() {
        invokedDismiss = true
        invokedDismissCount += 1
    }
}
