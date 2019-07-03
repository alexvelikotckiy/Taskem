//
//  DevDashboardViewModel.swift
//  Taskem
//
//  Created by Wilson on 12/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct DevDashboardViewModel {
    public init() {
        
    }
}

public struct DevDashboardListViewModel {    
    public var cells: [DevDashboardViewModel]
    
    public init() {
        self.cells = []
    }
    
    public init(cells: [DevDashboardViewModel]) {
        self.cells = cells
    }
    
    public func cell(for index: Int) -> DevDashboardViewModel {
        return cells[index]
    }
}
