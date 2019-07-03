//
//  WeakRef.swift
//  TaskemFoundation
//
//  Created by Wilson on 27.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

public struct WeakRef<T> {
    public weak var object: AnyObject?

    // FIX
    init?(object: T) {
        self.object = object as AnyObject
    }
}

public extension WeakRef where T: AnyObject {
    init(object: T) {
        self.object = object
    }
}
