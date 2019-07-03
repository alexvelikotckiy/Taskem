//
//  CalendarRouter.swift
//  Taskem
//
//  Created by Wilson on 4/10/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection
import TaskemFoundation
import EventKit

class CalendarStandardRouter: CalendarRouter {
    weak var controller: CalendarViewController!
    
    private var modalTransitioningDelegate: ModalTransitioningDelegate?
    private var expandTransitioningDelegate: ExpandTransitioningDelegate?

    init(calendarController: CalendarViewController) {
        self.controller = calendarController
    }

    func presentTaskPopup(data: TaskPopupPresenter.InitialData) {
        let vc: TaskPopupViewController = Container.get(data: data)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        controller.navigationController?.tabBarController?.present(vc, animated: true, completion: nil)
    }
    
    func presentTask(data: TaskOverviewPresenter.InitialData, frame: CGRect) {
        let vc: TaskOverviewViewController = Container.get(data: data)
        let navVc = ExpandNavController(rootViewController: vc)
        
        expandTransitioningDelegate = .init(viewController: controller, presentingViewController: navVc, collapsedFrame: frame)
        navVc.modalPresentationStyle = .custom
        navVc.transitioningDelegate = expandTransitioningDelegate
        
        // http://openradar.appspot.com/19563577
        DispatchQueue.main.async {
            self.controller.present(navVc, animated: true)
        }
    }
    
    func presentEvent(data: EventOverviewPresenter.InitialData, frame: CGRect) {
        let vc: EventOverviewViewController = Container.get(data: data)
        vc.delegate = controller
        let navVc = ExpandNavController(rootViewController: vc)

        expandTransitioningDelegate = .init(viewController: controller, presentingViewController: navVc, collapsedFrame: frame)
        navVc.modalPresentationStyle = .custom
        navVc.transitioningDelegate = expandTransitioningDelegate
        
        // http://openradar.appspot.com/19563577
        DispatchQueue.main.async {
            self.controller.present(navVc, animated: true)
        }
    }

    func presentDatePicker(data: DatePickerTemplatesPresenter.InitialData, completion: @escaping DatePickerCallback) {
        let vc: DatePickerTemplatesViewController = Container.get(data: data, callback: completion)
        let navVC = ModalNavController(controller: vc)
        modalTransitioningDelegate = .init()
        navVC.transitioningDelegate = self.modalTransitioningDelegate
        controller.navigationController?.present(navVC, animated: true, completion: nil)
    }
    
    func postAlert(title: String, message: String?) {
        let confirmTitle = "OK"
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(confirmAction)
        controller.present(alert, animated: true, completion: nil)
    }
}
