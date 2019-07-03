//
//  RescheduleRouter.swift
//  Taskem
//
//  Created by Wilson on 18/12/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

public protocol RescheduleRouter {
    func presentDatePickerPopup(initialData: DatePickerTemplatesPresenter.InitialData, completion: @escaping DatePickerCallback)
}
