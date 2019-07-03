//
//  UserProfileRouter.swift
//  Taskem
//
//  Created by Wilson on 7/25/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection
import TaskemFoundation

class UserProfileStandardRouter: UserProfileRouter {
    weak var controller: UserProfileViewController!
    
    init(userprofileController: UserProfileViewController) {
        self.controller = userprofileController
    }
    
    func alert(title: String, message: String) {
        let confirmTitle = "OK"
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in  }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(confirmAction)
        controller.present(alert, animated: true, completion: nil)
    }
    
    func alertDestructive(title: String, message: String, _ completion: @escaping (Bool) -> Void) {
        let cancelTitle = "Cancel"
        let confirmTitle = "Confirm"
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in completion(false) }
        let confirmAction = UIAlertAction(title: confirmTitle, style: .destructive) { _ in completion(true) }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        controller.present(alert, animated: true, completion: nil)
    }
    
    func alertDefault(title: String, message: String, _ completion: @escaping (Bool) -> Void) {
        let cancelTitle = "Cancel"
        let confirmTitle = "Continue"
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in completion(false) }
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in completion(true) }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        controller.present(alert, animated: true, completion: nil)
    }
}
