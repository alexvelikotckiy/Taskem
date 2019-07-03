//
//  CustomInitial.swift
//  TaskemFoundation
//
//  Created by Wilson on 11/7/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol CustomInitial {
    init()
}

public extension CustomInitial {
    static func initialize<T>(_ setup: (inout T) -> Void) -> T where T: CustomInitial {
        var data = T()
        setup(&data)
        return data
    }
}
