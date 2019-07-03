//
//  SchedulePresenterInteractorOutputTestCases.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/31/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class SchedulePresenterInteractorOutputTestCases: SchedulePresenterTestCaseBase {

    override func setUp() {
        super.setUp()
        
        spyView.stubbedViewModel = .init()
        
        presenter.onViewWillAppear()
    }
    
    func testShouldDisplaySpinnerOnLoading() {
        spySourceTasks.state = .loading
        spySourceGroups.state = .loading
        
        presenter.interactorDidChangeStateTasks(spyInteractor, state: .loading)
        
        expectSpinner(true)
        expectViewModelDisplayCount(0)
    }
    
    func testShouldReloadOnLoadTasks() {
        spySourceTasks.state = .loaded
        spySourceGroups.state = .loaded
        
        presenter.interactorDidChangeStateTasks(spyInteractor, state: .loaded)

        expectViewModelDisplayCount(1)
    }
    
    func testShouldAddTasks() {
        presenter.interactor(spyInteractor, didAdd: stubsModels)
        
        expect(self.spyTableCoordinator.inserted as? [TaskModel]) == stubsModels
    }
    
    func testShouldUpdateTasks() {
        presenter.interactor(spyInteractor, didUpdate: stubsModels)
        
        expect(self.spyTableCoordinator.updated as? [TaskModel]) == stubsModels
    }
    
    func testShouldRemoveTasks() {
        let viewModels = stubsModels.map { ScheduleCellViewModel.task($0) }
        
        presenter.interactor(spyInteractor, didRemoveTasks: viewModels.map { $0.id })
        
        let predicate = spyTableCoordinator.removePredicate as! (ScheduleCellViewModel) -> Bool
        for viewModel in viewModels {
            expect(predicate(viewModel)) == true
        }
    }
    
    func testShouldReloadAllOnChangeGroupsOrderIfSortByList() {
        spySourceTasks.state = .loaded
        spySourceGroups.state = .loaded
        
        schedulePreferences.typePreference = .project
        
        presenter.interactor(spyInteractor, didUpdateGroupsOrder: [])
        
        expectViewModelDisplayCount(1)
    }
    
    func testShouldReloadAllOnUpdateGroupIfSortByList() {
        spySourceTasks.state = .loaded
        spySourceGroups.state = .loaded
        
        schedulePreferences.typePreference = .project
        
        presenter.interactor(spyInteractor, didUpdate: Array<Group>())
        
        expectViewModelDisplayCount(1)
    }
}
