//
//  SignUpViewModel.swift
//  Taskem
//
//  Created by Wilson on 14/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct SignUpViewModel {
    public init() {

    }
}

public struct SignUpListViewModel {
    public var cells: [SignUpViewModel]

    public init() {
        self.cells = []
    }

    public init(cells: [SignUpViewModel]) {
        self.cells = cells
    }

    public func cell(for index: Int) -> SignUpViewModel {
        return cells[index]
    }
}
