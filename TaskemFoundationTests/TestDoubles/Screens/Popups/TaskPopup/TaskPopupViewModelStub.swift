//
//  TaskPopupViewModelStub.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 11/7/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class TaskPopupViewModelMock: TaskPopupViewModel {
    var mock: TaskPopupViewModelMock {
        return .init(name: name, tags: tags)
    }
}

class TaskPopupViewModelStub: TaskPopupViewModelMock {
    
    override var name: String {
        get {
            return "Tag"
        }
        set {
            
        }
    }
    
    override var tags: [TaskPopupTagViewModel] {
        get {
            
            return [
                .init(tag: .project(.init(name: id_group_1)), color: "AAAAAA", title: "project"),
                .init(tag: .dateAndTime(.init(assumedDate: Date.now, isAllDay: false)), color: "AAAAAA", title: "dateAndTime"),
                .init(tag: .repetition(.init(rule: .daily)), color: "AAAAAA", title: "repetition"),
                .init(tag: .reminder((.init(id: .auto(), trigger: .init(absoluteDate: Date.now, relativeOffset: 0)))), color: "AAAAAA", title: "reminder"),
            ]
        }
        set {
            
        }
    }
}
