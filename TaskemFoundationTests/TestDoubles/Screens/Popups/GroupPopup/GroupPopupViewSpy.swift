//
//  GroupPopupViewSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/23/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class GroupPopupViewSpy: GroupPopupView {
    var invokedDelegateSetter = false
    var invokedDelegateSetterCount = 0
    var invokedDelegate: GroupPopupViewDelegate?
    var invokedDelegateList = [GroupPopupViewDelegate?]()
    var invokedDelegateGetter = false
    var invokedDelegateGetterCount = 0
    var stubbedDelegate: GroupPopupViewDelegate!
    var delegate: GroupPopupViewDelegate? {
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
    var invokedViewModel: GroupPopupListViewModel?
    var invokedViewModelList = [GroupPopupListViewModel]()
    var invokedViewModelGetter = false
    var invokedViewModelGetterCount = 0
    var stubbedViewModel: GroupPopupListViewModel!
    var viewModel: GroupPopupListViewModel {
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
    var invokedDisplayParameters: (viewModel: GroupPopupListViewModel, Void)?
    var invokedDisplayParametersList = [(viewModel: GroupPopupListViewModel, Void)]()
    func display(_ viewModel: GroupPopupListViewModel) {
        invokedDisplay = true
        invokedDisplayCount += 1
        invokedDisplayParameters = (viewModel, ())
        invokedDisplayParametersList.append((viewModel, ()))
    }
}
