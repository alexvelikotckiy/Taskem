//
//  GroupOverviewRouter.swift
//  Taskem
//
//  Created by Wilson on 21/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol GroupOverviewRouter {
    func dismiss()
    func alertDelete(title: String, message: String, _ completion: @escaping ((Bool) -> Void))
    func presentColorPicker(_ data: GroupColorPickerPresenter.InitialData, _ callback: @escaping GroupColorPickerCallback)
    func presentIconPicker(_ data: GroupIconPickerPresenter.InitialData, _ callback: @escaping GroupIconPickerCallback)
}
