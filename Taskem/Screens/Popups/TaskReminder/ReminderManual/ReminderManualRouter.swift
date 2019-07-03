//
//  TaskReminderSetupRouter.swift
//  Taskem
//
//  Created by Wilson on 09/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import PainlessInjection

class ReminderManualStandardRouter: ReminderManualRouter {
    weak var controller: ReminderManualViewController!

    init(remindermanualController: ReminderManualViewController) {
        self.controller = remindermanualController
    }

    func dismiss() {
        controller.dismiss(animated: true, completion: nil)
    }

    func alert(title: String, message: String, completion: @escaping (() -> Void)) {
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in completion() }
        Alert.displayAlertIn(self.controller, actions: [confirmAction], title: title, message: nil)
    }
}
