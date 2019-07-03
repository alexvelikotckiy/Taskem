//
//  ObserverCollection.swift
//  TaskemFoundation
//
//  Created by Wilson on 4/7/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct ObserverCollection<T>: Sequence, ExpressibleByArrayLiteral {
    private var collection: [WeakRef<T>] = []

    public init(arrayLiteral elements: T...) {
        collection = elements.compactMap({ WeakRef(object: $0) })
    }

    public func makeIterator() -> Array<T?>.Iterator {
        return collection.compactMap({ $0.object as? T }).makeIterator()
    }

    public mutating func append(_ observer: T) {
        if let object = WeakRef(object: observer) {
            if !contain(observer) {
                collection.append(object)
            }
        }
    }

    public var first: T? {
        return collection.first?.object as? T
    }

    public var last: T? {
        return collection.last?.object as? T
    }
    
    public var count: Int {
        return collection.count
    }

    public mutating func remove(_ observer: T) {
        let object = observer as AnyObject
        if let index = collection.firstIndex(where: { $0.object === object }) {
            collection.remove(at: index)
        }
    }
    
    public func contain(_ observer: T) -> Bool {
        if let object = WeakRef(object: observer) {
            return collection.contains(where: { $0.object === object.object })
        }
        return false
    }
}
