//
//  CalendarPageViewController+Calendar.swift
//  Taskem
//
//  Created by Wilson on 1/26/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import FSCalendar

extension CalendarPageViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return (viewDelegate?.hasEvents(on: date) ?? false) ? 1 : 0
    }
}

extension CalendarPageViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarDelegate?.calendar!(calendar, boundingRectWillChange: bounds, animated: animated)
        resolveAdditionalSafeAreaInsets(animated: animated)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        viewDelegate?.didShowCalendarPage(calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewDelegate?.onTouchCalendar(on: date)
    }
}
