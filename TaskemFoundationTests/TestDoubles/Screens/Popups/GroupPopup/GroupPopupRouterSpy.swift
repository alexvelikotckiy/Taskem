//
//  GroupPopupRouterSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/23/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class GroupPopupRouterSpy: GroupPopupRouter {
    var invokedDismiss = false
    var invokedDismissCount = 0
    func dismiss() {
        invokedDismiss = true
        invokedDismissCount += 1
    }
    var invokedPresentNewGroup = false
    var invokedPresentNewGroupCount = 0
    var invokedPresentNewGroupParameters: (data: GroupOverviewPresenter.InitialData, Void)?
    var invokedPresentNewGroupParametersList = [(data: GroupOverviewPresenter.InitialData, Void)]()
    func presentNewGroup(_ data: GroupOverviewPresenter.InitialData) {
        invokedPresentNewGroup = true
        invokedPresentNewGroupCount += 1
        invokedPresentNewGroupParameters = (data, ())
        invokedPresentNewGroupParametersList.append((data, ()))
    }
}
