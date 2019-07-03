//
//  UserTemplatesSetupInteractorTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/22/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class UserTemplatesSetupInteractorTestCase: TaskemTestCaseBase {

    var interactor: UserTemplatesSetupStandardInteractor!    
    var interatorObserverSpy: UserTemplatesSetupInteractorObserverSpy!

    var sourceTasksSpy: TaskSourceSpy!
    var sourceGroupsSpy: GroupSourceSpy!
    var sourceTemplatesMock: TemplatesSourceMock!
    
    override func setUp() {
        super.setUp()
        
        interatorObserverSpy = .init()
        sourceTasksSpy = .init()
        sourceGroupsSpy = .init()
        sourceTemplatesMock = .init()
        sourceTemplatesMock.additionalTemplatesMock = TemplatesSourceStub().additionalTemplates()
        sourceTemplatesMock.defaultTemplateMock = TemplatesSourceStub().defaultTemplate()
        
        interactor = UserTemplatesSetupStandardInteractor(
            templatesSource: sourceTemplatesMock,
            tasksSource: sourceTasksSpy,
            groupSource: sourceGroupsSpy
        )
        interactor.delegate = interatorObserverSpy
    }
    
    func testShouldReturnValidTemplates() {
        let templates = sourceTemplatesMock.allTemplates()
        
        let fetchedTemplates = interactor.getTemplates()
        
        expect(fetchedTemplates).to(equal(templates))
    }
    
    func testShouldSaveTemplatesToServices() {
        let templates = sourceTemplatesMock.allTemplates()
        let groups = templates.map { $0.group }
        let tasks = templates.flatMap { $0.tasks }
        
        interactor.setupTemplates(templates)
        
        expect(self.sourceGroupsSpy.lastDefaultGroup) == groups.first(where: { $0.isDefault })?.id
        expect(self.sourceGroupsSpy.addedGroups.set) == groups.set
        expect(self.sourceTasksSpy.addedTasks.set) == tasks.set
    }
    
    func testShouldCallbackAfterSetupTemplates() {
        let templates = sourceTemplatesMock.allTemplates()
        
        interactor.setupTemplates(templates)
        
        expect(self.interatorObserverSpy.didAddTemplatesCall).to(beTrue())
    }
}

class UserTemplatesSetupInteractorOutputTestCase: UserTemplatesSetupTestCaseBase {
    
    func testShouldUpdateOnBoardSettingsAfterSetupTemplates() {
        presenter.usertemplatessetupInteractorDidAddTemplates(interactorSpy)
        
        expect(self.onboardingSettingsStub.onboardingDefaultDataWasChoose).to(beTrue())
    }
}
