//
//  CalendarInteractor.swift
//  Taskem
//
//  Created by Wilson on 10/04/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import EventKit

public protocol CalendarInteractorOutput: TaskModelSourceInteractorOutput {
    func calendarIteractorDidGetEventKitPermission(_ interactor: CalendarInteractor)
    func calendarIteractorDidDiniedEventKitPermission(_ interactor: CalendarInteractor)
    func calendarIteractor(_ interactor: CalendarInteractor, didFailGetEventKitPermission error: Error)
}

public protocol CalendarInteractor: TaskModelSourceInteractor {
    var interactorDelegate: CalendarInteractorOutput? { get set }
    var sourceEventkit: EventKitManager { get }
    
    func cancel()
    func wait()
    
    func load(at interval: DateInterval, filter: @escaping (CalendarCellConvertible) -> Bool, _ completion: @escaping (CalendarCellsConvertible) -> Void)
    func load(at startDate: TimelessDate, direction: PageDirection, filter: @escaping (CalendarCellConvertible) -> Bool, _ completion: @escaping (CalendarCellsConvertible) -> Void)
}

public extension CalendarInteractor {
    var delegate: TaskModelSourceInteractorOutput? {
        return interactorDelegate
    }
}

public class CalendarDefaultInteractor: CalendarInteractor {
    
    public weak var interactorDelegate: CalendarInteractorOutput?
    
    public var sourceTasks: TaskSource
    public var sourceGroups: GroupSource
    public var sourceEventkit: EventKitManager

    private let operationQueue: OperationQueue
    
    public init(sourceTasks: TaskSource,
                sourceGroups: GroupSource,
                sourceEventkit: EventKitManager) {
        self.sourceTasks = sourceTasks
        self.sourceGroups = sourceGroups
        self.sourceEventkit = sourceEventkit
        
        self.operationQueue = .init()
        self.operationQueue.qualityOfService = .utility
        self.operationQueue.isSuspended = true
    }
    
    deinit {
        stop()
    }
    
    public func start() {
        sourceTasks.addObserver(self)
        sourceGroups.addObserver(self)
        operationQueue.isSuspended = false
    }
    
    public func restart() {
        DispatchQueue.global().async {
            self.sourceGroups.restart()
            self.sourceEventkit.reset()
        }
    }
    
    public func stop() {
        sourceTasks.removeObserver(self)
        sourceGroups.removeObserver(self)
        operationQueue.isSuspended = true
    }
    
    public func cancel() {
        operationQueue.cancelAllOperations()
    }
    
    public func wait() {
        operationQueue.waitUntilAllOperationsAreFinished()
    }
    
    public func load(at interval: DateInterval,
                     filter: @escaping (CalendarCellConvertible) -> Bool,
                     _ completion: @escaping (CalendarCellsConvertible) -> Void) {
        handle(instance: _IntervalLoadInstance(interval: interval, context: [.tasks, .events], filter: filter, completion: completion))
    }
    
    public func load(at startDate: TimelessDate,
                     direction: PageDirection,
                     filter: @escaping (CalendarCellConvertible) -> Bool,
                     _ completion: @escaping (CalendarCellsConvertible) -> Void) {
        handle(instance: _PageLoadInstance(startDate: startDate, direction: direction, context: [.tasks, .events], filter: filter, completion: completion))
    }
    
    private func handle(instance: _CalendarLoadInstance) {
        var instance = instance
        let interval = instance.reachInterval()
        
        var operations: [Operation] = []
        
        let outputOperation = _OutputOperation { [weak self] output in
            instance.append(output)
            if instance.shouldStopLoading {
                OperationQueue.main.addOperation {
                    instance.finish()
                }
            } else {
                self?.handle(instance: instance)
            }
        }
        operations.append(outputOperation)

        if instance.context.contains(.tasks) {
            let taskOperation = _TasksFetchOperation(sourceTasks: sourceTasks, sourceGroups: sourceGroups, interval: interval)
            outputOperation.addDependency(taskOperation)
            operations.append(contentsOf: [taskOperation])
        }
        
        if instance.context.contains(.events) {
            let eventOperation = _EventFetchOperation(source: sourceEventkit, interval: interval)
    
            let eventkitAskPermissionOperation = AsyncBlockOperation { [weak self] operation in
                if operation.isCancelled { return }
                self?.getEventKitPermission { _ in
                    operation.state = .finished
                }
            }
            eventOperation.addDependency(eventkitAskPermissionOperation)
            outputOperation.addDependency(eventOperation)
            operations.append(contentsOf: [eventOperation, eventkitAskPermissionOperation])
        }
        
        operationQueue.addOperations(operations, waitUntilFinished: false)
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
        sourceEventkit.askForPermissions { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .allowed:
                strongSelf.interactorDelegate?.calendarIteractorDidGetEventKitPermission(strongSelf)
                completion(true)
            case .prohibited:
                strongSelf.interactorDelegate?.calendarIteractorDidDiniedEventKitPermission(strongSelf)
                completion(false)
            case .failure(let error):
                strongSelf.interactorDelegate?.calendarIteractor(strongSelf, didFailGetEventKitPermission: error)
                completion(false)
            }
        }
    }
}

private struct _CalendarLoadContext: OptionSet, Hashable {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let tasks    = _CalendarLoadContext(rawValue: 1 << 0)
    public static let events   = _CalendarLoadContext(rawValue: 1 << 1)
}

private protocol _CalendarLoadInstance {
    var context: _CalendarLoadContext { get }
    var shouldStopLoading: Bool { get }
    
    mutating func finish()
    mutating func append(_ value: CalendarCellsConvertible)
    mutating func reachInterval() -> DateInterval
}

