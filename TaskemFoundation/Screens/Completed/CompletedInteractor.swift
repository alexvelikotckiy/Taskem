//
//  CompletedInteractor.swift
//  Taskem
//
//  Created by Wilson on 15/01/2018.
//  Copyright © 2018 WIlson. All rights reserved.
//

import Foundation

public protocol CompletedInteractorOutput: TaskModelSourceInteractorOutput {
    
}

public protocol CompletedInteractor: TaskModelSourceInteractor {
    var interactorDelegate: CompletedInteractorOutput? { get set }
}

public extension CompletedInteractor {
    var delegate: TaskModelSourceInteractorOutput? {
        return interactorDelegate
    }
}

public class CompletedDefaultInteractor: CompletedInteractor {
    public weak var interactorDelegate: CompletedInteractorOutput?
    
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
