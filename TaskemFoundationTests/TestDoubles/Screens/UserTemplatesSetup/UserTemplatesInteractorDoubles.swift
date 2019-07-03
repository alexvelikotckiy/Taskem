//
//  UserTemplatesInteractorDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/22/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class UserTemplatesSetupInteractorMock: UserTemplatesSetupInteractor {
    var delegate: UserTemplatesSetupInteractorOutput? = nil
    
    var templates: [PredefinedProject] = []
    
    func getTemplates() -> [PredefinedProject] {
        return templates
    }
    
    func setupTemplates(_ templates: [PredefinedProject]) {
        
    }
}

class UserTemplatesSetupInteractorSpy: UserTemplatesSetupInteractorMock {
    var didSetupTemplatesCall = false
    var didGetTemplatesCall = false
    
    var lastSetupTemplates: [PredefinedProject] = []
    
    override func getTemplates() -> [PredefinedProject] {
        didSetupTemplatesCall = true
        
        return super.getTemplates()
    }
    
    override func setupTemplates(_ templates: [PredefinedProject]) {
        super.setupTemplates(templates)
        
        didSetupTemplatesCall = true
        lastSetupTemplates = templates
    }
}

class UserTemplatesSetupInteractorObserverSpy: UserTemplatesSetupInteractorOutput {
    var didAddTemplatesCall = false
    
    func usertemplatessetupInteractorDidAddTemplates(_ interactor: UserTemplatesSetupInteractor) {
        didAddTemplatesCall = true
    }
}
