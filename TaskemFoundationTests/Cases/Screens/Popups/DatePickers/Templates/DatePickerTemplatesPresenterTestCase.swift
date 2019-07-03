//
//  DatePickerTemplatesBaseTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/12/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import Nimble

class DatePickerTemplatesBaseTestCase: TaskemTestCaseBase {
    
    fileprivate var presenter: DatePickerTemplatesPresenter!
    
    fileprivate var spyView: DatePickerTemplatesViewSpy!
    fileprivate var spyRouter: DatePickerTemplatesRouterSpy!
    
    fileprivate var initialData: DatePickerTemplatesPresenter.InitialData!
    
    fileprivate var callback: DatePickerCallback!
    fileprivate var callbackResult: DatePreferences?
    fileprivate var callbackCallCount = 0
    
    override func setUp() {
        super.setUp()
        
        spyView = .init()
        spyRouter = .init()
        
        dateProvider.now = dateFormatter.date(from: "12.12.2018")!
        initialData = .initialize {
            $0.dateConfig = .init(assumedDate: dateProvider.now.tomorrow, isAllDay: false)
        }
        
        callback = { [weak self] in
            self?.callbackResult = $0
            self?.callbackCallCount += 1
        }
        
        presenter = .init(
            view: spyView,
            router: spyRouter,
            interactor: DatePickerTemplatesInteractorDummy(),
            data: initialData,
            callback: callback
        )
    }
    
    override func tearDown() {
        callbackResult = nil
        callbackCallCount = 0
        
        super.tearDown()
    }
    
    fileprivate var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter
    }
}

class DatePickerTemplatesPresenterOnLoadTestCase: DatePickerTemplatesBaseTestCase {
    
    func testShouldBeInteractorObserver() {
        expect(self.presenter).to(beAKindOf(DatePickerTemplatesInteractorOutput.self))
    }
    
    func testShouldBeViewDelegate() {
        expect(self.presenter).to(beAKindOf(DatePickerTemplatesViewDelegate.self))
        expect(self.spyView.invokedDelegate) === presenter
    }
    
    func testContainCorrentViewModel() {        
        presenter.onViewWillAppear()
        
        expect(self.spyView.invokedDisplayParameters?.viewModel) == DatePickerTemplatesViewModelStub()
    }
    
    func testDisplayCorrentDayTime() {
        userPreferences.evening = .init(hour: 20, minute: 0)
        dateProvider.now = dateProvider.now.evening
        presenter.onViewWillAppear()
        expectTimeViewModel(.init(title: "EVENING", template: .todayNearest(Icon(Images.Foundation.icEvening), .evening)))
        
        userPreferences.morning = .init(hour: 10, minute: 0)
        dateProvider.now = dateProvider.now.morning
        presenter.onViewWillAppear()
        expectTimeViewModel(.init(title: "MORNING", template: .todayNearest(Icon(Images.Foundation.icMorning), .morning)))
        
        userPreferences.noon = .init(hour: 15, minute: 0)
        dateProvider.now = dateProvider.now.noon
        presenter.onViewWillAppear()
        expectTimeViewModel(.init(title: "NOON", template: .todayNearest(Icon(Images.Foundation.icNoon), .noon)))
    }
    
    private func expectTimeViewModel(_ model: DatePickerTemplatesViewModel, line: UInt = #line) {
        expect(self.spyView.invokedDisplayParameters?.viewModel.cell(.init(row: 1, section: 0)), line: line) == model
    }
}

class DatePickerTemplatesPresenterUserIneractionTestCase: DatePickerTemplatesBaseTestCase {
    
    override func setUp() {
        super.setUp()
        
        presenter.onViewWillAppear()
        
        spyView.stubbedViewModel = DatePickerTemplatesViewModelStub()
    }
    
    func testEmptyCallbackOnDismiss() {
        presenter.onViewWillDismiss()
        
        expect(self.callbackResult).to(beNil())
        expect(self.callbackCallCount) == 1
    }
    
    func testCallbackAndDismissOnSelection() {
        presenter.onTouch(at: .init(row: 1, section: 0))
        expect(self.callbackResult) ==  dateFromString("13.12.2018")
        
        presenter.onTouch(at: .init(row: 0, section: 1))
        expect(self.callbackResult) ==  dateFromString("13.12.2018")
        
        presenter.onTouch(at: .init(row: 1, section: 1))
        expect(self.callbackResult) == dateFromString("15.12.2018")
        
        presenter.onTouch(at: .init(row: 2, section: 1))
        expect(self.callbackResult) == dateFromString("17.12.2018")
        
        presenter.onTouch(at: .init(row: 0, section: 2))
        expect(self.callbackResult) == dateFromString(nil)
        
        expect(self.spyRouter.invokedDismissCount) == 5
    }
    
    func testDisplayDatePickerManual() {
        presenter.onTouch(at: .init(row: 0, section: 0))
        expectDisplayManual(data: .initialize {
            $0.dateConfig = dateFromString("12.12.2018")
            $0.screen = .time
        })
        
        presenter.onTouch(at: .init(row: 1, section: 2))
        expectDisplayManual(data: .initialize {
            $0.dateConfig = initialData.dateConfig
            $0.screen = .calendar
        })
    }
    
    func testDisplayDatePickerManualOnLongTap() {
        presenter.onLongTouch(at: .init(row: 0, section: 1))
        
        expectDisplayManual(data: .initialize {
            $0.dateConfig = dateFromString("13.12.2018")
            $0.screen = .time
        })
    }
    
    private func expectDisplayManual(data: DatePickerManualPresenter.InitialData, line: UInt = #line) {
        expect(self.spyRouter.invokedPresentManualParameters!.initialData, line: line) == data
    }
    
    private func dateFromString(_ string: String?) -> DatePreferences {
        return .init(assumedDate: dateFormatter.date(from: string ?? "") ?? nil, isAllDay: false)
    }
}
