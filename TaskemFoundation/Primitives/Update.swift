//
//  Update.swift
//  TaskemFoundation
//
//  Created by Wilson on 27.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

public struct Update<Value> {
    public let new: Value
    public let old: Value

    public init(new: Value, old: Value) {
        self.new = new
        self.old = old
    }
}

public extension Update {
    static func make<Value>(new: Value, old: Value) -> Update<Value> {
        return Update<Value>(new: new, old: old)
    }
}
