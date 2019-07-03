//
//  CompletedPresenterTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/20/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class CompletedPresenterTestCaseBase: CompletedTestCaseBase {
    
    var presenter: CompletedPresenter!
    
    // Test Doubles
    var spyView: CompletedViewSpy!
    var spyRouter: CompletedRouterSpy!
    var spyInteractor: CompletedInteractorSpy!
    
    fileprivate var spySourceTasks: TaskSourceSpy!
    fileprivate var spySourceGroups: GroupSourceSpy!
    
    fileprivate var spyTableCoordinator: TableCoordinatorSpy!
    
    override func setUp() {
        super.setUp()
        
        spySourceTasks = .init()
        spySourceGroups = .init()
        
        spyView = .init()
        spyRouter = .init()
        spyInteractor = .init(sourceTasks: spySourceTasks, sourceGroups: spySourceGroups)
        presenter = .init(view: spyView, router: spyRouter, interactor: spyInteractor)
        
        spyTableCoordinator = .init()
        
        setupStubs()
    }
    
    private func setupStubs() {
        spySourceTasks.allTasks = stubsModels.map { $0.task }
        spySourceGroups.allGroups =  stubsModels.map { $0.group }
    }
    
    func expectViewModelDisplayCount(_ count: Int, file: FileString = #file, line: UInt = #line) {
        expect(self.spyView.invokedDisplayCount, file: file, line: line).toEventually(equal(count))
    }
    
    func expectAllDone(_ isVisible: Bool, file: FileString = #file, line: UInt = #line) {
        expect(self.spyView.invokedDisplayAllDoneParameters?.isVisible, file: file, line: line).toEventually(equal(isVisible))
    }
    
    func expectSpinner(_ isVisible: Bool, file: FileString = #file, line: UInt = #line) {
        expect(self.spyView.invokedDisplayRefreshParameters?.isRefreshing, file: file, line: line).toEventually(equal(isVisible))
    }
    
    func expectEmptyViewModel(file: FileString = #file, line: UInt = #line) {
        expect(self.spyView.invokedDisplayParameters?.viewModel, file: file, line: line).toEventually(beNil())
    }
    
    func expectViewModel(_ viewModel: CompletedListViewModel, file: FileString = #file, line: UInt = #line) {
        expect(self.spyView.invokedDisplayParameters?.viewModel, file: file, line: line).toEventually(equal(viewModel))
    }
}

class CompletedPresenterTestCase: CompletedPresenterTestCaseBase {
    
    override func setUp() {
        super.setUp()
        
        let viewModel: CompletedListViewModel = presenter.produce(from: .list(stubsModels))!
        
        spyView.stubbedViewModel = viewModel
    }
    
    func testShouldBeViewDelegate() {
        expect(self.presenter).to(beAKindOf(CompletedViewDelegate.self))
        expect(self.spyView.invokedDelegate) === presenter
    }
    
    func testShouldBeInteractorDelegate() {
        expect(self.presenter).to(beAKindOf(CompletedInteractorOutput.self))
        expect(self.spyInteractor.delegate) === presenter
    }
    
    func testNavigateOnTouchCell() {
        presenter.onTouchCell(at: .init(row: 0, section: 0), frame: .init())
        
        expect(self.spyRouter.invokedPresentTask) == true
    }
    
    func testToogleCompletion() {
        presenter.onToogleCompletion(at: .init(row: 0, section: 0))
        
        expect(self.spySourceTasks.updatedTasks.count) == 1
        expect(self.spySourceTasks.updatedTasks.first?.id) == spyView.viewModel[.init(row: 0, section: 0)].id
        expect(self.spySourceTasks.updatedTasks.first?.isComplete) == false
    }
    
    func testDeleteOnSwipeRight() {
        presenter.onSwipeRight(at: .init(row: 0, section: 0))
        
        expect(self.spySourceTasks.removedTasks.count) == 1
        expect(self.spySourceTasks.removedTasks.first?.id) == spyView.viewModel[.init(row: 0, section: 0)].id
    }
    
    func testNavigateToCalendarOnSwipeLeft() {
        presenter.onSwipeLeft(at: .init(row: 0, section: 0)) { }
        
        expect(self.spyRouter.invokedPresentDatePicker) == true
    }
    
