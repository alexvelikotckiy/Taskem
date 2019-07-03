//
//  Int+Helpers.swift
//  Taskem
//
//  Created by Wilson on 11.11.2017.
//  Copyright © 2017 Wilson. All rights reserved.
//

import Foundation

extension Int {

    func compare(to right: Int) -> ComparisonResult {
        var result = ComparisonResult.orderedDescending

        if self == right {
            result = ComparisonResult.orderedSame
        } else if self < right {
            result = ComparisonResult.orderedAscending
        } else {
            result = ComparisonResult.orderedDescending
        }

        return result
    }
}
