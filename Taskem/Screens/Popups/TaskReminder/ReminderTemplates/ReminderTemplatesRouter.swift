//
//  TaskReminderTemplateSetupRouter.swift
//  Taskem
//
//  Created by Wilson on 13.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import PainlessInjection

class ReminderTemplatesStandardRouter: ReminderTemplatesRouter {
    weak var controller: ReminderTemplatesViewController!

    init(remindertemplatesController: ReminderTemplatesViewController) {
        self.controller = remindertemplatesController
    }

    func dismiss() {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func presentManual(data: ReminderManualPresenter.InitialData, callback: @escaping TaskReminderCallback) {
        let vc: ReminderManualViewController = Container.get(data: data, callback: callback)
        controller.navigationController?.pushViewController(vc, animated: true)
    }

    func alert(title: String, message: String, completion: @escaping (() -> Void)) {
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in completion() }
        Alert.displayAlertIn(self.controller, actions: [confirmAction], title: title, message: message)
    }
}
