//
//  RescheduleViewModel.swift
//  Taskem
//
//  Created by Wilson on 18/12/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

public enum SwipeDirection: Int {
    case up = 0
    case down
    case left
    case right
}

public enum RescheduleAction: Int {
    case nearestDate = 0
    case tomorrow
    case weekend
    case noDate
    
    case customDate
    case skip
    case complete
    case delete
    
    public enum Description {
        case icon(Icon)
        case description(String, String)
    }
    
    public func resolveDate() -> Date? {
        let now = DateProvider.current.now
        switch self {
        case .nearestDate:
            if now < now.morning {
                return now.morning
            } else if now < now.noon {
                return now.noon
            } else if now < now.evening {
                return now.evening
            } else {
                return now.endOfDate
            }
        case .tomorrow:
            return now.tomorrow
        case .weekend:
            return Calendar.current.taskem_nextPresentWeekday(after: now)
        case .noDate:
            return nil
            
        default:
            return nil
        }
    }
    
    public var color: Color {
        let palette = Color.TaskemMain.self
        
        switch self {
        case .nearestDate:
            return palette.pinkPurple.color
        case .tomorrow:
            return palette.blueDeep.color
        case .weekend:
            return palette.blueLight.color
        case .noDate:
            return palette.greyDimmed.color
        case .customDate:
            return palette.yellow.color
        case .skip:
            return palette.purple.color
        case .complete:
            return palette.blue.color
        case .delete:
            return palette.redLight.color
        }
    }
    
    public var direction: SwipeDirection {
        switch self {
        case .nearestDate:
            return .left
        case .tomorrow:
            return .right
        case .weekend:
            return .up
        case .noDate:
            return .down
        case .customDate:
            return .left
        case .skip:
            return .up
        case .complete:
            return .right
        case .delete:
            return .down
        }
    }
    
    public var title: String {
        switch self {
        case .nearestDate:
            let now = DateProvider.current.now
            if now < now.morning {
                return "Morning"
            } else if now < now.noon {
                return "Noon"
            } else if now < now.evening {
                return "Evening"
            } else {
                return "Midnight"
            }
        case .tomorrow:
            return "Tomorrow"
        case .weekend:
            return "Weekend"
        case .noDate:
            return "Undefined"
        case .customDate:
            return "Setup Date"
        case .skip:
            return "Skip"
        case .complete:
            return "Complete"
        case .delete:
            return "Delete"
        }
    }
    
    public var description: Description {
        let icons = Images.Foundation.self
        
        switch self {
        case .nearestDate, .tomorrow, .weekend:
            guard let date = resolveDate() else { assert(false); return .description("", "") }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM"
            
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "d"
            
            return .description(dayFormatter.string(from: date), dateFormatter.string(from: date))
        case .noDate:
            return .icon(icons.icRescheduleUndefinedCalendar.icon)
        case .customDate:
            return .icon(icons.icRescheduleCalendar.icon)
        case .skip:
            return .icon(icons.icRescheduleComplete.icon)
        case .complete:
            return .icon(icons.icRescheduleSkip.icon)
        case .delete:
            return .icon(icons.icRescheduleDelete.icon)
        }
    }
}

public struct RescheduleViewModel: Identifiable, Equatable {
    public var model: TaskModel
    
    public init(model: TaskModel) {
        self.model = model
    }
    
    public var id: EntityId {
        return model.id
    }
    
    public var name: String {
        return model.name
    }
    
    public var task: Task {
        return model.task
    }
    
    public var group: Group {
        return model.group
    }
    
    public var planned: String? {
        guard let estimateDate = model.task.datePreference.date else { return nil }
        return "Scheduled on \(dateFormatter.string(from: estimateDate))"
    }
    
    public var plannedSubtitle: String? {
        guard let estimateDate = model.task.datePreference.date else { return nil }
        return Calendar.current.taskem_dateDifferenceToNowDescription(date: estimateDate)
    }
    
    public var created: String {
        return "Created on \(dateFormatter.string(from: model.task.creationDate))"
    }
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
}

public struct RescheduleSwipeOverlay: Equatable {
    public var action: RescheduleAction
    internal let date: Date?
    
    public init(action: RescheduleAction) {
        self.action = action
        self.date = action.resolveDate()
    }
}

public class RescheduleListViewModel: AutoEquatable {
    public var cards: [RescheduleViewModel]
    public var overlays: [RescheduleSwipeOverlay] = []
    
    public var toolbar: Toolbar {
        didSet {
            overlays = toolbarItems(for: toolbar)
        }
    }
    
    public init() {
        self.cards = []
        self.toolbar = .edit
        self.overlays = []
    }
    
    public enum Toolbar {
        case edit
        case dates
    }
    
    public init(cards: [RescheduleViewModel],
                toolbar: Toolbar) {
        self.cards = cards
        self.toolbar = toolbar
        self.overlays = toolbarItems(for: toolbar)
    }
    
    public subscript(index: Int) -> RescheduleViewModel {
        return cards[index]
    }
    
    public func toolbarItems(for type: Toolbar) -> [RescheduleSwipeOverlay] {
        switch type {
        case .edit:
            return [
                .init(action: .customDate),
                .init(action: .complete),
                .init(action: .skip),
                .init(action: .delete),
            ]
        case .dates:
            return [
                .init(action: .nearestDate),
                .init(action: .tomorrow),
                .init(action: .weekend),
                .init(action: .noDate),
            ]
        }
    }
}
