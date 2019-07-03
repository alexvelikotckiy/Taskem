//
//  IOSDeviceOwnerAuthenticationType.swift
//  Taskem
//
//  Created by Wilson on 7/9/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import LocalAuthentication

internal class IOSDeviceOwnerAuthentication: DeviceOwnerAuthentication {
    var current: DeviceOwnerAuthenticationType {
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            if #available(iOS 11.0, *) {
                switch context.biometryType {
                case .faceID:
                    return .faceID
                case .touchID:
                    return .touchID
                case .none:
                    return .none
                @unknown default:
                    fatalError()
                }
            } else {
                return .none
            }
        } else if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            return .passcode
        } else {
            return .none
        }
    }

    func tryAuthenticate(reason: String, completion: @escaping (Error?) -> Void) {
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, reason: reason, completion: completion)
        } else if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            evaluatePolicy(.deviceOwnerAuthentication, reason: reason, completion: completion)
        }
    }

    private func evaluatePolicy(_ policy: LAPolicy, reason: String, completion: @escaping (Error?) -> Void) {
        context.evaluatePolicy(policy, localizedReason: reason, reply: { _, error in
            DispatchQueue.main.async {
                completion(error)
            }
        })
    }

    private let context = LAContext()
}
