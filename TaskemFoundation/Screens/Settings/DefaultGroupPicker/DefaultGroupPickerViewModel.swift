//
//  DefaultGroupPickerViewModel.swift
//  Taskem
//
//  Created by Wilson on 27/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct DefaultGroupPickerViewModel: Equatable {
    public var group: Group
    
    public init(group: Group) {
        self.group = group
    }
}

public class DefaultGroupPickerListViewModel: AutoEquatable {
    public var cells: [DefaultGroupPickerViewModel]
    
    public init() {
        self.cells = []
    }
    
    public init(cells: [DefaultGroupPickerViewModel]) {
        self.cells = cells
    }
    
    public func cell(for index: Int) -> DefaultGroupPickerViewModel {
        return cells[index]
    }
}
