//
//  DefaultComparatorTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/28/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class DefaultComparatorTestCase: TaskemTestCaseBase {

    private let comparator = DefaultСomparator()
    
    private let yesterday = Date.now.yesterday
    private let tomorrow = Date.now.tomorrow
    
    func testCompareDates() {
        expect(self.comparator.compareDates(nil, nil)).to(beNil())
        expect(self.comparator.compareDates(nil, Date.now)) == true
        expect(self.comparator.compareDates(Date.now, nil)) == false
        expect(self.comparator.compareDates(Date.now, Date.now)) == false
        expect(self.comparator.compareDates(Date.now, Date.now.tomorrow)) == true
        expect(self.comparator.compareDates(Date.now.tomorrow, Date.now)) == false
    }
    
    func testCompareAllDay() {
        expect(self.comparator.compareAllDay(true, false)) == false
        expect(self.comparator.compareAllDay(false, true)) == true
        expect(self.comparator.compareAllDay(false, false)).to(beNil())
        expect(self.comparator.compareAllDay(true, true)).to(beNil())
    }
    
    func testCompareWithAlldayPriority() {
        expect(self.comparator.compareDatesWithAllDayPriority(Date.now, lAllDay: true, Date.now, rAllDay: false)) == false
        expect(self.comparator.compareDatesWithAllDayPriority(Date.now, lAllDay: false, Date.now, rAllDay: true)) == true
        expect(self.comparator.compareDatesWithAllDayPriority(Date.now.yesterday, lAllDay: false, Date.now, rAllDay: true)) == true
        expect(self.comparator.compareDatesWithAllDayPriority(Date.now, lAllDay: false, Date.now.tomorrow, rAllDay: true)) == true
        expect(self.comparator.compareDatesWithAllDayPriority(Date.now, lAllDay: false, Date.now.tomorrow, rAllDay: false)) == true
    }
}
