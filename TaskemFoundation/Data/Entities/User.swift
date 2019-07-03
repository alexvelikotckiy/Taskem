//
//  User.swift
//  Taskem
//
//  Created by Wilson on 6/4/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct User: Identifiable, Equatable {
    public var id: String
    public var name: String?
    public var email: String?
    public var creationDate: Date?
    public var isAnonymous: Bool
    public var isVerifiedEmail: Bool
    public var isNew: Bool?

    public init(
        id: String,
        name: String?,
        email: String?,
        creationDate: Date?,
        isAnonymous: Bool,
        isVerifiedEmail: Bool,
        isNew: Bool?
        ) {
        self.id = id
        self.email = email
        self.name = name
        self.creationDate = creationDate
        self.isAnonymous = isAnonymous
        self.isVerifiedEmail = isVerifiedEmail
        self.isNew = isNew
    }
}

extension User: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
