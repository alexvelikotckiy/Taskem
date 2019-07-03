//
//  GroupEntity.swift
//  Taskem
//
//  Created by Wilson on 11.11.2017.
//  Copyright © 2017 Wilson. All rights reserved.
//

import Foundation

public struct Group: Codable, Identifiable, Equatable {
    public var id: EntityId
    public var name: String
    public var creationDate: Date
    public var icon: Icon
    public var color: Color
    public var isDefault: Bool!

    public init(
        name: String
        ) {
        self.id = .auto()
        self.name = name
        self.isDefault = false
        self.icon = .init(Images.Lists.icEmailinbox)
        self.color = Color.defaultColor
        self.creationDate = .init()
    }

    public init(
        id: EntityId,
        name: String,
        isDefault: Bool,
        creationDate: Date,
        icon: Icon,
        color: Color
        ) {
        self.id = id
        self.name = name
        self.isDefault = isDefault
        self.creationDate = creationDate
        self.icon = icon
        self.color = color
    }

    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case creationDate
        case icon
        case color
    }
}

extension Group: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
