//
//  EventOverviewPresenter.swift
//  Taskem
//
//  Created by Wilson on 18/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import EventKit

public class EventOverviewPresenter: EventOverviewViewDelegate, DataInitiable {
    
    public weak var view: EventOverviewView?
    public var router: EventOverviewRouter
    public var interactor: EventOverviewInteractor

    public var initialData: EKEvent
    
    public init(
        view: EventOverviewView,
        router: EventOverviewRouter,
        interactor: EventOverviewInteractor,
        data: InitialData
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        //
        self.initialData = data
        //
        self.interactor.delegate = self
        self.view?.viewDelegate = self
    }

    public typealias InitialData = EKEvent
    
    public func onViewWillAppear() {
	
    }
}

extension EventOverviewPresenter: EventOverviewInteractorOutput {

}
