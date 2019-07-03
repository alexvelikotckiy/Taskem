//
//  CalendarRouter.swift
//  TaskemFoundation
//
//  Created by Wilson on 15.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import UIKit
import PainlessInjection

public protocol CompletedRouter {
    func dismiss()
    
    func presentDatePicker(data: DatePickerTemplatesPresenter.InitialData, completion: @escaping DatePickerCallback)
    func presentTask(data: TaskOverviewPresenter.InitialData, frame: CGRect)
    
    func alertDelete(title: String, message: String, completion: @escaping ((Bool) -> Void))
}
