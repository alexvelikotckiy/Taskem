//
//  CalendarPageNavController.swift
//  Taskem
//
//  Created by Wilson on 8/30/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

class CalendarPageNavController: UINavigationController {
    
    var calendarNavigationBar: CalendarNavigationBar? {
        return navigationBar as? CalendarNavigationBar
    }
}
