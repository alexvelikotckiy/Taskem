//
//  DatePickerManualViewSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/12/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class DatePickerManualViewSpy: DatePickerManualView {
    var invokedDelegateSetter = false
    var invokedDelegateSetterCount = 0
    var invokedDelegate: DatePickerManualViewDelegate?
    var invokedDelegateList = [DatePickerManualViewDelegate?]()
    var invokedDelegateGetter = false
    var invokedDelegateGetterCount = 0
    var stubbedDelegate: DatePickerManualViewDelegate!
    var delegate: DatePickerManualViewDelegate? {
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
    var invokedViewModel: DatePickerManualViewModel?
    var invokedViewModelList = [DatePickerManualViewModel]()
    var invokedViewModelGetter = false
    var invokedViewModelGetterCount = 0
    var stubbedViewModel: DatePickerManualViewModel!
    var viewModel: DatePickerManualViewModel {
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
    var invokedDisplayParameters: (viewModel: DatePickerManualViewModel, Void)?
    var invokedDisplayParametersList = [(viewModel: DatePickerManualViewModel, Void)]()
    func display(_ viewModel: DatePickerManualViewModel) {
        invokedDisplay = true
        invokedDisplayCount += 1
        invokedDisplayParameters = (viewModel, ())
        invokedDisplayParametersList.append((viewModel, ()))
    }
    var invokedScrollToDate = false
    var invokedScrollToDateCount = 0
    var invokedScrollToDateParameters: (date: Date, Void)?
    var invokedScrollToDateParametersList = [(date: Date, Void)]()
    func scrollToDate(_ date: Date) {
        invokedScrollToDate = true
        invokedScrollToDateCount += 1
        invokedScrollToDateParameters = (date, ())
        invokedScrollToDateParametersList.append((date, ()))
    }
    var invokedScrollToTime = false
    var invokedScrollToTimeCount = 0
    var invokedScrollToTimeParameters: (date: Date, Void)?
    var invokedScrollToTimeParametersList = [(date: Date, Void)]()
    func scrollToTime(_ date: Date) {
        invokedScrollToTime = true
        invokedScrollToTimeCount += 1
        invokedScrollToTimeParameters = (date, ())
        invokedScrollToTimeParametersList.append((date, ()))
    }
}
