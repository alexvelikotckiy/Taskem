//
//  FirebaseErrorResolveTestCase.swift
//  TaskemFirebaseTests
//
//  Created by Wilson on 2/17/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import XCTest
import Nimble
import Quick
import TaskemFoundation
import TaskemFirebase

class FirebaseErrorResolveTestCase: TaskemFirebaseTestCaseBase {
    func testErrorCodes() {
        expect(UserError(rawValue: 17007)) == .emailAlreadyInUse
        expect(UserError(rawValue: 17008)) == .invalidEmail
        expect(UserError(rawValue: 17009)) == .wrongPassword
        expect(UserError(rawValue: 17011)) == .userNotFound
        expect(UserError(rawValue: 17020)) == .networkError
        expect(UserError(rawValue: 17026)) == .weakPassword
        expect(UserError(rawValue: 1)) == .unknown
    }
}
