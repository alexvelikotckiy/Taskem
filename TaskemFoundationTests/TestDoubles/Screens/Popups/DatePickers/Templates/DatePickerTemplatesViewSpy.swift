//
//  DatePickerTemplatesViewSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/12/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class DatePickerTemplatesViewSpy: DatePickerTemplatesView {
    var invokedDelegateSetter = false
    var invokedDelegateSetterCount = 0
    var invokedDelegate: DatePickerTemplatesViewDelegate?
    var invokedDelegateList = [DatePickerTemplatesViewDelegate?]()
    var invokedDelegateGetter = false
    var invokedDelegateGetterCount = 0
    var stubbedDelegate: DatePickerTemplatesViewDelegate!
    var delegate: DatePickerTemplatesViewDelegate? {
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
    var invokedViewModel: DatePickerTemplatesListViewModel?
    var invokedViewModelList = [DatePickerTemplatesListViewModel]()
    var invokedViewModelGetter = false
    var invokedViewModelGetterCount = 0
    var stubbedViewModel: DatePickerTemplatesListViewModel!
    var viewModel: DatePickerTemplatesListViewModel {
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
    var invokedDisplayParameters: (viewModel: DatePickerTemplatesListViewModel, Void)?
    var invokedDisplayParametersList = [(viewModel: DatePickerTemplatesListViewModel, Void)]()
    func display(_ viewModel: DatePickerTemplatesListViewModel) {
        invokedDisplay = true
        invokedDisplayCount += 1
        invokedDisplayParameters = (viewModel, ())
        invokedDisplayParametersList.append((viewModel, ()))
    }
}
