//
//  TaskOverviewInteractor.swift
//  Taskem
//
//  Created by Wilson on 01/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol TaskOverviewInteractorOutput: TaskModelSourceInteractorOutput {

}

public protocol TaskOverviewInteractor: TaskModelSourceInteractor {
    var interactorDelegate: TaskOverviewInteractorOutput? { get set }
    
    func shareTasks(_ tasks: [Task])
}

public extension TaskOverviewInteractor {
    var delegate: TaskModelSourceInteractorOutput? {
        return interactorDelegate
    }
}

public class TaskOverviewDefaultInteractor: TaskOverviewInteractor {
    public weak var interactorDelegate: TaskOverviewInteractorOutput?

    public var sourceTasks: TaskSource
    public var sourceGroups: GroupSource
    public var shareService: SharingService
        
    public init(sourceTasks: TaskSource,
                sourceGroups: GroupSource,
                shareService: SharingService) {
        self.sourceTasks = sourceTasks
        self.sourceGroups = sourceGroups
        self.shareService = shareService
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
    
    public func shareTasks(_ tasks: [Task]) {
        guard let shareString = shareService.createShareText(from: tasks) else { return }
        shareService.share(text: shareString)
    }
}
