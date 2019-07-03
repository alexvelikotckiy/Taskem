//
//  RepeatTemplatesPresenterTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import Nimble

class RepeatTemplatesPresenterTestCase: TaskemTestCaseBase {

    fileprivate var presenter: RepeatTemplatesPresenter!
    
    fileprivate var spyView: RepeatTemplatesViewSpy!
    fileprivate var spyRouter: RepeatTemplatesRouterSpy!
    
    fileprivate var initialData: RepeatTemplatesPresenter.InitialData!
    
    fileprivate var callback: TaskRepeatCallback!
    fileprivate var callbackResult: RepeatPreferences?
    fileprivate var callbackCallCount = 0
    
    override func setUp() {
        super.setUp()
        
        spyView = .init()
        spyRouter = .init()
        
        initialData = .initialize {
            $0.repeat = RepeatPreferences.init(rule: .weekly, daysOfWeek: .init([1,2]), endDate: DateProvider.current.now.tomorrow)
        }
        
        callback = { [weak self] in
            self?.callbackResult = $0
            self?.callbackCallCount += 1
        }
        
        presenter = .init(
            view: spyView,
            router: spyRouter,
            interactor: RepeatTemplatesInteractorDummy(),
            data: initialData,
            callback: callback
        )
    }
    
    override func tearDown() {
        callbackResult = nil
        callbackCallCount = 0
        
        super.tearDown()
    }
    
    func testShouldBeInteractorObserver() {
        expect(self.presenter).to(beAKindOf(RepeatTemplatesInteractorOutput.self))
    }
    
    func testShouldBeViewDelegate() {
        expect(self.presenter).to(beAKindOf(RepeatTemplatesViewDelegate.self))
        expect(self.spyView.invokedDelegate) === presenter
    }
    
    func testDisplayViewModelOnAppear() {
        presenter.onViewWillAppear()
        
        RepeatTemplatesViewModel.Rule.allCases.forEach { expectViewModelContainCellWithRule($0) }
    }
    
    func testBackAndDismiss() {
        presenter.onTouchBack()
        
        expect(self.callbackResult).to(beNil())
        expect(self.callbackCallCount) == 1
    }
    
    func testResolveRepeatAndCallbackOnSelection() {
        spyView.stubbedViewModel = RepeatTemplatesListViewModelMock(rule: .daily)
        presenter.onTouchCell(at: .first)
        expect(self.callbackResult?.rule) == .daily
        //
        spyView.stubbedViewModel = RepeatTemplatesListViewModelMock(rule: .weekdays)
        presenter.onTouchCell(at: .first)
        expect(self.callbackResult?.rule) == .weekly
        //
        spyView.stubbedViewModel = RepeatTemplatesListViewModelMock(rule: .weekends)
        presenter.onTouchCell(at: .first)
        expect(self.callbackResult?.rule) == .weekly
        //
        spyView.stubbedViewModel = RepeatTemplatesListViewModelMock(rule: .weekly)
        presenter.onTouchCell(at: .first)
        expect(self.callbackResult?.rule) == .weekly
        //
        spyView.stubbedViewModel = RepeatTemplatesListViewModelMock(rule: .monthly)
        presenter.onTouchCell(at: .first)
        expect(self.callbackResult?.rule) == .monthly
        //
        spyView.stubbedViewModel = RepeatTemplatesListViewModelMock(rule: .yearly)
        presenter.onTouchCell(at: .first)
        expect(self.callbackResult?.rule) == .yearly
        //
        expect(self.callbackCallCount) == 6
    }
    
    func testPresentManualSetup() {
        spyView.stubbedViewModel = RepeatTemplatesListViewModelMock(rule: .custom)
        
        presenter.onTouchCell(at: .first)
        
        expect(self.spyRouter.invokedPresentManual) == true
        expect(self.spyRouter.invokedPresentManualParameters?.data.repeat) == initialData.repeat
    }
    
    private func expectViewModelContainCellWithRule(_ rule: RepeatTemplatesViewModel.Rule, line: UInt = #line) {
        expect({
            guard self.spyView.invokedDisplayParameters!.viewModel.allCells.contains(where: { $0.rule == rule }) else {
                return .failed(reason: "Should contain cell with a repeat rule")
            }
            return .succeeded
        }, line: line).to(succeed())
    }
}

fileprivate extension IndexPath {
    static var first = IndexPath(row: 0, section: 0)
}
