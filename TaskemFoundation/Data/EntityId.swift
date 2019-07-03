//
//  EntityId.swift
//  TaskemFoundation
//
//  Created by Wilson on 27.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import  Foundation

public typealias EntityId = String

extension EntityId: Identifiable {
    public var id: EntityId {
        return self
    }
}

extension EntityId {
    public static func auto() -> EntityId {
        return UUID().uuidString
    }
}
