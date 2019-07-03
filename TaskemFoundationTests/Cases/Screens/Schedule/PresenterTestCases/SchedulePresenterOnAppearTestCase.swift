//
//  SchedulePresenterOnLoadTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/31/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import Nimble

class SchedulePresenterOnAppearTestCase: SchedulePresenterTestCaseBase {
    
    override func setUp() {
        super.setUp()
        
        spySourceTasks.state = .loaded
        spySourceGroups.state = .loaded
        
        spyView.stubbedViewModel = .init()
    }
    
    func testShouldBeInteractorObserver() {
        expect(self.presenter).to(beAKindOf(ScheduleInteractorOutput.self))
    }
    
    func testShouldBeViewDelegate() {
        expect(self.presenter).to(beAKindOf(ScheduleViewDelegate.self))
        expect(self.spyView.invokedDelegate) === presenter
    }
    
    func testShouldStartTimerOnAppear() {
        presenter.onViewWillAppear()
        
        expect(self.spyTimer.isValid) == true
    }
    
    func testShouldStartInteractorOnAppear() {
        presenter.onViewWillAppear()
        presenter.onViewWillAppear()
        
        expect(self.spyInteractor.didStartCall) == 1
    }
    
    func testShouldNotDisplayViewModelIfSourceNotLoaded() {
        spySourceTasks.state = .loading
        spySourceGroups.state = .loading

        presenter.onViewWillAppear()
        
        expectSpinner(true)
        expectViewModelDisplayCount(0)
        expectEmptyViewModel()
    }
    
    func testShouldDisplayViewModel() {
        let expectedViewModel: ScheduleListViewModel = presenter.produce(from:
            .list(stubsModels, .schedule, spyInteractor.sourceGroups.allGroups, false))!
        
        presenter.onViewWillAppear()
        
        expectViewModelDisplayCount(1)
        expectViewModel(expectedViewModel)
    }
    
    func testShouldReloadViewModelUsingSelectedProjects() {
        schedulePreferences.selectedProjects = [id_group_2]
        
        presenter.onViewWillAppear()
        
        expectViewModelDisplayCount(1)
        expect(self.spyView.invokedDisplayViewModelParameters?.viewModel.allCells.count).toEventually(equal(1))
        expect(self.spyView.invokedDisplayViewModelParameters?.viewModel.allCells.first?.unwrapTask()?.idGroup).toEventually(equal(id_group_2))
    }
    
    func testShouldReloadOnChangeScheduleConfiguration() {
        presenter.onViewWillAppear()
        
        NotificationCenter.default.post(name: .ScheduleConfigurationDidChange, object: nil)
        
        expectViewModelDisplayCount(2)
    }
}
