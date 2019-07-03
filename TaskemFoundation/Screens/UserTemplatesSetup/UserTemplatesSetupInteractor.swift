//
//  UserTemplatesSetupInteractor.swift
//  Taskem
//
//  Created by Wilson on 29/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol UserTemplatesSetupInteractorOutput: class {
    func usertemplatessetupInteractorDidAddTemplates(_ interactor: UserTemplatesSetupInteractor)
}

public protocol UserTemplatesSetupInteractor: class {
    var delegate: UserTemplatesSetupInteractorOutput? { get set }
    
    func getTemplates() -> [PredefinedProject]
    func setupTemplates(_ templates: [PredefinedProject])
}

public class UserTemplatesSetupStandardInteractor: UserTemplatesSetupInteractor {
    
    public var templatesSource: TemplatesSource
    public var tasksSource: TaskSource
    public var groupsSource: GroupSource
    
    public weak var delegate: UserTemplatesSetupInteractorOutput?

    public init(templatesSource: TemplatesSource,
                tasksSource: TaskSource,
                groupSource: GroupSource) {
        self.templatesSource = templatesSource
        self.tasksSource = tasksSource
        self.groupsSource = groupSource
    }

    public func getTemplates() -> [PredefinedProject] {
        return templatesSource.allTemplates()
    }
    
    public func setupTemplates(_ templates: [PredefinedProject]) {
        let defaultTemplate = templates.first(where: { $0.group.isDefault }) ?? templatesSource.defaultTemplate()
        let allTemplates: [PredefinedProject] = [[defaultTemplate], templates].flatMap { $0 }.uniqueElements
        
        groupsSource.add(groups: allTemplates.map { $0.group })
        groupsSource.setDefalut(byId: defaultTemplate.group.id)
        tasksSource.add(tasks: allTemplates.flatMap { $0.tasks })
        
        groupsSource.restart()
        tasksSource.restart()
        
        delegate?.usertemplatessetupInteractorDidAddTemplates(self)
    }
}
