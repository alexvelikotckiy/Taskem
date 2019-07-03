//
//  CalendarControlRouter.swift
//  Taskem
//
//  Created by Wilson on 4/10/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection
import TaskemFoundation

class CalendarControlStandardRouter: CalendarControlRouter {
    weak var controller: CalendarControlViewController!

    init(calendarcontrolController: CalendarControlViewController) {
        self.controller = calendarcontrolController
    }

    func dismiss() {
        controller.dismiss(animated: true, completion: nil)
    }

    func alert(title: String, message: String, _ completion: @escaping ((Bool) -> Void)) {
        let cancelTitle = "Cancel"
        let confirmTitle = "Confirm"
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in completion(false) }
        let deleteAction = UIAlertAction(title: confirmTitle, style: .destructive) { _ in completion(true) }

        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        actionSheet.addAction(cancelAction)
        actionSheet.addAction(deleteAction)
        controller.present(actionSheet, animated: true, completion: nil)
    }
}
