//
//  UserBean.swift
//  Taskem
//
//  Created by Wilson on 6/27/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct UserBean: Equatable {
    public var name: String?
    public var email: String
    public var pass: String

    public init(email: String, pass: String, name: String? = nil) {
        self.name = name
        self.email = email
        self.pass = pass
    }
}
