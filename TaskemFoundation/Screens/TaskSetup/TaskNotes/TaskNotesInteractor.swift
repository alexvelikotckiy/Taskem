//
//  TaskNotesInteractor.swift
//  Taskem
//
//  Created by Wilson on 13/12/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

public protocol TaskNotesInteractorOutput: class {
    
}

public protocol TaskNotesInteractor: class {
    var delegate: TaskNotesInteractorOutput? { get set  }
}

public class TaskNotesDefaultInteractor: TaskNotesInteractor {
    public weak var delegate: TaskNotesInteractorOutput?

    public init() {

    }
}
