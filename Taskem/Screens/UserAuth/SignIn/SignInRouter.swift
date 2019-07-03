//
//  SignInRouter.swift
//  Taskem
//
//  Created by Wilson on 14/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection
import TaskemFoundation

class SignInStandardRouter: SignInRouter {
    weak var controller: SignInViewController!

    init(signinController: SignInViewController) {
        self.controller = signinController
    }

    func dismiss() {
        controller.dismiss(animated: true, completion: nil)
    }

    func presentAlert(title: String, message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        self.controller.present(alert, animated: true, completion: nil)
    }

    func presentPasswordReset(email: String) {
        let vc: PasswordResetViewController = Container.get(email: email)
        controller.navigationController?.pushViewController(vc, animated: true)
    }

    func presentTemplatesSetup() {
        let vc: UserTemplatesSetupViewController = Container.get()
        controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    func replaceWithSignUp() {
        guard let navigationController = controller.navigationController,
            let currentControllerIndex = navigationController.viewControllers.firstIndex(of: controller) else { return }
        
        let vc: SignUpViewController = Container.get()
        
        var controllers = navigationController.viewControllers
        controllers[currentControllerIndex] = vc
        
        navigationController.setViewControllers(controllers, animated: true)
    }
}
