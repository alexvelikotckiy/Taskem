//
//  ReminderManualRouter.swift
//  TaskemFoundation
//
//  Created by Wilson on 09.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol ReminderManualRouter {
    func dismiss()
    func alert(title: String, message: String, completion: @escaping (() -> Void))
}
