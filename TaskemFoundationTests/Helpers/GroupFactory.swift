//
//  GroupFactory.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/23/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

internal let id_group_1 = "id_group_1"
internal let id_group_2 = "id_group_2"

struct GroupFactory {
    
    func make(
        _ setup: (inout Group) -> Void = { _ in }
        ) -> Group {
        var group = Group(
            id: .auto(),
            name: "Group",
            isDefault: false,
            creationDate: Date.now,
            icon: "icon",
            color: .init(hex: "")
        )
        setup(&group)
        return group
    }
}
