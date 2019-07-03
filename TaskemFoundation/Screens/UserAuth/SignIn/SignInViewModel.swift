//
//  SignInViewModel.swift
//  Taskem
//
//  Created by Wilson on 14/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct SignInViewModel {
    public init() {

    }
}

public struct SignInListViewModel {
    public var cells: [SignInViewModel]

    public init() {
        self.cells = []
    }

    public init(cells: [SignInViewModel]) {
        self.cells = cells
    }

    public func cell(for index: Int) -> SignInViewModel {
        return cells[index]
    }
}
