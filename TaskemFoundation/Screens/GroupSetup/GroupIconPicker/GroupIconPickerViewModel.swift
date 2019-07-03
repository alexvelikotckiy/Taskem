//
//  GroupIconPickerViewModel.swift
//  Taskem
//
//  Created by Wilson on 21/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct GroupIconPickerViewModel: Equatable {
    public var icon: Icon
    public var selected: Bool

    public init(icon: Icon,
                selected: Bool) {
        self.icon = icon
        self.selected = selected
    }
}

public class GroupIconPickerListViewModel: AutoEquatable {
    public var cells: [GroupIconPickerViewModel]

    public init() {
        self.cells = []
    }

    public init(cells: [GroupIconPickerViewModel]) {
        self.cells = cells
    }

    public func cell(_ indexPath: IndexPath) -> GroupIconPickerViewModel {
        return cells[indexPath.row]
    }
    
    public var selected: Icon {
        return cells.filter { $0.selected }.first?.icon ?? Icon.defaultIcon
    }
    
    public var selectedIndex: IndexPath {
        let row = cells.firstIndex(where: { $0.selected }) ?? 0
        return IndexPath(row: row, section: 0)
    }
}
