//
//  TemplatesSource.swift
//  TaskemFoundation
//
//  Created by Wilson on 10.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol TemplatesSource {
    func defaultTemplate() -> PredefinedProject
    func additionalTemplates() -> [PredefinedProject]
}

public extension TemplatesSource {
    func allTemplates() -> [PredefinedProject] {
        let defaultTemplate = self.defaultTemplate()
        let additionalTemplates = self.additionalTemplates()
        
        return [additionalTemplates, [defaultTemplate]].flatMap { $0 }
    }
}
