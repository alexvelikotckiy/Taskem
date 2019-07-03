//
//  PasswordResetInteractorDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/9/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class PasswordResetInteractorDummy: PasswordResetInteractor {
    var delegate: PasswordResetInteractorOutput?
    
    func resetPassword(email: String) {
        
    }
}

class PasswordResetInteractorSpy: PasswordResetInteractorDummy {
    var resetPassWithEmailCalled: String?
    
    override func resetPassword(email: String) {
        resetPassWithEmailCalled = email
    }
}

class PasswordResetInteractorObserverSpy: PasswordResetInteractorOutput {
    var wasSuccessResetPassCalled = false
    var wasFailResetPassCalled = false
    var wasFailResetPassUserNotFoundCalled = false
    
    func passwordresetInteractorDidSendPasswordReset(_ interactor: PasswordResetInteractor) {
        wasSuccessResetPassCalled = true
    }
    
    func passwordresetInteractorDidFailSendPasswordReset(_ interactor: PasswordResetInteractor, _ description: String) {
        wasFailResetPassCalled = true
    }
    
    func passwordresetInteractorDidFailSendPasswordResetUserNotFound(_ interactor: PasswordResetInteractor, _ description: String) {
        wasFailResetPassUserNotFoundCalled = true
    }
}
