//
//  TaskPopupInteractor.swift
//  Taskem
//
//  Created by Wilson on 12/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

public protocol TaskPopupInteractorOutput: TaskModelSourceInteractorOutput {

}

public protocol TaskPopupInteractor: TaskModelSourceInteractor {
    var interactorDelegate: TaskPopupInteractorOutput? { get set }
}

public extension TaskPopupInteractor {
    var delegate: TaskModelSourceInteractorOutput? {
        return interactorDelegate
    }
}

public class TaskPopupDefaultInteractor: TaskPopupInteractor {    
    public weak var interactorDelegate: TaskPopupInteractorOutput?

    public var sourceTasks: TaskSource
    public var sourceGroups: GroupSource
    
    public init(sourceTasks: TaskSource,
                sourceGroups: GroupSource) {
        self.sourceTasks = sourceTasks
        self.sourceGroups = sourceGroups
    }

    deinit {
        stop()
    }

    public func start() {
        sourceTasks.addObserver(self)
        sourceGroups.addObserver(self)
    }

    public func restart() {
        DispatchQueue.global().async {
            self.sourceTasks.restart()
            self.sourceGroups.restart()
        }
    }

    public func stop() {
        sourceTasks.removeObserver(self)
        sourceGroups.removeObserver(self)
    }
}
