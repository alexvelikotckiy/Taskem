//
//  ReminderTemplatesRouter.swift
//  Taskem
//
//  Created by Wilson on 13/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection

public protocol ReminderTemplatesRouter {
    func dismiss()
    func alert(title: String, message: String, completion: @escaping (() -> Void))
    func presentManual(data: ReminderManualPresenter.InitialData, callback: @escaping TaskReminderCallback)
}
