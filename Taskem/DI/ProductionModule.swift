//
//  ProductionModule.swift
//  Taskem
//
//  Created by Wilson on 07.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import PainlessInjection
import TaskemFoundation
import TaskemFirebase
import GoogleSignIn

class ProductionModule: Module {
    override func load() {
        defineServices()
        defineViewControllers()
    }

    private func defineServices() {
        define(UserService.self) {
            let service = FirebaseUserServise()
            service.start()
            return service
            }.inSingletonScope()
        define(GroupSource.self) {
            let service = FirebaseGroupSource(sourceUser: self.resolve())
            service.start()
            return service
            }.inSingletonScope()
        define(TaskSource.self) {
            let service = FirebaseTaskSource(sourceUser: self.resolve(), sourceGroups: self.resolve())
            let reminderReschedule: TaskReminderRescheduleObserver = self.resolve()
            service.addObserver(reminderReschedule)
            service.start()
            return service
            }.inSingletonScope()
        
        FirebaseEnvironment.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseEnvironment.app()?.options.clientID
    }
    
    private func defineViewControllers() {
        define(TapBarViewController.self) {
            TapBarViewController(viewModel: TabbarViewModel(userService: self.resolve()))
        }
    }
    
    override func loadingPredicate() -> ModuleLoadingPredicate {
        return AppEnvironmentPredicate(environment: .prod)
    }
}
