//
//  UserProfileRouter.swift
//  Taskem
//
//  Created by Wilson on 25/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol UserProfileRouter {
    func alert(title: String, message: String)
    func alertDestructive(title: String, message: String, _ completion: @escaping (Bool) -> Void)
    func alertDefault(title: String, message: String, _ completion: @escaping (Bool) -> Void)
}
