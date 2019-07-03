//
//  PasswordResetViewModel.swift
//  Taskem
//
//  Created by Wilson on 30/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct PasswordResetViewModel {
    public var email: String
    
    public init() {
        self.email = ""
    }
    
    public init(email: String) {
        self.email = email
    }
}

public struct PasswordResetListViewModel {
    public var cells: [PasswordResetViewModel]

    public init() {
        self.cells = []
    }

    public init(cells: [PasswordResetViewModel]) {
        self.cells = cells
    }

    public func cell(for index: Int) -> PasswordResetViewModel {
        return cells[index]
    }
}
