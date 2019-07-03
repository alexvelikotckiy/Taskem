//
//  DatePickerManualInteractorDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/12/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class DatePickerManualInteractorDummy: DatePickerManualInteractor {
    var delegate: DatePickerManualInteractorOutput? {
        set {
        }
        get {
            return nil
        }
    }
}
