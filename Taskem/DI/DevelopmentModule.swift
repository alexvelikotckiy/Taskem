//
//  DevelopmentModule.swift
//  Taskem
//
//  Created by Wilson on 07.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import PainlessInjection
import TaskemFoundation
import UserNotifications
import TaskemFirebase
import GoogleSignIn

class DevelopmentModule: Module {
    override func load() {
        defineServices()
        defineViewControllers()
    }

    private func defineServices() {
        define(DevDataSource.self) {
            return SystemDevDataSource()
            }.inSingletonScope()
        
//        define(UserService.self) {
//            let service = DevUserService()
//            service.start()
//            return service
//            }.inSingletonScope()
        
        define(GroupSource.self) {
            let service = DevGroupSource()
            service.start()
            return service
            }.inSingletonScope()
        define(TaskSource.self) {
            let service = DevTasksSource(groupSource: self.resolve())
            let reminderReschedule: TaskReminderRescheduleObserver = self.resolve()
            service.addObserver(reminderReschedule)
            service.start()
            return service
            }.inSingletonScope()
        
        define(UserService.self) {
            let service = FirebaseUserServise()
            service.start()
            return service
            }.inSingletonScope()
//        define(GroupSource.self) {
//            let service = FirebaseGroupSource(sourceUser: self.resolve())
//            service.start()
//            return service
//            }.inSingletonScope()
//        define(TaskSource.self) {
//            let service = FirebaseTaskSource(sourceUser: self.resolve(), sourceGroups: self.resolve())
//            let reminderReschedule: TaskReminderRescheduleObserver = self.resolve()
//            service.addObserver(reminderReschedule)
//            service.start()
//            return service
//            }.inSingletonScope()
        
        FirebaseEnvironment.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseEnvironment.app()?.options.clientID
    }
    
    private func defineViewControllers() {
        define(TapBarViewController.self) {
            DevApplicationTabBarController(viewModel: TabbarViewModel(userService: self.resolve()))
        }
        
        define(DevDashboardViewController.self) { (args: ArgumentList) -> DevDashboardViewController? in
            
            let storyboard = UIStoryboard(name: "DevDashboardViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "DevDashboardViewControllerID")
                as? DevDashboardViewController {
                
                let router: DevDashboardRouter = DevDashboardStandardRouter(devdashboardController: viewController)
                let interactor = DevDashboardInteractor(groupSource: self.resolve(), taskSource: self.resolve(), devSource: self.resolve())
                viewController.presenter = DevDashboardPresenter(view: viewController, router: router, interactor: interactor)
                return viewController
            }
            print("Error create DevDashboardViewController")
            return nil
        }
    }
    
    override func loadingPredicate() -> ModuleLoadingPredicate {
        return AppEnvironmentPredicate(environment: .dev)
    }
}
