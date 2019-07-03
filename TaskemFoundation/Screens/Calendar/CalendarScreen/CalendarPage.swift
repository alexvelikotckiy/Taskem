//
//  CalendarPage.swift
//  TaskemFoundation
//
//  Created by Wilson on 8/31/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import Foundation

public protocol CalendarPage: class {
    var currentDate: TimelessDate { set get }
}

public protocol CalendarPageDelegate: class {
    func didShow(date: TimelessDate)
}

public enum CalendarPageDirection: Int {
    case forward = 0, reverse
}

public extension CalendarPageDirection {
    init(direction: UIPageViewController.NavigationDirection) {
        switch direction {
        case .forward:
            self = .forward
        case .reverse:
            self = .reverse
        @unknown default:
            fatalError()
        }
    }
    
    var pageDirection: UIPageViewController.NavigationDirection {
        switch self {
        case .forward:
            return .forward
        case .reverse:
            return .reverse
        }
    }
}
