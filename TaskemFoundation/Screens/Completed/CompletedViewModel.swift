//
//  CompletedViewModel.swift
//  Taskem
//
//  Created by Wilson on 15/01/2018.
//  Copyright © 2018 WIlson. All rights reserved.
//

import Foundation

public enum CompletedStatus: Int, CustomStringConvertible, CaseIterable {
    case recent
    case old
    
    public var description: String {
        switch self {
        case .recent:
            return "Recent completed"
        case .old:
            return "Old completed"
        }
    }
}

public struct CompletedViewModel: Identifiable, Equatable {
    public var model: TaskModel
    
    public init(model: TaskModel) {
        self.model = model
    }
    
    public var id: EntityId {
        return model.id
    }
}

public class CompletedSectionViewModel: Section {
    public typealias T = CompletedViewModel
    
    public var cells: [CompletedViewModel]
    public var status: CompletedStatus
    
    public init(cells: [CompletedViewModel], status: CompletedStatus) {
        self.cells = cells
        self.status = status
    }
}

public class CompletedListViewModel: List {
    public typealias T = CompletedViewModel
    public typealias U = CompletedSectionViewModel
    
    public var sections: [CompletedSectionViewModel]
    
    public init() {
        self.sections = []
    }

    public init(sections: [CompletedSectionViewModel]) {
        self.sections = sections
    }
}

