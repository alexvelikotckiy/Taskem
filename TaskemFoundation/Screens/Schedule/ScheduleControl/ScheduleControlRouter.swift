//
//  GroupControlRouter.swift
//  Taskem
//
//  Created by Wilson on 03/01/2018.
//  Copyright © 2018 WIlson. All rights reserved.
//

import Foundation

public protocol ScheduleControlRouter {
    func dismiss()
    func presentGroupOverview(_ data: GroupOverviewPresenter.InitialData)
    func alertDelete(title: String, message: String, _ completion: @escaping ((Bool) -> Void))
}
