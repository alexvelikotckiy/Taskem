//
//  Array+Shift.swift
//  MGSwipeCards
//
//  Created by Mac Gallagher on 6/30/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import Foundation

extension Array {
    
    func shift(withDistance distance: Int = 1) -> Array<Element> {
        let offsetIndex = distance >= 0 ?
            self.index(startIndex, offsetBy: distance, limitedBy: endIndex) :
            self.index(endIndex, offsetBy: distance, limitedBy: startIndex)
        guard let index = offsetIndex else { return self }
        return Array(self[index ..< endIndex] + self[startIndex ..< index])
    }
    
}

extension Array where Element: Hashable {
    
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set<Element>(self)
        let otherSet = Set<Element>(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
    
}
