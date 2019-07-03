//
//  ReminderManualViewSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class ReminderManualViewSpy: ReminderManualView {
    var invokedDelegateSetter = false
    var invokedDelegateSetterCount = 0
    var invokedDelegate: ReminderManualViewDelegate?
    var invokedDelegateList = [ReminderManualViewDelegate?]()
    var invokedDelegateGetter = false
    var invokedDelegateGetterCount = 0
    var stubbedDelegate: ReminderManualViewDelegate!
    var delegate: ReminderManualViewDelegate? {
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
    var invokedViewModelSetter = false
    var invokedViewModelSetterCount = 0
    var invokedViewModel: ReminderManualListViewModel?
    var invokedViewModelList = [ReminderManualListViewModel]()
    var invokedViewModelGetter = false
    var invokedViewModelGetterCount = 0
    var stubbedViewModel: ReminderManualListViewModel!
    var viewModel: ReminderManualListViewModel {
        set {
            invokedViewModelSetter = true
            invokedViewModelSetterCount += 1
            invokedViewModel = newValue
            invokedViewModelList.append(newValue)
        }
        get {
            invokedViewModelGetter = true
            invokedViewModelGetterCount += 1
            return stubbedViewModel
        }
    }
    var invokedDisplay = false
    var invokedDisplayCount = 0
    var invokedDisplayParameters: (viewModel: ReminderManualListViewModel, Void)?
    var invokedDisplayParametersList = [(viewModel: ReminderManualListViewModel, Void)]()
    func display(_ viewModel: ReminderManualListViewModel) {
        invokedDisplay = true
        invokedDisplayCount += 1
        invokedDisplayParameters = (viewModel, ())
        invokedDisplayParametersList.append((viewModel, ()))
    }
    var invokedReload = false
    var invokedReloadCount = 0
    var invokedReloadParameters: (index: IndexPath, Void)?
    var invokedReloadParametersList = [(index: IndexPath, Void)]()
    func reload(at index: IndexPath) {
        invokedReload = true
        invokedReloadCount += 1
        invokedReloadParameters = (index, ())
        invokedReloadParametersList.append((index, ()))
    }
}
