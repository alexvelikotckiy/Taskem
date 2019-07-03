//
//  DatePickerTemplatesViewModel.swift
//  Taskem
//
//  Created by Wilson on 14/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class DatePickerTemplatesViewModel: AutoEquatable {
    
    public var title: String
    public var template: Template
    
    public init(title: String,
                template: Template) {
        self.title = title
        self.template = template
    }

    public struct Description: Equatable {
        public var title: String
        public var subtitle: String
        
        public init(title: String,
                    subtitle: String) {
            self.title = title
            self.subtitle = subtitle
        }
    }
    
    public enum Time: Equatable {
        case morning
        case noon
        case evening
    }
    
    public enum Template: Equatable {
        case todaySometime(Icon)
        case todayNearest(Icon, Time)
        case tomorrow(Description)
        case weekend(Description)
        case monday(Description)

        case undefined(Icon)
        case custom(Icon)
    }
}

public class DatePickerTemplatesSectionViewModel: AutoEquatable {
    public var cells: [DatePickerTemplatesViewModel]

    public init() {
        self.cells = []
    }

    public init(cells: [DatePickerTemplatesViewModel]) {
        self.cells = cells
    }
}

open class DatePickerTemplatesListViewModel: AutoEquatable {
    open var sections: [DatePickerTemplatesSectionViewModel]

    public init() {
        self.sections = []
    }

    public init(sections: [DatePickerTemplatesSectionViewModel]) {
        self.sections = sections
    }

    public func cell(_ index: IndexPath) -> DatePickerTemplatesViewModel {
        return sections[index.section].cells[index.row]
    }
}
