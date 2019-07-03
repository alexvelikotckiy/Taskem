//
//  TaskNotesRouter.swift
//  Taskem
//
//  Created by Wilson on 13/12/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import UIKit
import TaskemFoundation

class TaskNotesStandardRouter: TaskNotesRouter {
    weak var controller: TaskNotesViewController!

    init(tasknotesController: TaskNotesViewController) {
        self.controller = tasknotesController
    }
}
