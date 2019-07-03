//
//  RepeatManualPresenterTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import Nimble

class RepeatManualPresenterBaseTestCase: TaskemTestCaseBase {

    fileprivate var presenter: RepeatManualPresenter!
    
    // Test Doubles
    fileprivate var spyView: RepeatManualViewSpy!
    fileprivate var spyRouter: RepeatManualRouterSpy!
    fileprivate var spyInteractor: RepeatManualInteractorSpy!
    
    fileprivate var initialData: RepeatManualPresenter.InitialData!
    
    fileprivate var callback: TaskRepeatCallback!
    fileprivate var callbackResult: RepeatPreferences?
    fileprivate var callbackCallCount = 0
    
    override func setUp() {
        super.setUp()
        
        spyView = .init()
        spyRouter = .init()
        spyInteractor = .init()
        
        initialData = .initialize {
            $0.repeat = .init(rule: .weekly, daysOfWeek: .init([1,2]), endDate: DateProvider.current.now.tomorrow)
        }
        
        callback = { [weak self] in
            self?.callbackResult = $0
            self?.callbackCallCount += 1
        }
        
        presenter = .init(
            view: spyView,
            router: spyRouter,
            interactor: spyInteractor,
            data: initialData,
            callback: callback
        )
    }
    
    override func tearDown() {
        callbackResult = nil
        callbackCallCount = 0
        
        super.tearDown()
    }
}

class RepeatManualPresenterOnAppearTestCase: RepeatManualPresenterBaseTestCase {
    
    func testShouldBeInteractorObserver() {
        expect(self.presenter).to(beAKindOf(RepeatManualInteractorOutput.self))
        expect(self.spyInteractor.invokedDelegate) === presenter
    }
    
    func testShouldBeViewDelegate() {
        expect(self.presenter).to(beAKindOf(RepeatManualViewDelegate.self))
        expect(self.spyView.invokedDelegate) === presenter
    }
    
    func testContainDaysOfWeekCell() {
        presenter.initialData = .init(repeat: .init(rule: .daily))
        presenter.onViewWillAppear()
        expectContainDaysOfWeekCell(false)
        //
        presenter.initialData = .init(repeat: .init(rule: .weekly))
        presenter.onViewWillAppear()
        expectContainDaysOfWeekCell(true)
    }
    
    func testDisplayValidEndDateCell() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        //
        //
        //
        presenter.initialData = .init(repeat: .init(rule: .none))
        
        presenter.onViewWillAppear()
        
        expectEndDate(title: "Never", subtitle: "")
        //
        //
        let nextMonthAndDay = Date.now.nextMonth.tomorrow
        presenter.initialData = .init(repeat: .init(endDate: nextMonthAndDay))
        
        presenter.onViewWillAppear()
        
        expectEndDate(title: "\(dateFormatter.string(from: nextMonthAndDay))", subtitle: "in 1 month, 1 day")
        //
        //
        let nextYears = Date.now.nextYear.nextYear
        presenter.initialData = .init(repeat: .init(endDate: nextYears))
        
        presenter.onViewWillAppear()
        
        expectEndDate(title: "\(dateFormatter.string(from: nextYears))", subtitle: "in 2 years")
    }
    
    func testShouldValidateInitialData() {
        presenter.initialData = .init(repeat: .init(rule: .none))
        
        presenter.onViewWillAppear()
        
        expect(self.spyView.invokedDisplayParameters?.viewModel.repeat.rule) == .daily
    }
    
    func testShouldDisplayCorrectFirstWeekday() {
        userPreferences.firstWeekday = .sunday
        let sunday = Calendar.current.veryShortWeekdaySymbols[0]
        
        presenter.onViewWillAppear()
        
        expectFirstWeekdaySymbol(sunday)
        //
        //
        userPreferences.firstWeekday = .monday
        let moday = Calendar.current.veryShortWeekdaySymbols[1]
        
        presenter.onViewWillAppear()
        
        expectFirstWeekdaySymbol(moday)
    }
    
    private func expectFirstWeekdaySymbol(_ symbol: String, line: UInt = #line) {
        let cell: RepeatDaysOfWeekData? = invokedViewModel.get { $0.isDayOfWeek }?.unwrap()
        expect(cell?.days.first, line: line) == symbol
    }
    
    private func expectEndDate(title: String, subtitle: String, line: UInt = #line) {
        let cell: RepeatEndDateData? = invokedViewModel.get { $0.isEndDate }?.unwrap()
        expect(cell?.dateTitle, line: line) == title
        expect(cell?.dateSubtitle, line: line) == subtitle
    }
    
    private var invokedViewModel: RepeatManualListViewModel {
        return spyView.invokedDisplayParameters!.viewModel
    }
    
    private func expectContainDaysOfWeekCell(_ isExpected: Bool, line: UInt = #line) {
        let isContain = invokedViewModel.get { $0.isDayOfWeek } != nil
        expect(isExpected, line: line) == isContain
    }
}