private struct _IntervalLoadInstance: _CalendarLoadInstance {
    private let interval: DateInterval
    private let filter: (CalendarCellConvertible) -> Bool
    private let completion: (CalendarCellsConvertible) -> Void
    
    private var result: CalendarCellsConvertible = []
    private var didReachInterval = false
    
    public let context: _CalendarLoadContext
    
    public init(interval: DateInterval,
                context: _CalendarLoadContext,
                filter: @escaping (CalendarCellConvertible) -> Bool,
                completion: @escaping (CalendarCellsConvertible) -> Void) {
        self.interval = interval
        self.context = context
        self.filter = filter
        self.completion = completion
    }
    
    mutating func finish() {
        completion(result)
    }
    
    mutating func append(_ values: CalendarCellsConvertible) {
        result.append(contentsOf: values.filter(filter))
    }
    
    mutating func reachInterval() -> DateInterval {
        didReachInterval = true
        return interval
    }
    
    var shouldStopLoading: Bool {
        return didReachInterval
    }
}

private struct _PageLoadInstance: _CalendarLoadInstance {
    private let startDate: TimelessDate
    private let direction: PageDirection
    private let filter: (CalendarCellConvertible) -> Bool
    private let completion: ([CalendarCellConvertible]) -> Void
    
    private var result: CalendarCellsConvertible = []
    private var intervalCounter = DateInterval() {
        didSet {
            print(intervalCounter)
        }
    }
    
    public let context: _CalendarLoadContext
    
    // Constants
    private let loadLimit: Int = 30
    private let maxFetchInterval = 31536000 * 10 as TimeInterval // 10 Years
    
    public init(startDate: TimelessDate,
                direction: PageDirection,
                context: _CalendarLoadContext,
                filter: @escaping (CalendarCellConvertible) -> Bool,
                completion: @escaping (CalendarCellsConvertible) -> Void) {
        self.startDate = startDate
        self.context = context
        self.direction = direction
        self.filter = filter
        self.completion = completion
    }
    
    mutating func finish() {
        completion(result)
    }
    
    mutating func append(_ values: CalendarCellsConvertible) {
        result.append(contentsOf: values.filter(filter))
    }
    
    mutating func reachInterval() -> DateInterval {
        if intervalCounter.duration.isZero {
            intervalCounter = Calendar.current.generateDateInterval(from: startDate.value, to: direction, loadLimit: loadLimit)
            return intervalCounter
        }
        
        switch direction {
        case [.top, .bottom]:
            fallthrough
            
        case .bottom:
            let nextDate = Calendar.current.taskem_dateFromDays(intervalCounter.end, days: loadLimit)
            let nextInterval = DateInterval(start: intervalCounter.end, end: nextDate)
            
            intervalCounter = DateInterval(start: intervalCounter.start, end: nextInterval.end)
            
            return nextInterval
            
        case .top:
            let prevDate = Calendar.current.taskem_dateFromDays(intervalCounter.start, days: -loadLimit)
            let prevInterval = DateInterval(start: prevDate, end: intervalCounter.start)
            
            intervalCounter = DateInterval(start: prevInterval.start, end: intervalCounter.end)
            
            return prevInterval
            
        default:
            fatalError()
        }
    }
    
    public var shouldStopLoading: Bool {
        return isEnoughEvents || hasReachedMaxFetchInterval
    }
    
    private var isEnoughEvents: Bool {
        return result.count > loadLimit
    }
    
    private var hasReachedMaxFetchInterval: Bool {
        return intervalCounter.duration > maxFetchInterval
    }
}

private class _OutputOperation: AsyncOperation {
    private let completion: (CalendarCellsConvertible) -> Void
    
    public init(completion: @escaping (CalendarCellsConvertible) -> Void) {
        self.completion = completion
        super.init()
    }
    
    public override func main() {
        if isCancelled { return }
        completion(output)
        state = .finished
    }
    
    private var output: CalendarCellsConvertible {
        var output: CalendarCellsConvertible = []
        if let operation = dependencies
            .filter({ $0 is _TasksFetchOperation })
            .first as? _TasksFetchOperation  {
            output.append(contentsOf: operation.tasks)
        }
        if let operation = dependencies
            .filter({ $0 is _EventFetchOperation })
            .first as? _EventFetchOperation  {
            output.append(contentsOf: operation.events)
        }
        return output
    }
}

private class _TasksFetchOperation: AsyncOperation {
    // Input
    private let sourceTasks: TaskSource
    private let sourceGroups: GroupSource
    private let interval: DateInterval

    // Output
    public var tasks: [TaskModel] = []
    
    public init(sourceTasks: TaskSource,
                sourceGroups: GroupSource,
                interval: DateInterval) {
        self.sourceTasks = sourceTasks
        self.sourceGroups = sourceGroups
        self.interval = interval
        super.init()
    }

    override func main() {
        if isCancelled { return }
        
        tasks = sourceTasks.allTasks
            .filter(predicate)
            .compose(with: sourceGroups.allGroups)

        state = .finished
    }
    
    private var predicate: (Task) -> Bool {
        return { value in
            guard let date = value.datePreference.date else { return false }
            return self.interval.contains(date)
        }
    }
}

private class _EventFetchOperation: AsyncOperation {
    // Input
    private let source: EventKitManager
    private let interval: DateInterval
    
    // Output
    public var events: [EventModel] = []

    public init(source: EventKitManager,
                interval: DateInterval) {
        self.source = source
        self.interval = interval
        super.init()
    }
    
    override func main() {
        if isCancelled { return }
        
        events += source.getEvents(matchingInterval: interval)
            .map { EventKitTask(event: $0).convertToModel(at: interval) }
            .flatMap { $0 }
        state = .finished
    }
}
