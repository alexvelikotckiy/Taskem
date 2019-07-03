//
//  TemplatesSourceTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/22/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import Nimble
import TaskemFoundation

class TemplatesSourceTestCase: TaskemTestCaseBase {

    private var templatesSource: SystemTemplateSource!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        templatesSource = .init()
    }

    func testShouldBeTemplateSource() {
        expect(self.templatesSource).to(beAKindOf(TemplatesSource.self))
    }
    
    func testShouldDefaultTemplateContainDefaultGroup() {
        let defaultTemplate = templatesSource.defaultTemplate()
        
        expect(defaultTemplate.group.isDefault).to(beTrue())
        expectNotEmptyNames(defaultTemplate)
    }
    
    func testShouldReturnTemplates() {
        let templates = templatesSource.additionalTemplates()
        
        for template in templates {
            expectNotEmptyNames(template)
        }
    }
    
    func testShouldAdditionalTemplatesDontContainDefaultGroup() {
        let additionalTemplates = templatesSource.additionalTemplates()
        
        expectNotDefaultGroup(additionalTemplates)
    }
    
    func testShouldMatchGroupIdsInTemplateTasks() {
        let allTemplates = templatesSource.allTemplates()
        
        expectMatchGroupIds(allTemplates)
    }
    
    private func expectContainIcon(_ icon: Icon, in icons: [Icon], line: UInt = #line) {
        expect(icons.contains(icon), line: line) == true
    }
    
    private func expectNotDefaultGroup(_ templates: [PredefinedProject], line: UInt = #line) {
        for template in templates {
            expect(template.group.isDefault, line: line) == false
        }
    }
    
    private func expectMatchGroupIds(_ templates: [PredefinedProject], line: UInt = #line) {
        for template in templates {
            for tasks in template.tasks {
                expect(tasks.idGroup, line: line) == template.group.id
            }
        }
    }
    
    private func expectNotEmptyNames(_ template: PredefinedProject, line: UInt = #line) {
        expect(template.group.name, line: line).notTo(beEmpty())
        for task in template.tasks {
            expect(task.name, line: line).toNot(beEmpty())
        }
    }
}
