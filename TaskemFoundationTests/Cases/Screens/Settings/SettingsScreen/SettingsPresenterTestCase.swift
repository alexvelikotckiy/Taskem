//
//  SettingsTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class SettingsPresenterTestCaseBase: TaskemTestCaseBase {

    fileprivate var presenter: SettingsPresenter!
    
    fileprivate var viewSpy: SettingsViewSpy!
    fileprivate var routerSpy: SettingsRouterSpy!
    fileprivate var interactorSpy: SettingsInteractorSpy!
    
    override func setUp() {
        super.setUp()
        
        viewSpy = .init()
        routerSpy = .init()
        interactorSpy = .init()
        presenter = SettingsPresenter(view: viewSpy, router: routerSpy, interactor: interactorSpy)
    }
    
    fileprivate func simpleCell(from cell: SettingsViewModel) -> SettingsSimpleViewModel! {
        guard case .simple(let model) = cell else { return nil }
        return model
    }
    
    fileprivate func timeCell(from cell: SettingsViewModel) -> SettingsTimeViewModel! {
        guard case .time(let model) = cell else { return nil }
        return model
    }
}

class SettingsPresenterViewModelCreationTestCase: SettingsPresenterTestCaseBase {
    
    override func setUp() {
        super.setUp()
        
        presenter.onViewWillAppear()
    }
    
    func testContainSections() {
        let sections = viewSpy.viewModel.sections
        
        expect(sections[0].title) == "USER"
        expect(sections[1].title) == "GENERAL"
        expect(sections[2].title) == "TIME"
        expect(sections[3].title) == "DATA"
        expect(sections[4].title) == "SHARE & FEEDBACK"
        expect(sections[5].title) == "LEGAL"
    }
    
    func testContainCells() {
        let sections = viewSpy.viewModel.sections
        
        expect(sections[0].cells[0].item) == .profile
        
        expect(sections[1].cells[0].item) == .theme
        expect(sections[1].cells[1].item) == .reminderSound
        expect(sections[1].cells[2].item) == .firstWeekday
        
        expect(sections[2].cells[0].item) == .morning
        expect(sections[2].cells[1].item) == .noon
        expect(sections[2].cells[2].item) == .evening
        
        expect(sections[3].cells[0].item) == .deaultList
        expect(sections[3].cells[1].item) == .completed
        expect(sections[3].cells[2].item) == .reschedule

        expect(sections[4].cells[0].item) == .share
        expect(sections[4].cells[1].item) == .rateUs
        expect(sections[4].cells[2].item) == .leaveFeedback
        expect(sections[4].cells[3].item) == .help
        
        expect(sections[5].cells[0].item) == .privacyPolicy
        expect(sections[5].cells[1].item) == .termsOfUse
    }
    
    func testProfileCell() {
        let profile = simpleCell(from: viewSpy.viewModel[0].cells[0])!
        
        expect(profile.description) == interactorSpy.currentUser!.name!
    }
    
    func testDefaulListCell() {
        let defaultList = simpleCell(from: viewSpy.viewModel[3].cells[0])!
        
        expect(defaultList.description) == interactorSpy.defaultGroup!.name
    }
    
    func testTimeCells() {
        let morning = timeCell(from: viewSpy.viewModel[2].cells[0])!
        let noon = timeCell(from: viewSpy.viewModel[2].cells[1])!
        let evening = timeCell(from: viewSpy.viewModel[2].cells[2])!
        
        expect(morning.time) == userPreferences.morning
        expect(noon.time) == userPreferences.noon
        expect(evening.time) == userPreferences.evening
        
        expect(morning.minTime) == .init(hour: 0, minute: 0)
        expect(noon.minTime) == userPreferences.morning
        expect(evening.minTime) == userPreferences.noon
        
        expect(morning.maxTime) == userPreferences.noon
        expect(noon.maxTime) == userPreferences.evening
        expect(evening.maxTime) == .init(hour: 23, minute: 59)
    }
}

class SettingsPresenterUserInteractionTestCase: SettingsPresenterTestCaseBase {
    
    override func setUp() {
        super.setUp()
        
        presenter.onViewWillAppear()
    }
    
    func testShouldNavigateToProfile() {
        presenter.onSelect(at: .init(row: 0, section: 0))
        
        expect(self.routerSpy.didPresentUserProfile) == true
    }
    
    func testShouldNavigateToLogInWhenUserIsAnonymous() {
        interactorSpy.currentUser = UserSourceStub.anonymousUserStub()
        
        presenter.onSelect(at: .init(row: 0, section: 0))
        
        expect(self.routerSpy.didPresentUserProfile) == false
        expect(self.routerSpy.didPresentLogIn) == true
    }
    
    func testShouldNavigateToNotificationPicker() {
        presenter.onSelect(at: .init(row: 1, section: 1))
        
        expect(self.routerSpy.didPresentNotificationSoundPicker) == true
    }
    
    func testShouldNavigateToReschedule() {
        presenter.onSelect(at: .init(row: 2, section: 3))
        
        expect(self.routerSpy.didPresentReschedule) == true
    }
    
    func testShouldNavigateToCompletedTasks() {
        presenter.onSelect(at: .init(row: 1, section: 3))
        
        expect(self.routerSpy.didPresentCompletedTasks) == true
    }
    
    func testShouldChangeTheme() {
        let index = IndexPath(row: 0, section: 1)
        
        presenter.onSelect(at: index)
        expect(self.userPreferences.theme) == .dark
        expect(self.viewSpy.lastReloadRows) == [index]
        
        presenter.onSelect(at: index)
        expect(self.userPreferences.theme) == .light
        expect(self.viewSpy.lastReloadRows) == [index]
    }
    
    func testShouldChangeFirstWeekday() {
        let index = IndexPath(row: 2, section: 1)
        
        presenter.onSelect(at: index)
        expect(self.userPreferences.firstWeekday) == .sunday
        expect(self.viewSpy.lastReloadRows) == [index]
        
        presenter.onSelect(at: index)
        expect(self.userPreferences.firstWeekday) == .monday
        expect(self.viewSpy.lastReloadRows) == [index]
    }
    
    func testShouldChangeTime() {
        let calendar = Calendar.current
        let morning = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date.now)!
        let noon = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date.now)!
        let evening = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: Date.now)!
        
        presenter.onChangeTime(at: .init(row: 0, section: 2), date: morning)
        presenter.onChangeTime(at: .init(row: 1, section: 2), date: noon)
        presenter.onChangeTime(at: .init(row: 2, section: 2), date: evening)
        
        expect(self.userPreferences.morning.hour) == morning.hour
        expect(self.userPreferences.morning.minute) == morning.minutes
        expect(self.userPreferences.noon.hour) == noon.hour
        expect(self.userPreferences.noon.minute) == noon.minutes
        expect(self.userPreferences.evening.hour) == evening.hour
        expect(self.userPreferences.evening.minute) == evening.minutes
    }
}

class SettingsPresenterInteractorOutputTestCase: SettingsPresenterTestCaseBase {
    
    func testShouldNotReloadOnUpdateSettingsBeforeFirstLoad() {
        presenter.settingsInteractorDidUpdateSettings()
        
        expect(self.viewSpy.displayViewModelCallsCount) == 0
    }
    
    func testShouldReloadOnUpdateSettingsAfterFirstLoad() {
        presenter.onViewWillAppear()
        presenter.settingsInteractorDidUpdateSettings()
        
        expect(self.viewSpy.displayViewModelCallsCount) == 2
    }
}
