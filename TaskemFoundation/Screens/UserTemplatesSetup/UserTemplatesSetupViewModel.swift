//
//  UserTemplatesSetupViewModel.swift
//  Taskem
//
//  Created by Wilson on 29/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct UserTemplatesSetupViewModel {
    public let template: PredefinedProject
    public var isSelected: Bool
    public var isSelectable: Bool

    public var isDefault: Bool {
        return template.group.isDefault
    }
    
    public init(template: PredefinedProject,
                isSelected: Bool,
                isSelectable: Bool) {
        self.template = template
        self.isSelected = isSelected
        self.isSelectable = isSelectable
    }
}

public struct UserTemplatesSetupListViewModel {
    public var cells: [UserTemplatesSetupViewModel]

    public init() {
        self.cells = []
    }

    public init(cells: [UserTemplatesSetupViewModel]) {
        self.cells = cells
    }

    public func cell(for index: Int) -> UserTemplatesSetupViewModel {
        return cells[index]
    }
}
