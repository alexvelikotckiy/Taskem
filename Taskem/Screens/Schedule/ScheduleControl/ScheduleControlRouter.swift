//
//  GroupControlRouter.swift
//  Taskem
//
//  Created by Wilson on 03/01/2018.
//  Copyright © 2018 WIlson. All rights reserved.
//

import TaskemFoundation
import PainlessInjection

class ScheduleControlStandardRouter: ScheduleControlRouter {
    weak var controller: ScheduleControlViewController!

    init(groupcontrolController: ScheduleControlViewController) {
        self.controller = groupcontrolController
    }

    func dismiss() {
        controller.dismiss(animated: true)
    }

    func presentGroupOverview(_ data: GroupOverviewPresenter.InitialData) {
        let vc: GroupOverviewViewController = Container.get(data)
        let navVc = UINavigationController(rootViewController: vc)
        controller.present(navVc, animated: true)
    }

    func alertDelete(title: String, message: String, _ completion: @escaping ((Bool) -> Void)) {
        let cancelTitle = "Cancel"
        let confirmTitle = "Delete"
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in completion(false) }
        let deleteAction = UIAlertAction(title: confirmTitle, style: .destructive) { _ in completion(true) }

        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        actionSheet.addAction(cancelAction)
        actionSheet.addAction(deleteAction)
        controller.present(actionSheet, animated: true, completion: nil)
    }
}
