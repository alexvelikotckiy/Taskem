//
//  GroupOverviewRouter.swift
//  Taskem
//
//  Created by Wilson on 3/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection
import TaskemFoundation

class GroupOverviewStandardRouter: GroupOverviewRouter {
    weak var controller: GroupOverviewViewController!
    
    init(groupoverviewController: GroupOverviewViewController) {
        self.controller = groupoverviewController
    }

    func dismiss() {
        controller.dismiss(animated: true)
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

    func presentColorPicker(_ data: GroupColorPickerPresenter.InitialData, _ callback: @escaping GroupColorPickerCallback) {
        let vc: GroupColorPickerViewController = Container.get(data, callback)
        controller.navigationController?.pushViewController(vc, animated: true)
    }

    func presentIconPicker(_ data: GroupIconPickerPresenter.InitialData, _ callback: @escaping GroupIconPickerCallback) {
        let vc: GroupIconPickerViewController = Container.get(data, callback)
        controller.navigationController?.pushViewController(vc, animated: true)
    }
}
