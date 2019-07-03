//
//  GroupPopupRouter.swift
//  Taskem
//
//  Created by Wilson on 24/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

public protocol GroupPopupRouter {
    func dismiss()
    func presentNewGroup(_ data: GroupOverviewPresenter.InitialData)
}
