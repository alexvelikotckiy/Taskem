//
//  GroupsInfo.swift
//  TaskemFirebase
//
//  Created by Wilson on 7/3/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct GroupsInfo: Codable, Equatable {
    public var defaultGroup: String
    public var order: [String]

    public init() {
        self.defaultGroup = ""
        self.order = []
    }

    public init(defaultGroup: EntityId) {
        self.defaultGroup = defaultGroup
        self.order = [defaultGroup]
    }
    
    public init(defaultGroup: EntityId, order: [String]) {
        self.defaultGroup = defaultGroup
        self.order = order
    }
    
    public mutating func append(ids: [EntityId]) {
        order.append(contentsOf: ids)
    }
    
    public mutating func remove(ids: [EntityId]) {
        order = order.filter { !ids.contains($0) }
    }
    
    public mutating func replace(id: EntityId, to destination: Int) {
        guard let source = order.firstIndex(where: { $0 == id }) else { return }
        order.remove(at: source)
        order.insert(id, at: destination)
    }
}
