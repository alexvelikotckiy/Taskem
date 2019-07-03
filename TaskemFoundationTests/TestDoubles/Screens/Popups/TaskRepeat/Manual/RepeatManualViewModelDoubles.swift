//
//  RepeatManualViewModelDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/16/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class RepeatManualViewModelMock: RepeatManualListViewModel {
    var mock: RepeatManualViewModelMock {
        return .init(repeat: `repeat`, sections: sections)
    }
}

class RepeatManualViewModelStub: RepeatManualViewModelMock {
    override var sections: [RepeatManualSectionViewModel] {
        get {
            return [
                .init(cells: [.repetition(RepeatModelData(cases: RepeatModelData.Model.allCases, selected: RepeatModelData.Model.allCases.first!))]),
                .init(cells: [.daysOfWeek(RepeatDaysOfWeekData(days: Calendar.current.shortWeekdaySymbols, selected: []))]),
                .init(cells: [.endDate(RepeatEndDateData(dateTitle: "", dateSubtitle: "", date: Date.now))]),
            ]
        }
        set {
            
        }
    }
    override var `repeat`: RepeatPreferences {
        get {
            return .init(rule: .weekly, daysOfWeek: .init([]), endDate: Date.now)
        }
        set {
            
        }
    }
}
