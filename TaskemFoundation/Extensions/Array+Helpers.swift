//
//  Array+Helpers.swift
//  TaskemFoundation
//
//  Created by Wilson on 06.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

extension Array {
    public subscript(_ indexes: [Int]) -> [Element] {
        var result: [Element] = []
        for index in indexes {
            result.append(self[index])
        }
        return result
    }

    public func random() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

extension Array where Element: Hashable {
    func unique() -> [Element] {
        return Array(Set(self))
    }
}
