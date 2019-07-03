//
//  GroupControlInteractor.swift
//  Taskem
//
//  Created by Wilson on 03/01/2018.
//  Copyright © 2018 WIlson. All rights reserved.
//

import Foundation

public protocol ScheduleControlInteractorOutput: TaskModelSourceInteractorOutput {

}

public protocol ScheduleControlInteractor: TaskModelSourceInteractor {
    var interactorDelegate: ScheduleControlInteractorOutput? { get set }
}

public extension ScheduleControlInteractor {
    var delegate: TaskModelSourceInteractorOutput? {
        return interactorDelegate
    }
}

public class ScheduleControlDefaultInteractor: ScheduleControlInteractor {
    public weak var interactorDelegate: ScheduleControlInteractorOutput?
    
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
