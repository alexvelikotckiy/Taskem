//
//  LogInRouter.swift
//  Taskem
//
//  Created by Wilson on 09/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection
import TaskemFoundation

class LogInStandardRouter: LogInRouter {
    weak var controller: LogInViewController!

    init(loginController: LogInViewController) {
        self.controller = loginController
    }

    func presentEmailSignUp() {
        let vc: SignUpViewController = Container.get()
        controller.navigationController?.pushViewController(vc, animated: true)
    }

    func presentSignIn() {
        let vc: SignInViewController = Container.get()
        controller.navigationController?.pushViewController(vc, animated: true)
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

    func presentTemplatesSetup() {
        let vc: UserTemplatesSetupViewController = Container.get()
        controller.navigationController?.pushViewController(vc, animated: true)
    }
}
