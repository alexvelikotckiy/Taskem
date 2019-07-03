//
//  CalendarPageView.swift
//  Taskem
//
//  Created by Wilson on 30/08/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol CalendarPageViewDelegate: CalendarPageDelegate {
    func onViewWillAppear()
    
    func onTouchDots()
    func onTouchCalendarControl()
    func onTouchToday()
    
    func onRefresh()
    func onCalendarType(_ type: CalendarStyle)
    func onShowCompleted(_ isShow: Bool)
    
    func onTouchPlus(isLongTap: Bool)
    
    func onTouchCalendar(on date: Date)
    func didShowCalendar(page: CalendarPage)
    func configurePage<T>(_ nextPage: T, direction: CalendarPageDirection, currentPage: CalendarPage) -> T? where T: CalendarPage
    
    func didShowCalendarPage(_ date: Date)
    func hasEvents(on date: Date) -> Bool
}

public protocol CalendarPageView: class {
    var viewDelegate: CalendarPageViewDelegate? { get set }
    var viewModel: CalendarPageViewModel { get set }

    func display(viewModel: CalendarPageViewModel)
    func display(title: String)
    func diplayCalendar(at date: TimelessDate)
    func displayCurrentPage(date: TimelessDate)
    func displayNextPage(date: TimelessDate, direction: CalendarPageDirection)
    func displayCalendar(shouldHide: Bool, animated: Bool)
    
    func reloadCalendar()
}
