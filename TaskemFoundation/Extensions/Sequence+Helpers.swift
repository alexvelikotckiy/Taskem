//
//  Sequence+Helpers.swift
//  TaskemFoundation
//
//  Created by Wilson on 6/28/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public extension Sequence where Element: Equatable {
    var uniqueElements: [Element] {
        return self.reduce(into: []) { uniqueElements, element in
            if !uniqueElements.contains(element) {
                uniqueElements.append(element)
            }
        }
    }
}

public extension Sequence {
    func sort(by sortDescriptor: SortDescriptor<Element>) -> [Element] {
        return self.sorted(by: { sortDescriptor($0, $1) ?? false })
    }
}

public extension Sequence where Element: Hashable {
    var set: Set<Element> {
        return Set(self)
    }
}
