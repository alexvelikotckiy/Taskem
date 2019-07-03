//
//  ScheduleInteractor.swift
//  Taskem
//
//  Created by Wilson on 11/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

public protocol ScheduleInteractorOutput: TaskModelSourceInteractorOutput {
    
}

public protocol ScheduleInteractor: TaskModelSourceInteractor {
    var interactorDelegate: ScheduleInteractorOutput? { get set }
    
    func shareTasks(_ tasks: [Task])
}

public extension ScheduleInteractor {
    var delegate: TaskModelSourceInteractorOutput? {
        return interactorDelegate
    }
}

public class ScheduleDefaultInteractor: ScheduleInteractor {
    public weak var interactorDelegate: ScheduleInteractorOutput?

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
