//
//  EventOverviewViewModel.swift
//  Taskem
//
//  Created by Wilson on 18/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct EventOverviewViewModel {
    public init() {
        
    }
}

public struct EventOverviewListViewModel {    
    public var cells: [EventOverviewViewModel]
    
    public init() {
        self.cells = []
    }
    
    public init(cells: [EventOverviewViewModel]) {
        self.cells = cells
    }
    
    public func cell(for index: Int) -> EventOverviewViewModel {
        return cells[index]
    }
}
