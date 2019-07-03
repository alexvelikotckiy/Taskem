//
//  CalendarControlInteractor.swift
//  Taskem
//
//  Created by Wilson on 10/04/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol CalendarControlInteractorOutput: GroupSourceInteractorOutput {
    
}

public protocol CalendarControlInteractor: GroupSourceInteractor {
    var delegate: CalendarControlInteractorOutput? { get set }
    
    func nextFetch(_ completion: @escaping ([Group], [EventKitCalendar]) -> Void)
}

public extension CalendarControlInteractor {
    var interactorGroupsDelegate: GroupSourceInteractorOutput? {
        return delegate
    }
}

public class CalendarControlDefaultInteractor: CalendarControlInteractor {
    public weak var delegate: CalendarControlInteractorOutput?
    
    public var sourceGroups: GroupSource
    public var sourceEventkit: EventKitManager

    public init(sourceGroups: GroupSource,
                sourceEventkit: EventKitManager) {
        self.sourceGroups = sourceGroups
        self.sourceEventkit = sourceEventkit
    }

    deinit {
        stop()
    }
    
    public func start() {
        sourceGroups.addObserver(self)
    }
    
    public func restart() {
        DispatchQueue.global().async {
            self.sourceGroups.restart()
        }
    }
    
    public func stop() {
        sourceGroups.removeObserver(self)
    }

    public func nextFetch(_ completion: @escaping ([Group], [EventKitCalendar]) -> Void) {
        var groups: [Group] = []
        var calendars: [EventKitCalendar] = []
        
        let dispatchGroup = DispatchGroup()
        DispatchQueue.global().async(group: dispatchGroup) {
            groups = self.sourceGroups.allGroups
            calendars = self.sourceEventkit.getCalendars().map { EventKitCalendar(calendar: $0) }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion(groups, calendars)
        }
    }
}
