//
//  UserTemplatesSetupViewInteractionTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/22/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class UserTemplatesSetupOnLoadTestCase: UserTemplatesSetupTestCaseBase {
    
    func testShouldCellsCountToBeEqualToTemplatesCount() {
        let templatesCount = templatesSourceStub.allTemplates().count
        
        presenter.onViewWillAppear()
        
        expect(self.viewSpy.viewModel.cells.count).to(equal(templatesCount))
    }
    
    func testShouldDefaultTemplateBeFirstCell() {
        presenter.onViewWillAppear()

        let firstCell = viewSpy.viewModel.cells.first!
        expect(firstCell.template.group.isDefault).to(beTrue())
    }
    
    func testShouldContainOneDefaultTemplateCell() {
        presenter.onViewWillAppear()
        
        let defaultTemplateCells = viewSpy.viewModel.cells.filter { $0.isDefault }
        expect(defaultTemplateCells.count).to(equal(1))
    }
    
    func testShouldUnselectAllCellsButCellWithDefaultTemplate() {
        presenter.onViewWillAppear()
        
        expectContainSelectedDefaultTemplateCell(viewSpy.viewModel)
    }
    
    func testShouldBeSelectableAllCellsButCellWithDefaultTemplate() {
        presenter.onViewWillAppear()
        
        expectContainSelectableCellsExceptDefaultTemplateCell(viewSpy.viewModel)
    }
    
    private func expectContainSelectableCellsExceptDefaultTemplateCell(_ viewModel: UserTemplatesSetupListViewModel) {
        for cell in viewModel.cells {
            if cell.template.group.isDefault {
                expect(cell.isSelectable).to(beFalse())
            } else {
                expect(cell.isSelectable).to(beTrue())
            }
        }
    }
    
    private func expectContainSelectedDefaultTemplateCell(_ viewModel: UserTemplatesSetupListViewModel) {
        for cell in viewModel.cells {
            if cell.template.group.isDefault {
                expect(cell.isSelected).to(beTrue())
            } else {
                expect(cell.isSelected).to(beFalse())
            }
        }
    }
}
