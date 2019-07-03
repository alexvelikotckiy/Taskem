//
//  DeviceOwnerAuthentication.swift
//  TaskemFoundation
//
//  Created by Wilson on 7/9/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public enum DeviceOwnerAuthenticationType {
    case faceID
    case touchID
    case passcode
    case none
}

public protocol DeviceOwnerAuthentication {
    var current: DeviceOwnerAuthenticationType { get }
    func tryAuthenticate(reason: String, completion: @escaping (Error?) -> Void)
}
