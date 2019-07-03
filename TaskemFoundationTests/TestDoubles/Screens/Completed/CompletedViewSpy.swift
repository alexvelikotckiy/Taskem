//
//  CompletedViewSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class CompletedViewDummy: TableCoordinatorDelegateSpy, CompletedView {
    override var didCallBeginUpdate: Bool {
        set {
        }
        get {
            return false
        }
    }
    override var didCallEndUpdate: Bool {
        set {
        }
        get {
            return false
        }
    }
    override var lastInsertedSections: IndexSet? {
        set {
        }
        get {
            return nil
        }
    }
    override var lastReloadedSections: IndexSet? {
        set {
        }
        get {
            return nil
        }
    }
    override var lastDeletedSections: IndexSet? {
        set {
        }
        get {
            return nil
        }
    }
    override var lastWillBeginUpdateRow: IndexPath? {
        set {
        }
        get {
            return nil
        }
    }
    override var lastWillEndUpdateRow: IndexPath? {
        set {
        }
        get {
            return nil
        }
    }
    override var lastInsertedRows: [IndexPath] {
        set {
        }
        get {
            return []
        }
    }
    override var lastUpdatedRows: [IndexPath] {
        set {
        }
        get {
            return []
        }
    }
    override var lastDeletedRows: [IndexPath] {
        set {
        }
        get {
            return []
        }
    }
    override var lastMoveRow: (IndexPath, IndexPath)? {
        set {
        }
        get {
            return nil
        }
    }
    var delegate: CompletedViewDelegate? {
        set {
        }
        get {
            return nil
        }
    }
    var viewModel: CompletedListViewModel {
        set {
        }
        get {
            return .init()
        }
    }
    override func didBeginUpdate() {
    }
    override func didEndUpdate() {
    }
    override func insertSections(at indexes: IndexSet) {
    }
    override func reloadSections(at indexes: IndexSet) {
    }
    override func deleteSections(at indexes: IndexSet) {
    }
    override func willBeginUpdate(at index: IndexPath) {
    }
    override func willEndUpdate(at index: IndexPath) {
    }
    override func insertRows(at indexes: [IndexPath]) {
    }
    override func updateRows(at indexes: [IndexPath]) {
    }
    override func deleteRows(at indexes: [IndexPath]) {
    }
    override func moveRow(from: IndexPath, to index: IndexPath) {
    }
    func display(_ viewModel: CompletedListViewModel) {
    }
    func displayAllDone(_ isVisible: Bool) {
    }
    func displayRefresh(_ isRefreshing: Bool) {
    }
}

