//
//  UserTemplatesInteractionTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/22/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import Nimble

class UserTemplatesSetupInteractionTestCase: UserTemplatesSetupTestCaseBase {

    override func setUp() {
        super.setUp()
        
        presenter.onViewWillAppear()
    }
    
    func testShouldSelectIfCellSelectable() {
        presenter.onSelectCell(at: .init(row: 1, section: 0))
        
        expectSelected(at: 1)
        expectSelectable(at: 1)
    }
    
    func testShouldDeselectIfCellSelectable() {
        presenter.onSelectCell(at: .init(row: 1, section: 0))
        presenter.onDeselectCell(at: .init(row: 1, section: 0))
        
        expectDeselected(at: 1)
        expectSelectable(at: 1)
    }
    
    func testShouldNotDeselectIfCellNotSelectable() {
        presenter.onDeselectCell(at: .init(row: 0, section: 0))
        
        expectSelected(at: 0)
        expectNotSelectable(at: 0)
    }
    
    func testShouldSendToInteractorSelectedTemplatesOnContinue() {
        let selected = viewSpy.viewModel.cells.filter { $0.isSelected }.map { $0.template }
        
        presenter.onTouchContinue()
        
        expect(self.interactorSpy.lastSetupTemplates).to(equal(selected))
    }
    
    func testShouldSetOnboardingDefaultDataWasChooseOnContinue() {
        presenter.onTouchContinue()
        
        expect(self.onboardingSettingsStub.onboardingDefaultDataWasChoose).to(beTrue())
    }
    
    private func expectSelected(at index: Int) {
        expect(self.viewSpy.viewModel.cell(for: index).isSelected).to(beTrue())
    }

    private func expectDeselected(at index: Int) {
        expect(self.viewSpy.viewModel.cell(for: index).isSelected).to(beFalse())
    }
    
    private func expectSelectable(at index: Int) {
        expect(self.viewSpy.viewModel.cell(for: index).isSelectable).to(beTrue())
    }
    
    private func expectNotSelectable(at index: Int) {
        expect(self.viewSpy.viewModel.cell(for: index).isSelectable).to(beFalse())
    }
}
