//
//  CalendarRouter.swift
//  Taskem
//
//  Created by Wilson on 10/04/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import UIKit

public protocol CalendarRouter {
    func presentTask(data: TaskOverviewPresenter.InitialData, frame: CGRect)
    func presentEvent(data: EventOverviewPresenter.InitialData, frame: CGRect)
    func presentTaskPopup(data: TaskPopupPresenter.InitialData)
    func presentDatePicker(data: DatePickerTemplatesPresenter.InitialData, completion: @escaping DatePickerCallback)
    
    func postAlert(title: String, message: String?)
}
