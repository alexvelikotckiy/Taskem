//
//  GroupPopupViewModel.swift
//  Taskem
//
//  Created by Wilson on 24/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

public enum GroupPopupViewModel: Identifiable, Equatable {
    case newList(GroupPopupNewListViewModel)
    case list(GroupPopupGroupViewModel)
    
    public var id: EntityId {
        switch self {
        case .list(let item):
            return item.id
        case .newList(let item):
            return item.id
        }
    }
}

public struct GroupPopupNewListViewModel: Identifiable, Equatable {
    public var id: EntityId {
        return "new_list"
    }
}

public struct GroupPopupGroupViewModel: Identifiable, Equatable {
    public let group: Group
    public var isSelected: Bool
    
    public init(group: Group,
                isSelected: Bool) {
        self.group = group
        self.isSelected = isSelected
    }
    
    public var id: String {
        return group.id
    }
}

public class GroupPopupSectionViewModel: Section {
    public typealias T = GroupPopupViewModel
    
    public var cells: [GroupPopupViewModel]
    
    public init(cells: [T]) {
        self.cells = cells
    }
}

public class GroupPopupListViewModel: List {
    public typealias T = GroupPopupViewModel
    public typealias U = GroupPopupSectionViewModel
    
    public var sections: [GroupPopupSectionViewModel]
    
    public init() {
        self.sections = []
    }
    
    public init(sections: [U]) {
        self.sections = sections
    }
}