class CompletedViewSpy: CompletedViewDummy {
    var invokedDidCallBeginUpdateSetter = false
    var invokedDidCallBeginUpdateSetterCount = 0
    var invokedDidCallBeginUpdate: Bool?
    var invokedDidCallBeginUpdateList = [Bool]()
    var invokedDidCallBeginUpdateGetter = false
    var invokedDidCallBeginUpdateGetterCount = 0
    var stubbedDidCallBeginUpdate: Bool! = false
    override var didCallBeginUpdate: Bool {
        set {
            invokedDidCallBeginUpdateSetter = true
            invokedDidCallBeginUpdateSetterCount += 1
            invokedDidCallBeginUpdate = newValue
            invokedDidCallBeginUpdateList.append(newValue)
        }
        get {
            invokedDidCallBeginUpdateGetter = true
            invokedDidCallBeginUpdateGetterCount += 1
            return stubbedDidCallBeginUpdate
        }
    }
    var invokedDidCallEndUpdateSetter = false
    var invokedDidCallEndUpdateSetterCount = 0
    var invokedDidCallEndUpdate: Bool?
    var invokedDidCallEndUpdateList = [Bool]()
    var invokedDidCallEndUpdateGetter = false
    var invokedDidCallEndUpdateGetterCount = 0
    var stubbedDidCallEndUpdate: Bool! = false
    override var didCallEndUpdate: Bool {
        set {
            invokedDidCallEndUpdateSetter = true
            invokedDidCallEndUpdateSetterCount += 1
            invokedDidCallEndUpdate = newValue
            invokedDidCallEndUpdateList.append(newValue)
        }
        get {
            invokedDidCallEndUpdateGetter = true
            invokedDidCallEndUpdateGetterCount += 1
            return stubbedDidCallEndUpdate
        }
    }
    var invokedLastInsertedSectionsSetter = false
    var invokedLastInsertedSectionsSetterCount = 0
    var invokedLastInsertedSections: IndexSet?
    var invokedLastInsertedSectionsList = [IndexSet?]()
    var invokedLastInsertedSectionsGetter = false
    var invokedLastInsertedSectionsGetterCount = 0
    var stubbedLastInsertedSections: IndexSet!
    override var lastInsertedSections: IndexSet? {
        set {
            invokedLastInsertedSectionsSetter = true
            invokedLastInsertedSectionsSetterCount += 1
            invokedLastInsertedSections = newValue
            invokedLastInsertedSectionsList.append(newValue)
        }
        get {
            invokedLastInsertedSectionsGetter = true
            invokedLastInsertedSectionsGetterCount += 1
            return stubbedLastInsertedSections
        }
    }
    var invokedLastReloadedSectionsSetter = false
    var invokedLastReloadedSectionsSetterCount = 0
    var invokedLastReloadedSections: IndexSet?
    var invokedLastReloadedSectionsList = [IndexSet?]()
    var invokedLastReloadedSectionsGetter = false
    var invokedLastReloadedSectionsGetterCount = 0
    var stubbedLastReloadedSections: IndexSet!
    override var lastReloadedSections: IndexSet? {
        set {
            invokedLastReloadedSectionsSetter = true
            invokedLastReloadedSectionsSetterCount += 1
            invokedLastReloadedSections = newValue
            invokedLastReloadedSectionsList.append(newValue)
        }
        get {
            invokedLastReloadedSectionsGetter = true
            invokedLastReloadedSectionsGetterCount += 1
            return stubbedLastReloadedSections
        }
    }
    var invokedLastDeletedSectionsSetter = false
    var invokedLastDeletedSectionsSetterCount = 0
    var invokedLastDeletedSections: IndexSet?
    var invokedLastDeletedSectionsList = [IndexSet?]()
    var invokedLastDeletedSectionsGetter = false
    var invokedLastDeletedSectionsGetterCount = 0
    var stubbedLastDeletedSections: IndexSet!
    override var lastDeletedSections: IndexSet? {
        set {
            invokedLastDeletedSectionsSetter = true
            invokedLastDeletedSectionsSetterCount += 1
            invokedLastDeletedSections = newValue
            invokedLastDeletedSectionsList.append(newValue)
        }
        get {
            invokedLastDeletedSectionsGetter = true
            invokedLastDeletedSectionsGetterCount += 1
            return stubbedLastDeletedSections
        }
    }
    var invokedLastWillBeginUpdateRowSetter = false
    var invokedLastWillBeginUpdateRowSetterCount = 0
    var invokedLastWillBeginUpdateRow: IndexPath?
    var invokedLastWillBeginUpdateRowList = [IndexPath?]()
    var invokedLastWillBeginUpdateRowGetter = false
    var invokedLastWillBeginUpdateRowGetterCount = 0
    var stubbedLastWillBeginUpdateRow: IndexPath!
    override var lastWillBeginUpdateRow: IndexPath? {
        set {
            invokedLastWillBeginUpdateRowSetter = true
            invokedLastWillBeginUpdateRowSetterCount += 1
            invokedLastWillBeginUpdateRow = newValue
            invokedLastWillBeginUpdateRowList.append(newValue)
        }
        get {
            invokedLastWillBeginUpdateRowGetter = true
            invokedLastWillBeginUpdateRowGetterCount += 1
            return stubbedLastWillBeginUpdateRow
        }
    }
    var invokedLastWillEndUpdateRowSetter = false
    var invokedLastWillEndUpdateRowSetterCount = 0
    var invokedLastWillEndUpdateRow: IndexPath?
    var invokedLastWillEndUpdateRowList = [IndexPath?]()
    var invokedLastWillEndUpdateRowGetter = false
    var invokedLastWillEndUpdateRowGetterCount = 0
    var stubbedLastWillEndUpdateRow: IndexPath!
    override var lastWillEndUpdateRow: IndexPath? {
        set {
            invokedLastWillEndUpdateRowSetter = true
            invokedLastWillEndUpdateRowSetterCount += 1
            invokedLastWillEndUpdateRow = newValue
            invokedLastWillEndUpdateRowList.append(newValue)
        }
        get {
            invokedLastWillEndUpdateRowGetter = true
            invokedLastWillEndUpdateRowGetterCount += 1
            return stubbedLastWillEndUpdateRow
        }
    }
    var invokedLastInsertedRowsSetter = false
    var invokedLastInsertedRowsSetterCount = 0
    var invokedLastInsertedRows: [IndexPath]?
    var invokedLastInsertedRowsList = [[IndexPath]]()
    var invokedLastInsertedRowsGetter = false
    var invokedLastInsertedRowsGetterCount = 0
    var stubbedLastInsertedRows: [IndexPath]! = []
    override var lastInsertedRows: [IndexPath] {
        set {
            invokedLastInsertedRowsSetter = true
            invokedLastInsertedRowsSetterCount += 1
            invokedLastInsertedRows = newValue
            invokedLastInsertedRowsList.append(newValue)
        }
        get {
            invokedLastInsertedRowsGetter = true
            invokedLastInsertedRowsGetterCount += 1
            return stubbedLastInsertedRows
        }
    }
    var invokedLastUpdatedRowsSetter = false
    var invokedLastUpdatedRowsSetterCount = 0
    var invokedLastUpdatedRows: [IndexPath]?
    var invokedLastUpdatedRowsList = [[IndexPath]]()
    var invokedLastUpdatedRowsGetter = false
    var invokedLastUpdatedRowsGetterCount = 0
    var stubbedLastUpdatedRows: [IndexPath]! = []
    override var lastUpdatedRows: [IndexPath] {
        set {
            invokedLastUpdatedRowsSetter = true
            invokedLastUpdatedRowsSetterCount += 1
            invokedLastUpdatedRows = newValue
            invokedLastUpdatedRowsList.append(newValue)
        }
        get {
            invokedLastUpdatedRowsGetter = true
            invokedLastUpdatedRowsGetterCount += 1
            return stubbedLastUpdatedRows
        }
    }
    var invokedLastDeletedRowsSetter = false
    var invokedLastDeletedRowsSetterCount = 0
    var invokedLastDeletedRows: [IndexPath]?
    var invokedLastDeletedRowsList = [[IndexPath]]()
    var invokedLastDeletedRowsGetter = false
    var invokedLastDeletedRowsGetterCount = 0
    var stubbedLastDeletedRows: [IndexPath]! = []
    override var lastDeletedRows: [IndexPath] {
        set {
            invokedLastDeletedRowsSetter = true
            invokedLastDeletedRowsSetterCount += 1
            invokedLastDeletedRows = newValue
            invokedLastDeletedRowsList.append(newValue)
        }
        get {
            invokedLastDeletedRowsGetter = true
            invokedLastDeletedRowsGetterCount += 1
            return stubbedLastDeletedRows
        }
    }
    var invokedLastMoveRowSetter = false
    var invokedLastMoveRowSetterCount = 0
    var invokedLastMoveRow: (IndexPath, IndexPath)?
    var invokedLastMoveRowList = [(IndexPath, IndexPath)?]()
    var invokedLastMoveRowGetter = false
    var invokedLastMoveRowGetterCount = 0
    var stubbedLastMoveRow: (IndexPath, IndexPath)!
    override var lastMoveRow: (IndexPath, IndexPath)? {
        set {
            invokedLastMoveRowSetter = true
            invokedLastMoveRowSetterCount += 1
            invokedLastMoveRow = newValue
            invokedLastMoveRowList.append(newValue)
        }
        get {
            invokedLastMoveRowGetter = true
            invokedLastMoveRowGetterCount += 1
            return stubbedLastMoveRow
        }
    }
    var invokedDelegateSetter = false
    var invokedDelegateSetterCount = 0
    var invokedDelegate: CompletedViewDelegate?
    var invokedDelegateList = [CompletedViewDelegate?]()
    var invokedDelegateGetter = false
    var invokedDelegateGetterCount = 0
    var stubbedDelegate: CompletedViewDelegate!
    override var delegate: CompletedViewDelegate? {
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
    var invokedViewModel: CompletedListViewModel?
    var invokedViewModelList = [CompletedListViewModel]()
    var invokedViewModelGetter = false
    var invokedViewModelGetterCount = 0
    var stubbedViewModel: CompletedListViewModel!
    override var viewModel: CompletedListViewModel {
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
    var invokedDidBeginUpdate = false
    var invokedDidBeginUpdateCount = 0
    override func didBeginUpdate() {
        invokedDidBeginUpdate = true
        invokedDidBeginUpdateCount += 1
    }
    var invokedDidEndUpdate = false
    var invokedDidEndUpdateCount = 0
    override func didEndUpdate() {
        invokedDidEndUpdate = true
        invokedDidEndUpdateCount += 1
    }
    var invokedInsertSections = false
    var invokedInsertSectionsCount = 0
    var invokedInsertSectionsParameters: (indexes: IndexSet, Void)?
    var invokedInsertSectionsParametersList = [(indexes: IndexSet, Void)]()
    override func insertSections(at indexes: IndexSet) {
        invokedInsertSections = true
        invokedInsertSectionsCount += 1
        invokedInsertSectionsParameters = (indexes, ())
        invokedInsertSectionsParametersList.append((indexes, ()))
    }
    var invokedReloadSections = false
    var invokedReloadSectionsCount = 0
    var invokedReloadSectionsParameters: (indexes: IndexSet, Void)?
    var invokedReloadSectionsParametersList = [(indexes: IndexSet, Void)]()
    override func reloadSections(at indexes: IndexSet) {
        invokedReloadSections = true
        invokedReloadSectionsCount += 1
        invokedReloadSectionsParameters = (indexes, ())
        invokedReloadSectionsParametersList.append((indexes, ()))
    }
    var invokedDeleteSections = false
    var invokedDeleteSectionsCount = 0
    var invokedDeleteSectionsParameters: (indexes: IndexSet, Void)?
    var invokedDeleteSectionsParametersList = [(indexes: IndexSet, Void)]()
    override func deleteSections(at indexes: IndexSet) {
        invokedDeleteSections = true
        invokedDeleteSectionsCount += 1
        invokedDeleteSectionsParameters = (indexes, ())
        invokedDeleteSectionsParametersList.append((indexes, ()))
    }
    var invokedWillBeginUpdate = false
    var invokedWillBeginUpdateCount = 0
    var invokedWillBeginUpdateParameters: (index: IndexPath, Void)?
    var invokedWillBeginUpdateParametersList = [(index: IndexPath, Void)]()
    override func willBeginUpdate(at index: IndexPath) {
        invokedWillBeginUpdate = true
        invokedWillBeginUpdateCount += 1
        invokedWillBeginUpdateParameters = (index, ())
        invokedWillBeginUpdateParametersList.append((index, ()))
    }
    var invokedWillEndUpdate = false
    var invokedWillEndUpdateCount = 0
    var invokedWillEndUpdateParameters: (index: IndexPath, Void)?
    var invokedWillEndUpdateParametersList = [(index: IndexPath, Void)]()
    override func willEndUpdate(at index: IndexPath) {
        invokedWillEndUpdate = true
        invokedWillEndUpdateCount += 1
        invokedWillEndUpdateParameters = (index, ())
        invokedWillEndUpdateParametersList.append((index, ()))
    }
    var invokedInsertRows = false
    var invokedInsertRowsCount = 0
    var invokedInsertRowsParameters: (indexes: [IndexPath], Void)?
    var invokedInsertRowsParametersList = [(indexes: [IndexPath], Void)]()
    override func insertRows(at indexes: [IndexPath]) {
        invokedInsertRows = true
        invokedInsertRowsCount += 1
        invokedInsertRowsParameters = (indexes, ())
        invokedInsertRowsParametersList.append((indexes, ()))
    }
    var invokedUpdateRows = false
    var invokedUpdateRowsCount = 0
    var invokedUpdateRowsParameters: (indexes: [IndexPath], Void)?
    var invokedUpdateRowsParametersList = [(indexes: [IndexPath], Void)]()
    override func updateRows(at indexes: [IndexPath]) {
        invokedUpdateRows = true
        invokedUpdateRowsCount += 1
        invokedUpdateRowsParameters = (indexes, ())
        invokedUpdateRowsParametersList.append((indexes, ()))
    }
    var invokedDeleteRows = false
    var invokedDeleteRowsCount = 0
    var invokedDeleteRowsParameters: (indexes: [IndexPath], Void)?
    var invokedDeleteRowsParametersList = [(indexes: [IndexPath], Void)]()
    override func deleteRows(at indexes: [IndexPath]) {
        invokedDeleteRows = true
        invokedDeleteRowsCount += 1
        invokedDeleteRowsParameters = (indexes, ())
        invokedDeleteRowsParametersList.append((indexes, ()))
    }
    var invokedMoveRow = false
    var invokedMoveRowCount = 0
    var invokedMoveRowParameters: (from: IndexPath, index: IndexPath)?
    var invokedMoveRowParametersList = [(from: IndexPath, index: IndexPath)]()
    override func moveRow(from: IndexPath, to index: IndexPath) {
        invokedMoveRow = true
        invokedMoveRowCount += 1
        invokedMoveRowParameters = (from, index)
        invokedMoveRowParametersList.append((from, index))
    }
    var invokedDisplay = false
    var invokedDisplayCount = 0
    var invokedDisplayParameters: (viewModel: CompletedListViewModel, Void)?
    var invokedDisplayParametersList = [(viewModel: CompletedListViewModel, Void)]()
    override func display(_ viewModel: CompletedListViewModel) {
        invokedDisplay = true
        invokedDisplayCount += 1
        invokedDisplayParameters = (viewModel, ())
        invokedDisplayParametersList.append((viewModel, ()))
    }
    var invokedDisplayAllDone = false
    var invokedDisplayAllDoneCount = 0
    var invokedDisplayAllDoneParameters: (isVisible: Bool, Void)?
    var invokedDisplayAllDoneParametersList = [(isVisible: Bool, Void)]()
    override func displayAllDone(_ isVisible: Bool) {
        invokedDisplayAllDone = true
        invokedDisplayAllDoneCount += 1
        invokedDisplayAllDoneParameters = (isVisible, ())
        invokedDisplayAllDoneParametersList.append((isVisible, ()))
    }
    var invokedDisplayRefresh = false
    var invokedDisplayRefreshCount = 0
    var invokedDisplayRefreshParameters: (isRefreshing: Bool, Void)?
    var invokedDisplayRefreshParametersList = [(isRefreshing: Bool, Void)]()
    override func displayRefresh(_ isRefreshing: Bool) {
        invokedDisplayRefresh = true
        invokedDisplayRefreshCount += 1
        invokedDisplayRefreshParameters = (isRefreshing, ())
        invokedDisplayRefreshParametersList.append((isRefreshing, ()))
    }
}
