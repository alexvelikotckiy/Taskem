//
//  DevDashboardPresenter.swift
//  Taskem
//
//  Created by Wilson on 12/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class DevDashboardPresenter: DevDashboardViewDelegate {

    weak var view: DevDashboardView?
    var router: DevDashboardRouter
    var interactor: DevDashboardInteractor

    public init(view: DevDashboardView, router: DevDashboardRouter, interactor: DevDashboardInteractor) {
        self.router = router
        self.interactor = interactor
        self.interactor.delegate = self

        self.view = view
        if let view = self.view {
            view.delegate = self
        }
    }

    func displayViewModel() {

    }

    public func onViewWillAppear() {
	
    }
    
    public func onTouchResetUserData() {
        interactor.resetData()
    }
    
    public func onTouchClearDefaults() {
        interactor.clearDefaults()
    }
    
    public func onTouchClearNotifications() {
        interactor.clearNotifications()
    }

}

extension DevDashboardPresenter: DevDashboardInteractorOutput {

}
