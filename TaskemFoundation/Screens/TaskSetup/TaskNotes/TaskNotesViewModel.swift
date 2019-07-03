//
//  TaskNotesViewModel.swift
//  Taskem
//
//  Created by Wilson on 13/12/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

public struct TaskNotesViewModel: Equatable {
    public var notes: String

    public init() {
        self.notes = ""
    }

    public init(notes: String) {
        self.notes = notes
    }
}
