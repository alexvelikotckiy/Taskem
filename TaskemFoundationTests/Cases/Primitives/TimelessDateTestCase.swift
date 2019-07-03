//
//  TimelessDateTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/26/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import Nimble
import TaskemFoundation

class TimelessDateTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
    }

    func testShouldSetNewValue() {
        var timeless = TimelessDate(Date.now)
        
        timeless.value = Date.now.tomorrow
        
        expect(timeless.value) == Date.now.tomorrow.startOfDay
    }
    
    func teshShouldBeNilWhenDateIsNil() {
        let absoluteDate: Date? = nil
        
        let timeless = TimelessDate(absoluteDate)
        
        expect(timeless).to(beNil())
    }
    
    func testShouldValueBeEqualToStartOfDay() {
        let absoluteDate = Date.now
        
        let timeless = TimelessDate(absoluteDate)
        
        expect(timeless.value) == absoluteDate.startOfDay
    }
    
    func testEqual() {
        let valueOne = TimelessDate(Date.now)
        let valueTwo = TimelessDate(Date.now)
        let valueThree = TimelessDate(Date.now.tomorrow)
        
        expect(valueOne == valueTwo) == true
        expect(valueOne == valueThree) == false
    }
    
    func testCompare() {
        let valueOne = TimelessDate(Date.now.yesterday)
        let valueTwo = TimelessDate(Date.now)
        let valueThree = TimelessDate(Date.now.tomorrow)
        
        expect(valueOne < valueOne) == false
        expect(valueOne < valueTwo) == true
        expect(valueThree > valueTwo) == true
    }
}
