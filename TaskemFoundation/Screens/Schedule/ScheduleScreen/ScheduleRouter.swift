//
//  ScheduleRouter.swift
//  Taskem
//
//  Created by Wilson on 11/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation
import UIKit
import PainlessInjection

public protocol ScheduleRouter {
    func presentPopMenu()
    
    func presentScheduleControl()
    
    func presentTaskPopup(initialData: TaskPopupPresenter.InitialData)
    func presentDatePickerPopup(initialData: DatePickerTemplatesPresenter.InitialData, completion: @escaping DatePickerCallback)
    func presentGroupPopup(initialData: GroupPopupPresenter.InitialData, completion: @escaping GroupPopupCallback)
    
    func presentTask(initialData: TaskOverviewPresenter.InitialData, frame: CGRect?)
    
    func presentReschedule()
    func presentComplete()
    
    func presentSearch()
    
    func alertDelete(title: String, message: String, _ completion: @escaping (Bool) -> Void)
    func alertView(message: String)
}
