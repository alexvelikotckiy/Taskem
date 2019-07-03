//
//  DayTimeTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/28/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class DayTimeTestCase: XCTestCase {
    func testSmoke() {
        let value = DayTime(hour: 12, minute: 12)
        expect(value.hour).to(equal(12))
        expect(value.minute).to(equal(12))
    }
    
    func testShouldBeHashable() {
        let value = DayTime(hour: 1, minute: 1)
        expect(value.hashValue).to(equal(61))
    }
    
    func testShouldBeEquatable() {
        let value1 = DayTime(hour: 1, minute: 1)
        let value2 = DayTime(hour: 1, minute: 1)
        let value3 = DayTime(hour: 2, minute: 1)
        let value4 = DayTime(hour: 1, minute: 4)
        
        expect(value1 == value2).to(beTrue())
        expect(value1 == value3).to(beFalse())
        expect(value1 == value4).to(beFalse())
    }
    
    func testShouldBeComparable() {
        let value1 = DayTime(hour: 1, minute: 1)
        let value2 = DayTime(hour: 1, minute: 1)
        let value3 = DayTime(hour: 2, minute: 1)
        let value4 = DayTime(hour: 1, minute: 4)
        
        expect(value1 > value2).to(beFalse())
        expect(value2 > value1).to(beFalse())
        expect(value3 > value4).to(beTrue())
        expect(value1 < value4).to(beTrue())
        expect(value2 < value3).to(beTrue())
    }
    
}