    func testDeleteAllOnClearAll() {
        spyRouter.stubbedAlertDeleteCompletionResult = (true, ())
        
        presenter.onTouchClearAll()
        
        expect(self.spyRouter.invokedAlertDelete) == true
        expect(self.spySourceTasks.removedTasks.count) == spyView.viewModel.cellsCount()
    }
    
    func testResolveTaskDatePrefencesAfterCalendarCallback() {
        let task = spyView.viewModel[.init(row: 0, section: 0)].model.task
        let expectedDatePreferences = DatePreferences(assumedDate: Date.now, isAllDay: true)
        spyRouter.stubbedPresentDatePickerCompletionResult = (expectedDatePreferences, ())
        
        presenter.onSwipeLeft(at: .init(row: 0, section: 0)) { }
        
        expect(self.spySourceTasks.updatedTasks.count) == 1
        expect(self.spySourceTasks.updatedTasks.first?.id) == task.id
        expect(self.spySourceTasks.updatedTasks.first?.datePreference) == expectedDatePreferences
    }
}

class CompletedPresenterInteractorOutputTestCase: CompletedPresenterTestCaseBase {
    
    override func setUp() {
        super.setUp()
        
        spyView.stubbedViewModel = .init()
    }
    
    func testShouldPauseTableCoordinatorBeforeFirstAppear() {
        expect(self.presenter.coordinator.isPaused) == true
        
        presenter.onViewWillAppear()
        
        expect(self.presenter.coordinator.isPaused) == false
    }
    
    func testShouldDisplaySpinnerOnLoading() {
        presenter.onViewWillAppear()
        
        spySourceTasks.state = .loading
        spySourceGroups.state = .loading
        presenter.interactorDidChangeStateTasks(spyInteractor, state: .loading)
        
        expectSpinner(true)
        expectViewModelDisplayCount(0)
    }
    
    func testShouldReloadOnLoadTasks() {
        presenter.onViewWillAppear()
        
        spySourceTasks.state = .loaded
        spySourceGroups.state = .loaded
        presenter.interactorDidChangeStateTasks(spyInteractor, state: .loaded)
        
        expectSpinner(false)
        expectViewModelDisplayCount(1)
    }
    
    func testCallInsert() {
        presenter.coordinator = spyTableCoordinator
        presenter.interactor(spyInteractor, didAdd: stubsModels)
        
        expect(self.spyTableCoordinator.inserted as? [TaskModel]) == stubsModels
        expect(self.spyTableCoordinator.didNotifyLastAction) == true
    }
    
    func testCallUpdate() {
        presenter.coordinator = spyTableCoordinator
        presenter.interactor(spyInteractor, didUpdate: stubsModels)
        
        expect(self.spyTableCoordinator.updated as? [TaskModel]) == stubsModels
        expect(self.spyTableCoordinator.didNotifyLastAction) == true
    }
    
    func testCallRemove() {
        presenter.coordinator = spyTableCoordinator
        let viewModels: [CompletedViewModel] = presenter.produce(from: .cells(stubsModels))!

        presenter.interactor(spyInteractor, didRemoveTasks: viewModels.map { $0.id })

        let predicate = spyTableCoordinator.removePredicate as! (CompletedViewModel) -> Bool
        for viewModel in viewModels {
            expect(predicate(viewModel)) == true
        }
        expect(self.spyTableCoordinator.didNotifyLastAction) == true
    }
}

class CompletedPresenterOnLoadTestCase: CompletedPresenterTestCaseBase {
    
    override func setUp() {
        super.setUp()
        
        spySourceTasks.state = .loaded
        spySourceGroups.state = .loaded
        
        spyView.stubbedViewModel = .init()
    }
    
    func testStartInteractorOnLoad() {
        presenter.onViewWillAppear()
        presenter.onViewWillAppear()
        
        expect(self.spyInteractor.didStartCall) == 1
    }
    
    func testShouldNotDisplayIfSourceNotLoaded() {
        spySourceTasks.state = .loading
        
        presenter.onViewWillAppear()
        
        expectSpinner(true)
        expectViewModelDisplayCount(0)
        expectEmptyViewModel()
    }
    
    func testShouldDisplayViewModelAndUpdateDependencyOnLoad() {
        let expectedViewModel: CompletedListViewModel = presenter.produce(from: .list(stubsModels))!

        presenter.onViewWillAppear()

        expectViewModelDisplayCount(1)
        expectViewModel(expectedViewModel)
    }
}
