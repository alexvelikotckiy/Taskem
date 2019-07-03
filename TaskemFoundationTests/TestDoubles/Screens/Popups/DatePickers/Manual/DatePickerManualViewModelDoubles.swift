//
//  DatePickerManualViewModelDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class DatePickerManualViewModelStub {
    var viewModel = DatePickerManualViewModel(
        datePreferences: .init(
            assumedDate: DateProvider.current.now,
            isAllDay: false
        ),
        mode: .calendar
    )
}
