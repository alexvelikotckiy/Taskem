//
//  DatePickerTemplatesViewModelDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/12/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class DatePickerTemplatesViewModelStub: DatePickerTemplatesListViewModel {
    override var sections: [DatePickerTemplatesSectionViewModel] {
        get {
            return [
                .init(cells: [
                    .init(title: "TODAY SOMETIME", template: .todaySometime(Icon(Images.Foundation.icClockLarge))),
                    .init(title: "MORNING", template: .todayNearest(Icon(Images.Foundation.icMorning), .morning)),
                    ]
                ),
                .init(cells: [
                    .init(title: "TOMORROW", template: .tomorrow(.init(title: "13", subtitle: "Dec"))),
                    .init(title: "WEEKENDS", template: .weekend(.init(title: "15", subtitle: "Dec"))),
                    .init(title: "MONDAY", template: .monday(.init(title: "17", subtitle: "Dec"))),
                    ]
                ),
                .init(cells: [
                    .init(title: "UNDEFINED", template: .undefined(Icon(Images.Foundation.icCalendarNoneLarge))),
                    .init(title: "CUSTOM", template: .custom(Icon(Images.Foundation.icCalendarCustom))),
                    ]
                )
            ]
        }
        set {
            
        }
    }
}
