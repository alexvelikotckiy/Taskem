//
//  SortDescriptor.swift
//  TaskemFoundation
//
//  Created by Wilson on 8/8/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public typealias SortDescriptor<Value> = (Value, Value) -> Bool?

func combine<Value>(sortDescriptors: [SortDescriptor<Value>]) -> SortDescriptor<Value> {
    return { lhs, rhs in
        for descriptor in sortDescriptors {
            guard let ascendingResult = descriptor(lhs, rhs) else {
                guard let descendingResult = descriptor(rhs, lhs) else { continue }
                return descendingResult
            }
            return ascendingResult
        }
        return nil
    }
}

func sortDescriptor<Value, Key>(key: @escaping (Value) -> Key,
                                ascending: Bool = true,
                                _ comparator: @escaping (Key) -> (Key) -> ComparisonResult) -> SortDescriptor<Value> {
    return { lhs, rhs in
        let order: ComparisonResult = ascending ? .orderedAscending: .orderedDescending
        return comparator(key(lhs))(key(rhs)) == order
    }
}
