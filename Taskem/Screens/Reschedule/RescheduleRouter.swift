//
//  RescheduleRouter.swift
//  Taskem
//
//  Created by Wilson on 18/12/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import UIKit
import TaskemFoundation
import PainlessInjection

class RescheduleStandardRouter: RescheduleRouter {
    weak var controller: RescheduleViewController!
    
    private var modalTransitioningDelegate: ModalTransitioningDelegate?
    
    init(rescheduleController: RescheduleViewController) {
        self.controller = rescheduleController
    }
    
    func presentDatePickerPopup(initialData: DatePickerTemplatesPresenter.InitialData, completion: @escaping (DatePreferences?) -> Void) {
        let vc: DatePickerTemplatesViewController = Container.get(data: initialData, callback: completion)
        let navVC = ModalNavController(controller: vc)
        modalTransitioningDelegate = .init()
        navVC.transitioningDelegate = self.modalTransitioningDelegate
        controller.navigationController?.present(navVC, animated: true)
    }
}
