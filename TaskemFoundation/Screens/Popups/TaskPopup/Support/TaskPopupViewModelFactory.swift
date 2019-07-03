//
//  TaskPopupViewModelFactory.swift
//  TaskemFoundation
//
//  Created by Wilson on 11/6/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol TaskPopupViewModelFactory {
    
}

public extension TaskPopupViewModelFactory {

    func produce(_ value: Group) -> TaskPopupTagViewModel {
        return .init(tag: .project(value), color: value.color, title: value.name)
    }

    func produce(_ value: RepeatPreferences) -> TaskPopupTagViewModel {
        return .init(tag: .repetition(value), color: colorDefaultTag, title: value.description)
    }
    
    func produce(_ value: Reminder) -> TaskPopupTagViewModel {
        return .init(tag: .reminder(value), color: resolveColor(value.remindDate), title: "Remind: \(value.description)")
    }
    
    func produce(_ value: DatePreferences) -> TaskPopupTagViewModel {
        return .init(tag: .dateAndTime(value), color: resolveColor(value.date, isAllday: value.isAllDay), title: value.description)
    }
}

internal extension TaskPopupViewModelFactory {
    
    func produce(_ data: TaskPopupPresenter.InitialData) -> TaskPopupViewModel {
        var tags: [TaskPopupTagViewModel] = []
        
        if let value = data.group {
            tags.append(produce(value))
        }
        if let value = data.dateConfig {
            tags.append(produce(value))
        }
        if let value = data.reminder {
            tags.append(produce(value))
        }
        if let value = data.repetition {
            tags.append(produce(value))
        }
        return .init(name: data.name ?? "", tags: tags)
    }
}

private extension TaskPopupViewModelFactory {
    var colorDefaultTag: Color {
        return .init(Color.TaskemMain.blue)
    }
    
    var colorOverdueTag: Color {
        return .init(Color.TaskemMain.yellow)
    }
    
    func resolveColor(_ date: Date?, isAllday: Bool? = nil) -> Color {
        if let date = date, date < DateProvider.current.now {
            if Calendar.current.taskem_isSameDay(date: date, in: DateProvider.current.now) {
                if let isAllDay = isAllday, !isAllDay {
                    return colorDefaultTag
                }
            } else {
                return colorOverdueTag
            }
        }
        return colorDefaultTag
    }
}

public class TaskPopupDefaultViewModelFactory: TaskPopupViewModelFactory {
    
    public init() {
        
    }
}
