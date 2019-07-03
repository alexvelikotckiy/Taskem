//
//  GroupColorPickerViewModel.swift
//  Taskem
//
//  Created by Wilson on 21/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct GroupColorPickerViewModel: Equatable {
    public var color: Color
    public var selected: Bool

    init(color: Color,
         selected: Bool) {
        self.color = color
        self.selected = selected
    }
}

public class GroupColorPickerListViewModel: AutoEquatable {
    public var cells: [GroupColorPickerViewModel]

    public init() {
        self.cells = []
    }

    public init(cells: [GroupColorPickerViewModel]) {
        self.cells = cells
    }
    
    public func cell(_ indexPath: IndexPath) -> GroupColorPickerViewModel {
        return cells[indexPath.row]
    }
    
    internal var selectedIndex: IndexPath {
        let row = cells.firstIndex(where: { $0.selected }) ?? 0
        return IndexPath(row: row, section: 0)
    }
    
    internal var selected: Color {
        return cells.first(where: { $0.selected })?.color ?? Color.defaultColor
    }
}
