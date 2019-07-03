//
//  SystemTemplateSource.swift
//  TaskemFoundation
//
//  Created by Wilson on 10.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

open class SystemTemplateSource: TemplatesSource {
    public init() {

    }

    public func defaultTemplate() -> PredefinedProject {
        return .inbox
    }

    public func additionalTemplates() -> [PredefinedProject] {
        return [
            .travel,
            .study,
            .work,
            .birthdays,
            .food,
            .books,
            .movies,
            .habits,
            .computers,
            .workout,
            .health,
            .music,
            .water,
            .calendar,
            .shopping,
            .medicine,
            .sport,
            .games
        ]
    }
}
