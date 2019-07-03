//
//  CalendarPageInteractor.swift
//  Taskem
//
//  Created by Wilson on 30/08/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol CalendarPageInteractorOutput: TaskModelSourceInteractorOutput {

}

public protocol CalendarPageInteractor: TaskModelSourceInteractor {
    var interactorDelegate: CalendarPageInteractorOutput? { get set }
    
    func hasEvents(at interval: DateInterval) -> Bool
}

public extension CalendarPageInteractor {
    var delegate: TaskModelSourceInteractorOutput? {
        return interactorDelegate
    }
}

public class CalendarPageDefaultInteractor: CalendarPageInteractor {
    public weak var interactorDelegate: CalendarPageInteractorOutput?
    
    public var sourceTasks: TaskSource
    public var sourceGroups: GroupSource
    public var sourceEventkit: EventKitManager

    public init(sourceTasks: TaskSource,
                sourceGroups: GroupSource,
                sourceEventkit: EventKitManager) {
        self.sourceTasks = sourceTasks
        self.sourceGroups = sourceGroups
        self.sourceEventkit = sourceEventkit
    }
    
    deinit {
        stop()
    }
    
    public func start() {
        sourceTasks.addObserver(self)
        sourceGroups.addObserver(self)
        getEventKitPermission() { [weak self] permission in
            guard permission else { return }
            self?.restart()
        }
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
    
    public func hasEvents(at interval: DateInterval) -> Bool {
        if sourceTasks.getFirst(matchingInterval: interval) == nil {
            if sourceEventkit.getEvents(matchingInterval: interval).isEmpty {
                return false
            }
        }
        return true
    }
    
    private func getEventKitPermission(_ completion: @escaping (Bool) -> Void) {
        switch sourceEventkit.getPermissions() {
        case .notDetermined:
            askEventKitPermission(completion)
        case .restricted:
            completion(false)
        case .denied:
            completion(false)
        case .authorized:
            completion(true)
        @unknown default:
            fatalError()
        }
    }
    
    private func askEventKitPermission(_ completion: @escaping (Bool) -> Void) {
        sourceEventkit.askForPermissions { result in
            switch result {
            case .allowed:
                completion(true)
            case .prohibited:
                completion(false)
            case .failure:
                completion(false)
            }
        }
    }
}

fileprivate extension TaskSource {
    func getFirst(matchingInterval interval: DateInterval, ignoreCompleted: Bool = true) -> Task? {
        let predicate: (Task) -> Bool = { value in
            if ignoreCompleted, value.completionDate != nil {
                return false
            }
            if let estimateDate = value.datePreference.date {
                return interval.contains(estimateDate)
            }
            return false
        }
        return allTasks.first(where: predicate)
    }
}
