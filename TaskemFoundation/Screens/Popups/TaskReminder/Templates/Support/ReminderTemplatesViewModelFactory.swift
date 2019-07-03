//
//  ReminderTemplatesViewModelFactory.swift
//  TaskemFoundation
//
//  Created by Wilson on 9/3/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol ReminderTemplatesViewModelFactory: class {
    
}

public extension ReminderTemplatesViewModelFactory {
    func produceViewModel(reminder: Reminder) -> ReminderTemplatesListViewModel {
        let sections = [
            produceNoneSection(),
            produceTemplatesSection(),
            produceCustomSection()
        ]
        return .init(reminder: reminder, sections: sections)
    }
    
    func produceNoneSection() -> ReminderTemplatesSectionViewModel {
        return .init(cells: [
            .init(title: "None", icon: .init(Images.Foundation.icCalendarNone), model: .none)
            ]
        )
    }
    
    func produceTemplatesSection() -> ReminderTemplatesSectionViewModel {
        return .init(cells: [
            .init(title: "At event time", icon: .init(Images.Foundation.icReminderAtEventDate), model: .atEventTime),
            .init(title: "5 minutes before", icon: .init(Images.Foundation.icReminderFiveMinutesBefore), model: .fiveMinutesBefore),
            .init(title: "30 minutes before", icon: .init(Images.Foundation.icReminderThirtyMinutesBefore), model: .halfHourBefore),
            .init(title: "1 hour before", icon: .init(Images.Foundation.icReminderHourBefore), model: .oneHourBefore),
            .init(title: "1 day before", icon: .init(Images.Foundation.icReminderOneDay), model: .oneDayBefore),
            .init(title: "1 week before", icon: .init(Images.Foundation.icReminderOneWeek), model: .oneWeekBebore)
            ]
        )
    }
    
    func produceCustomSection() -> ReminderTemplatesSectionViewModel {
        return .init(cells: [
            .init(title: "Custom", icon: .init(Images.Foundation.icReminderCustomDate), model: .customUsingDayTime)
            ]
        )
    }
}

public class ReminderTemplatesDefaultViewModelFactory: ReminderTemplatesViewModelFactory {
    
}
