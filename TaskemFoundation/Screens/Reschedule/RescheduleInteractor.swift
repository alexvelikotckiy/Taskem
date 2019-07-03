//
//  RescheduleInteractor.swift
//  Taskem
//
//  Created by Wilson on 18/12/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

public protocol RescheduleInteractorOutput: TaskModelSourceInteractorOutput {

}

public protocol RescheduleInteractor: TaskModelSourceInteractor {
    var interactorDelegate: RescheduleInteractorOutput? { get set }
}

public extension RescheduleInteractor {
    var delegate: TaskModelSourceInteractorOutput? {
        return interactorDelegate
    }
}

public class RescheduleDefaultInteractor: RescheduleInteractor {
    public weak var interactorDelegate: RescheduleInteractorOutput?
    
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
