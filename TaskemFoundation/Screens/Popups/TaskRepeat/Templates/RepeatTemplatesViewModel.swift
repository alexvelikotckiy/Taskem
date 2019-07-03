//
//  RepeatTemplatesViewModel.swift
//  Taskem
//
//  Created by Wilson on 11/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct RepeatTemplatesViewModel: Equatable, Identifiable {
    
    public var title: String
    public var icon: Icon
    public var rule: RepeatTemplatesViewModel.Rule

    public enum Rule: Int, CaseIterable {
        case none
        case daily
        case weekdays
        case weekends
        case weekly
        case monthly
        case yearly
        case custom
    }

    public init(title: String,
                icon: Icon,
                rule: RepeatTemplatesViewModel.Rule) {
        self.title = title
        self.icon = icon
        self.rule = rule
    }
    
    public var id: EntityId {
        return "\(rule.rawValue)"
    }
}

open class RepeatTemplatesSectionViewModel: Section {
    public typealias T = RepeatTemplatesViewModel
    
    public var cells: [RepeatTemplatesViewModel]
    
    public init() {
        self.cells = []
    }
    
    public init(cells: [RepeatTemplatesViewModel]) {
        self.cells = cells
    }
}

open class RepeatTemplatesListViewModel: List {
    public typealias T = RepeatTemplatesViewModel
    public typealias U = RepeatTemplatesSectionViewModel
    
    open var sections: [RepeatTemplatesSectionViewModel]

    public init() {
        self.sections = []
    }

    public init(sections: [RepeatTemplatesSectionViewModel]) {
        self.sections = sections
    }
}
