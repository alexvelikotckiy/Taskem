//
//  CompletedRouter.swift
//  Taskem
//
//  Created by Wilson on 15/01/2018.
//  Copyright © 2018 WIlson. All rights reserved.
//

import Foundation
import TaskemFoundation
import PainlessInjection

class CompletedStandardRouter: CompletedRouter {
    weak var controller: CompletedViewController!

    private var modalTransitioningDelegate: ModalTransitioningDelegate?
    private var expandTransitioningDelegate: ExpandTransitioningDelegate?

    init(completedController: CompletedViewController) {
        self.controller = completedController
    }

    func dismiss() {
        self.controller.navigationController?.popViewController(animated: true)
    }

    func presentDatePicker(data: DatePickerTemplatesPresenter.InitialData, completion: @escaping DatePickerCallback) {
        let vc: DatePickerTemplatesViewController = Container.get(data: data, callback: completion)
        let navVC = ModalNavController(controller: vc)
        modalTransitioningDelegate = .init()
        navVC.transitioningDelegate = self.modalTransitioningDelegate
        controller.navigationController?.present(navVC, animated: true, completion: nil)
    }
    
    public func presentTask(data initialData: TaskOverviewPresenter.InitialData, frame: CGRect) {
        
    }
    
//    func presentTask(type: TaskDataType, frame: CGRect) {
//        let vc: TaskSetupViewController = Container.get(type: type)
//        self.expandTransitioningDelegate = .init(viewController: controller, presentingViewController: vc, collapsedFrame: frame)
//        vc.modalPresentationStyle = .custom
//        vc.transitioningDelegate = expandTransitioningDelegate
//
//        // http://openradar.appspot.com/19563577
//        DispatchQueue.main.async {
//            self.controller.present(vc, animated: true, completion: nil)
//        }
//    }

    func alertDelete(title: String, message: String, completion: @escaping ((Bool) -> Void)) {
        let cancelTitle = "Cancel"
        let confirmTitle = "Delete"
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in completion(false) }
        let deleteAction = UIAlertAction(title: confirmTitle, style: .destructive) { _ in completion(true) }

        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        actionSheet.addAction(cancelAction)
        actionSheet.addAction(deleteAction)
        self.controller.present(actionSheet, animated: true, completion: nil)
    }
}