class RepeatManualPresenterUserInteractionTestCase: RepeatManualPresenterBaseTestCase {
    
    fileprivate let repeatModelIndex = IndexPath(row: 0, section: 0)
    fileprivate let daysOfWeekIndex = IndexPath(row: 0, section: 1)
    fileprivate let endDateIndex = IndexPath(row: 0, section: 2)
    
    override func setUp() {
        super.setUp()
        
        spyView.stubbedViewModel = RepeatManualViewModelStub().mock
    }
    
    func testChangeCellDisplayTypeOnEndDateCell() {
        presenter.onTouchCell(at: endDateIndex)
        expectEndDate(displayType: .extended)
        expectReload(at: endDateIndex)
        
        presenter.onTouchCell(at: endDateIndex)
        expectEndDate(displayType: .simple)
        expectReload(at: endDateIndex)
    }
    
    func testChangeEndDate() {
        presenter.onTouchCell(at: endDateIndex)
        
        presenter.onChangeEndDate(cellIndex: endDateIndex, date: Date.now.tomorrow)
        
        expectEndDate(displayType: .extended)
        expectReload(at: endDateIndex)
        expect(self.spyView.viewModel.repeat.endDate) == Date.now.tomorrow
    }
    
    func testChangeRepeatType() {
        presenter.onTouchRepeatType(cellIndex: repeatModelIndex, at: 0)
        
        expect(self.spyView.viewModel.repeat.rule) == .daily
    }
    
    func testRemoveDaysOfWeekOnChangeRepeatType() {
        presenter.onTouchRepeatType(cellIndex: repeatModelIndex, at: 0)
        
        expect(self.spyView.viewModel.repeat.rule) == .daily
        expectContainDaysOfWeekCell(false)
    }
    
    func testInsertDaysOfWeekOnChangeRepeatType() {
        presenter.onTouchRepeatType(cellIndex: repeatModelIndex, at: 0)
        
        presenter.onTouchRepeatType(cellIndex: repeatModelIndex, at: 1)
        
        expect(self.spyView.viewModel.repeat.rule) == .weekly
        expectContainDaysOfWeekCell(true)
    }
    
    func testChangeDaysOfWeekWhenMondayIsFirstDay() {
        userPreferences.firstWeekday = .monday
        
        presenter.onTouchDaysOfWeek(cellIndex: daysOfWeekIndex, at: 1)
        presenter.onTouchDaysOfWeek(cellIndex: daysOfWeekIndex, at: 2)
        presenter.onTouchDaysOfWeek(cellIndex: daysOfWeekIndex, at: 7)
        
        expect(self.spyView.viewModel.repeat.daysOfWeek) == [2, 3, 1]
    }
    
    func testChangeDaysOfWeekWhenSundayIsFirstDay() {
        userPreferences.firstWeekday = .sunday
        
        presenter.onTouchDaysOfWeek(cellIndex: daysOfWeekIndex, at: 1)
        presenter.onTouchDaysOfWeek(cellIndex: daysOfWeekIndex, at: 2)
        presenter.onTouchDaysOfWeek(cellIndex: daysOfWeekIndex, at: 7)
        
        expect(self.spyView.viewModel.repeat.daysOfWeek) == [1, 2, 7]
    }
    
    func testSaveAndDismiss() {
        presenter.onTouchSave()
        
        expect(self.spyRouter.invokedDismiss) == true
        expect(self.callbackResult) == viewModel.repeat
    }
    
    private var viewModel: RepeatManualListViewModel {
        return spyView.viewModel
    }
    
    private func expectReload(at index: IndexPath, line: UInt = #line) {
        expect(self.spyView.invokedReloadCellParameters?.index, line: line) == index
    }
    
    private func expectEndDate(displayType: RepeatEndDateData.Presentation, line: UInt = #line) {
        let cell: RepeatEndDateData? = viewModel.get { $0.isEndDate }?.unwrap()
        expect(cell?.style, line: line) == displayType
    }
    
    private func expectContainDaysOfWeekCell(_ isExpected: Bool, line: UInt = #line) {
        let isContain = viewModel.get { $0.isDayOfWeek } != nil
        expect(isExpected, line: line) == isContain
    }
}

private extension RepeatPreferences {
    init(endDate: Date) {
        self.init(
            rule: .daily,
            daysOfWeek: .init(),
            endDate: endDate
        )
    }
}
