//
//  CalendarView.swift
//  Taskem
//
//  Created by Wilson on 10/04/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import Foundation
import EventKit

public protocol CalendarViewDelegate: class {
    func onViewWillAppear()
    
    // a cell selection
    func onTouch(at indexPath: IndexPath, frame: CGRect)
    
    // cell swipes
    func onSwipeLeft(at indexes: [IndexPath], _ completion: @escaping (Bool) -> Void)
    func onSwipeRight(at indexes: [IndexPath])
    
    func onScroll(at index: IndexPath)
    func onChangeDisplayDate(_ date: TimelessDate)
    
    func onChange(_ event: EKEvent?)
    
    func loadPage(at position: PageDirection)
}

public protocol CalendarView: CalendarPage, TableCoordinatorDelegate {
    var delegate: CalendarViewDelegate? { get set }
    var viewModel: CalendarListViewModel { get set }
    
    func display(viewModel: CalendarListViewModel)
    func dislpay(difference viewModel: CalendarListViewModel)
    func display(sections: [CalendarSectionViewModel], at position: PageDirection)
    func displaySpinner(_ isVisible: Bool)
    
    func scroll(to section: Int, animated: Bool)
    func canScroll(_ can: Bool)
}
