//
//  RepeatManualViewSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 11/6/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class RepeatManualViewSpy: RepeatManualView {
    var invokedDelegateSetter = false
    var invokedDelegateSetterCount = 0
    var invokedDelegate: RepeatManualViewDelegate?
    var invokedDelegateList = [RepeatManualViewDelegate?]()
    var invokedDelegateGetter = false
    var invokedDelegateGetterCount = 0
    var stubbedDelegate: RepeatManualViewDelegate!
    var delegate: RepeatManualViewDelegate? {
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
    var invokedViewModel: RepeatManualListViewModel?
    var invokedViewModelList = [RepeatManualListViewModel]()
    var invokedViewModelGetter = false
    var invokedViewModelGetterCount = 0
    var stubbedViewModel: RepeatManualListViewModel!
    var viewModel: RepeatManualListViewModel {
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
    var invokedDisplayParameters: (viewModel: RepeatManualListViewModel, Void)?
    var invokedDisplayParametersList = [(viewModel: RepeatManualListViewModel, Void)]()
    func display(_ viewModel: RepeatManualListViewModel) {
        invokedDisplay = true
        invokedDisplayCount += 1
        invokedDisplayParameters = (viewModel, ())
        invokedDisplayParametersList.append((viewModel, ()))
    }
    var invokedReloadCell = false
    var invokedReloadCellCount = 0
    var invokedReloadCellParameters: (index: IndexPath, animation: UITableView.RowAnimation)?
    var invokedReloadCellParametersList = [(index: IndexPath, animation: UITableView.RowAnimation)]()
    func reloadCell(at index: IndexPath, with animation: UITableView.RowAnimation) {
        invokedReloadCell = true
        invokedReloadCellCount += 1
        invokedReloadCellParameters = (index, animation)
        invokedReloadCellParametersList.append((index, animation))
    }
    var invokedRemoveCell = false
    var invokedRemoveCellCount = 0
    var invokedRemoveCellParameters: (index: IndexPath, Void)?
    var invokedRemoveCellParametersList = [(index: IndexPath, Void)]()
    func removeCell(at index: IndexPath) {
        invokedRemoveCell = true
        invokedRemoveCellCount += 1
        invokedRemoveCellParameters = (index, ())
        invokedRemoveCellParametersList.append((index, ()))
    }
    var invokedInsertCell = false
    var invokedInsertCellCount = 0
    var invokedInsertCellParameters: (index: IndexPath, Void)?
    var invokedInsertCellParametersList = [(index: IndexPath, Void)]()
    func insertCell(at index: IndexPath) {
        invokedInsertCell = true
        invokedInsertCellCount += 1
        invokedInsertCellParameters = (index, ())
        invokedInsertCellParametersList.append((index, ()))
    }
}
