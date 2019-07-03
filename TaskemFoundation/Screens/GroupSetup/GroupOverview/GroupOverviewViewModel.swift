//
//  GroupOverviewViewModel.swift
//  Taskem
//
//  Created by Wilson on 21/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public enum GroupOverviewCellViewModel: Equatable, Identifiable {
    case name(String)
    case isDefault(Bool)
    case icon(Icon)
    case color(Color)
    case created(String)
    
    public var id: EntityId {
        switch self {
        case .name:
            return "name"
        case .isDefault:
            return "isDefault"
        case .icon:
            return "icon"
        case .color:
            return "color"
        case .created:
            return "color"
        }
    }
}

public class GroupOverviewSectionViewModel: Section {
    public typealias T = GroupOverviewCellViewModel
    
    public var cells: [GroupOverviewCellViewModel]
    
    public init(cells: [GroupOverviewCellViewModel]) {
        self.cells = cells
    }
}

public class GroupOverviewListViewModel: List {
    public typealias T = GroupOverviewCellViewModel
    public typealias U = GroupOverviewSectionViewModel
    
    public var sections: [GroupOverviewSectionViewModel]
    public var editing: Bool = false
    public var project: Group
    
    private let initialData: GroupOverviewPresenter.InitialData
    
    public init() {
        self.sections = []
        self.initialData = .new(.init(name: ""))
        self.project = initialData.project
    }
    
    public init(sections: [GroupOverviewSectionViewModel],
                initialData: GroupOverviewPresenter.InitialData,
                list: Group,
                editing: Bool) {
        self.sections = sections
        self.initialData = initialData
        self.project = list
        self.editing = editing
    }
    
    internal var hasChanges: Bool {
        return project != initialData.project
    }
    
    public var isNewList: Bool {
        if case .new = initialData { return true }
        return false
    }
    
    public var canDelete: Bool {
        if isNewList {
            return false
        }
        if project.isDefault {
            return false
        }
        return true
    }
}
