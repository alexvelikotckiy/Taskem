//
//  CompletedPresenter+DataObserverTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/22/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class CompletedDataObserverTestCase: CompletedPresenterTestCaseBase {

    override func setUp() {
        super.setUp()

        spyView.stubbedViewModel = .init()
    }

    func preformActions() {
        presenter.didBeginUpdate()
        presenter.didEndUpdate()
        presenter.didInsertRow(at: .init())
        presenter.didDeleteRow(at: .init())
        presenter.didUpdateRow(at: .init())
        presenter.didDeleteRow(at: .init())
        presenter.didInsertSections(at: .init())
        presenter.didDeleteSections(at: .init())
        presenter.didMoveRow(from: .init(), to: .init())
    }

    func testShouldNotDisplayAllDoneWithinNotEmptyList() {
        spyView.stubbedViewModel.sections = [.init(cells: [], status: .old)]

        preformActions()

        expect(self.spyView.invokedDisplayAllDoneParameters?.isVisible) == false
    }

    func testShouldDisplayAllDoneWithinEmptyList() {
        spyView.stubbedViewModel.sections = []

        preformActions()

        expect(self.spyView.invokedDisplayAllDoneParameters?.isVisible) == true
    }
}
