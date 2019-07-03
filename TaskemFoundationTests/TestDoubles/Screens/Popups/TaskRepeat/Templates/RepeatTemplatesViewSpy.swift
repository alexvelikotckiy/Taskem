//
//  RepeatTemplatesViewSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 11/6/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class RepeatTemplatesViewSpy: RepeatTemplatesView {
    var invokedDelegateSetter = false
    var invokedDelegateSetterCount = 0
    var invokedDelegate: RepeatTemplatesViewDelegate?
    var invokedDelegateList = [RepeatTemplatesViewDelegate?]()
    var invokedDelegateGetter = false
    var invokedDelegateGetterCount = 0
    var stubbedDelegate: RepeatTemplatesViewDelegate!
    var delegate: RepeatTemplatesViewDelegate? {
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
    var invokedViewModel: RepeatTemplatesListViewModel?
    var invokedViewModelList = [RepeatTemplatesListViewModel]()
    var invokedViewModelGetter = false
    var invokedViewModelGetterCount = 0
    var stubbedViewModel: RepeatTemplatesListViewModel!
    var viewModel: RepeatTemplatesListViewModel {
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
    var invokedDisplayParameters: (viewModel: RepeatTemplatesListViewModel, Void)?
    var invokedDisplayParametersList = [(viewModel: RepeatTemplatesListViewModel, Void)]()
    func display(_ viewModel: RepeatTemplatesListViewModel) {
        invokedDisplay = true
        invokedDisplayCount += 1
        invokedDisplayParameters = (viewModel, ())
        invokedDisplayParametersList.append((viewModel, ()))
    }
}
