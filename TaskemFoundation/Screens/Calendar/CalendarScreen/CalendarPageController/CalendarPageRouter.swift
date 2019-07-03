//
//  CalendarPageRouter.swift
//  Taskem
//
//  Created by Wilson on 30/08/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol CalendarPageRouter {
    func presentPopMenu()
    
    func presentCalendarControl()
    
    func presentTask(initialData: TaskOverviewPresenter.InitialData)
    func presentTaskPopup(initialData: TaskPopupPresenter.InitialData)
}
