//
//  CalendarPageViewModel.swift
//  Taskem
//
//  Created by Wilson on 30/08/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class CalendarPageViewModel: AutoEquatable {
    public var currentDate: TimelessDate
    public var calendarType: CalendarStyle
    public var title: String
    
    public init() {
        self.currentDate = TimelessDate()
        self.calendarType = .standard
        self.title = ""
    }
    
    public init(currentDate: TimelessDate,
                calendarType: CalendarStyle,
                title: String) {
        self.currentDate = currentDate
        self.calendarType = calendarType
        self.title = title
    }
    
    public var shouldHideCalendarOnWeekScope: Bool {
        switch calendarType {
        case .bydate:
            return false
            
        case .standard:
            return true
        }
    }
    
    public var isScrollPages: Bool {
        switch calendarType {
        case .bydate:
            return true
            
        case .standard:
            return false
        }
    }
}
