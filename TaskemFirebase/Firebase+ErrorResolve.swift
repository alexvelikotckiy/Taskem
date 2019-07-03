//
//  Firebase+ErrorResolve.swift
//  TaskemFirebase
//
//  Created by Wilson on 6/29/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

public extension UserError {
    init(rawValue: Int) {
        switch rawValue {
        case 17007: self = .emailAlreadyInUse
        case 17008: self = .invalidEmail
        case 17009: self = .wrongPassword
        case 17011: self = .userNotFound
        case 17020: self = .networkError
        case 17026: self = .weakPassword
        default: self = .unknown
        }
    }
}
