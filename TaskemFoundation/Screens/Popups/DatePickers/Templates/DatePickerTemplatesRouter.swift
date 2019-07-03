//
//  DatePickerTemplatesRouter.swift
//  Taskem
//
//  Created by Wilson on 14/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection

public typealias DatePickerCallback = ((DatePreferences?) -> Void)

public protocol DatePickerTemplatesRouter {
    func dismiss()
    
    func presentManual(_ initialData: DatePickerManualPresenter.InitialData, callback: @escaping DatePickerCallback)
}
