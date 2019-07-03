//
//  UserTemplatesSetupTestCaseBase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/22/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import Nimble
import TaskemFoundation

class UserTemplatesSetupTestCaseBase: TaskemTestCaseBase {
    
    var viewSpy: UserTemplatesSetupViewSpy!
    var routerSpy: UserTemplatesSetupRouterSpy!
    var interactorSpy: UserTemplatesSetupInteractorSpy!
    var onboardingSettingsStub: OnboardingSettingsStub!
    var presenter: UserTemplatesSetupPresenter!
    
    var templatesSourceStub: TemplatesSourceStub!
    
    override func setUp() {
        super.setUp()
        
        viewSpy = .init()
        routerSpy = .init()
        interactorSpy = .init()
        onboardingSettingsStub = .init()
        presenter = UserTemplatesSetupPresenter(
            view: viewSpy,
            router: routerSpy,
            interactor: interactorSpy,
            onboardingSettings: onboardingSettingsStub
        )
        
        templatesSourceStub = .init()
        interactorSpy.templates = templatesSourceStub.allTemplates()
    }
    
    func testShouldDisplayViewModelOnLoad() {
        presenter.onViewWillAppear()
        
        expectDisplayViewModel()
    }
    
    private func expectDisplayViewModel() {
        expect(self.viewSpy.didDisplayViewModel).to(beTrue())
    }
}
