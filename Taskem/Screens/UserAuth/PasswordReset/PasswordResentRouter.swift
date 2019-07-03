//
//  PasswordResentRouter.swift
//  Taskem
//
//  Created by Wilson on 6/30/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection
import TaskemFoundation

class PasswordResetStandardRouter: PasswordResetRouter {
    weak var controller: PasswordResetViewController!

    init(passwordresetController: PasswordResetViewController) {
        self.controller = passwordresetController
    }

    func presentAlert(title: String, message: String?, _ completion: @escaping () -> Void) {
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in completion() }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        controller.present(alert, animated: true, completion: nil)
    }

    func dismiss() {
        controller.navigationController?.popViewController(animated: true)
    }
    
    func replaceWithSignUp() {
        guard let navigationController = controller.navigationController,
            let currentControllerIndex = navigationController.viewControllers.firstIndex(of: controller) else { return }
        
        let vc: SignUpViewController = Container.get()

        var controllers = navigationController.viewControllers
        controllers[currentControllerIndex] = vc
        
        if let signInIndex = controllers.firstIndex(where: { $0 is SignInViewController }) {
            controllers.remove(at: signInIndex)
        }

        navigationController.setViewControllers(controllers, animated: true)
    }
}
