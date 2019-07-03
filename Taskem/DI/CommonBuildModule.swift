//
//  CommonBuildModule.swift
//  Taskem
//
//  Created by Wilson on 07.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import PainlessInjection
import TaskemFoundation
import TaskemFirebase
import GoogleSignIn

class CommonBuildModule: Module {

    override func load() {
        defineServices()
        defineViewControllers()
    }

    private func defineServices() {
        define(EventKitManager.self) { IOSEventKitService() }
        define(RemindScheduleManager.self) { IOSReminderScheduler(appBadge: self.resolve()) }
        define(SharingService.self) { IOSSharingService() }
        define(ApplicationConfiguration.self) { SystemAppConfiguration() }
        define(ReminderSoundSource.self) { SystemReminderSoundSource() }
        define(MediaPlayer.self) { AVMediaPlayer() }
        define(TaskReminderRescheduleObserver.self) { return SystemTaskReminderRescheduleObserver(scheduler: self.resolve()) }.inSingletonScope()
        define(ApplicationBadge.self) { IOSApplicationBadge() }
        define(TemplatesSource.self) { return SystemTemplateSource() }
        define(OnboardingSettings.self) { return SystemOnboardingSettings() }
        define(UserPreferencesProtocol.self) { return SystemUserPreferences() }
        define(NotificationHandlerDataUpdater.self) { return FirebaseNotificationHandler() }.inSingletonScope()
        define(NotificationHandler.self) {
            let dataHandler: NotificationHandlerDataUpdater = self.resolve()
            return IOSNotificationHandler(dataHandler: dataHandler) }.inSingletonScope()
        define(ThemeManager.self) { return IOSThemeManager() }.inSingletonScope()
    }

    private func defineViewControllers() {

        define(ScheduleViewController.self) { (_: ArgumentList) -> ScheduleViewController? in
            let storyboard = UIStoryboard(name: "ScheduleViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "ScheduleViewControllerID")
                as? ScheduleViewController {

                let router: ScheduleRouter = ScheduleStandardRouter(scheduleController: viewController)
                let interactor = ScheduleDefaultInteractor(sourceTasks: self.resolve(), sourceGroups: self.resolve(), shareService: self.resolve())
                viewController.presenter = SchedulePresenter(view: viewController, router: router, interactor: interactor)
                return viewController
            }
            print("Error create ScheduleViewController")
            return nil
        }

        define(ScheduleControlViewController.self) { (args: ArgumentList) -> ScheduleControlViewController? in
            let storyboard = UIStoryboard(name: "ScheduleControlViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "ScheduleControlViewControllerID")
                as? ScheduleControlViewController {

                let router: ScheduleControlRouter = ScheduleControlStandardRouter(groupcontrolController: viewController)
                let interactor = ScheduleControlDefaultInteractor(sourceTasks: self.resolve(), sourceGroups: self.resolve())
                viewController.presenter = ScheduleControlPresenter(view: viewController, router: router, interactor: interactor)
                return viewController
            }
            print("Error create ScheduleControlViewController")
            return nil
        }

        define(RescheduleViewController.self) { (_: ArgumentList) -> RescheduleViewController? in

            let storyboard = UIStoryboard(name: "RescheduleViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "RescheduleViewControllerID")
                as? RescheduleViewController {

                let router: RescheduleRouter = RescheduleStandardRouter(rescheduleController: viewController)
                let interactor = RescheduleDefaultInteractor(sourceTasks: self.resolve(), sourceGroups: self.resolve())
                viewController.presenter = ReschedulePresenter(view: viewController, router: router, interactor: interactor)
                return viewController
            }
            print("Error create RescheduleViewController")
            return nil
        }

        define(TaskPopupViewController.self) { (args: ArgumentList) -> TaskPopupViewController? in

            let storyboard = UIStoryboard(name: "TaskPopupViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "TaskPopupViewControllerID")
                as? TaskPopupViewController {

                let router: TaskPopupRouter = TaskPopupStandardRouter(taskpopupController: viewController)
                let interactor = TaskPopupDefaultInteractor(sourceTasks: self.resolve(), sourceGroups: self.resolve())
                viewController.presenter = TaskPopupPresenter(view: viewController, router: router, interactor: interactor, data: args.at(0))
                return viewController
            }
            print("Error create TaskPopupViewController")
            return nil
        }

        define(TaskNotesViewController.self) { (args: ArgumentList) -> TaskNotesViewController? in

            let storyboard = UIStoryboard(name: "TaskNotesViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "TaskNotesViewControllerID")
                as? TaskNotesViewController {

                let router: TaskNotesRouter = TaskNotesStandardRouter(tasknotesController: viewController)
                let interactor = TaskNotesDefaultInteractor()
                viewController.presenter = TaskNotesPresenter(view: viewController, router: router, interactor: interactor, data: args.at(0), callback: args.at(1))
                return viewController
            }
            print("Error create TaskNotesViewController")
            return nil
        }

        define(GroupPopupViewController.self) { (args: ArgumentList) -> GroupPopupViewController? in

            let storyboard = UIStoryboard(name: "GroupPopupViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "GroupPopupViewControllerID")
                as? GroupPopupViewController {

                let router: GroupPopupRouter = GroupPopupStandardRouter(grouppopupController: viewController)
                let interactor = GroupPopupDefaultInteractor(sourceGroups: self.resolve())
                viewController.presenter = GroupPopupPresenter(view: viewController, router: router, interactor: interactor, data: args.at(0), completion: args.at(1))
                return viewController
            }
            print("Error create GroupPopupViewController")
            return nil
        }

        define(CompletedViewController.self) { (_: ArgumentList) -> CompletedViewController? in

            let storyboard = UIStoryboard(name: "CompletedViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "CompletedViewControllerID")
                as? CompletedViewController {

                let router: CompletedRouter = CompletedStandardRouter(completedController: viewController)
                let interactor = CompletedDefaultInteractor(sourceTasks: self.resolve(), sourceGroups: self.resolve())
                viewController.presenter = CompletedPresenter(view: viewController, router: router, interactor: interactor)
                return viewController
            }
            print("Error create CompletedViewController")
            return nil
        }

        define(TaskOverviewViewController.self) { (args: ArgumentList) -> TaskOverviewViewController? in

            let storyboard = UIStoryboard(name: "TaskOverviewViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "TaskOverviewViewControllerID")
                as? TaskOverviewViewController {

                let router: TaskOverviewRouter = TaskOverviewStandardRouter(taskoverviewController: viewController)
                let interactor = TaskOverviewDefaultInteractor(sourceTasks: self.resolve(), sourceGroups: self.resolve(), shareService: self.resolve())
                viewController.presenter = TaskOverviewPresenter(view: viewController, router: router, interactor: interactor, data: args.at(0))
                return viewController
            }
            print("Error create TaskOverviewViewController")
            return nil
        }

        define(RepeatTemplatesViewController.self) { (args: ArgumentList) -> RepeatTemplatesViewController? in

            let storyboard = UIStoryboard(name: "RepeatTemplatesViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "RepeatTemplatesViewControllerID")
                as? RepeatTemplatesViewController {

                let router: RepeatTemplatesRouter = RepeatTemplatesStandardRouter(repeattemplatesController: viewController)
                let interactor = RepeatTemplatesDefaultInteractor()
                viewController.presenter = RepeatTemplatesPresenter(view: viewController, router: router, interactor: interactor, data: args.at(0), callback: args.at(1))
                return viewController
            }
            print("Error create TaskRepeatTemplateSetupViewController")
            return nil
        }

        define(RepeatManualViewController.self) { (args: ArgumentList) -> RepeatManualViewController? in

            let storyboard = UIStoryboard(name: "RepeatManualViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "RepeatManualViewControllerID")
                as? RepeatManualViewController {

                let router: RepeatManualRouter = RepeatManualStandardRouter(repeatmanualController: viewController)
                let interactor = RepeatManualDefaultInteractor()
                viewController.presenter = RepeatManualPresenter(view: viewController, router: router, interactor: interactor, data: args.at(0), callback: args.at(1))
                return viewController
            }
            print("Error create TaskRepeatSetupViewController")
            return nil
        }

        define(ReminderTemplatesViewController.self) { (args: ArgumentList) -> ReminderTemplatesViewController? in

            let storyboard = UIStoryboard(name: "ReminderTemplatesViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "ReminderTemplatesViewControllerID")
                as? ReminderTemplatesViewController {

                let router: ReminderTemplatesRouter = ReminderTemplatesStandardRouter(remindertemplatesController: viewController)
                let interactor = ReminderTemplatesDefaultInteractor(remindScheduler: self.resolve())
                viewController.presenter = ReminderTemplatesPresenter(view: viewController, router: router, interactor: interactor, data: args.at(0), callback: args.at(1))
                return viewController
            }
            print("Error create TaskReminderTemplateSetupViewController")
            return nil
        }

        define(ReminderManualViewController.self) { (args: ArgumentList) -> ReminderManualViewController? in

            let storyboard = UIStoryboard(name: "ReminderManualViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "ReminderManualViewControllerID")
                as? ReminderManualViewController {

                let router: ReminderManualRouter = ReminderManualStandardRouter(remindermanualController: viewController)
                let interactor = ReminderManualDefaultInteractor(remindScheduler: self.resolve())
                viewController.presenter = ReminderManualPresenter(view: viewController, router: router, interactor: interactor, data: args.at(0), callback: args.at(1))
                return viewController
            }
            print("Error create ReminderManualViewController")
            return nil
        }

        define(DatePickerTemplatesViewController.self) { (args: ArgumentList) -> DatePickerTemplatesViewController? in

            let storyboard = UIStoryboard(name: "DatePickerTemplatesViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "DatePickerTemplatesViewControllerID")
                as? DatePickerTemplatesViewController {

                let router: DatePickerTemplatesRouter = DatePickerTemplatesStandardRouter(datepickertemplatesController: viewController)
                let interactor = DatePickerTemplatesDefaultInteractor()
                viewController.presenter = DatePickerTemplatesPresenter(view: viewController, router: router, interactor: interactor, data: args.at(0), callback: args.at(1))
                return viewController
            }
            print("Error create DatePickerTemplatesViewController")
            return nil
        }

        define(DatePickerManualViewController.self) { (args: ArgumentList) -> DatePickerManualViewController? in

            let storyboard = UIStoryboard(name: "DatePickerManualViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "DatePickerManualViewControllerID")
                as? DatePickerManualViewController {

                let router: DatePickerManualRouter = DatePickerManualStandardRouter(datepickermanualController: viewController)
                let interactor = DatePickerManualDefaultInteractor()
                viewController.presenter = DatePickerManualPresenter(view: viewController, router: router, interactor: interactor, data: args.at(0), callback: args.at(1))
                return viewController
            }
            print("Error create DatePickerManualViewController")
            return nil
        }

        define(GroupOverviewViewController.self) { (args: ArgumentList) -> GroupOverviewViewController? in

            let storyboard = UIStoryboard(name: "GroupOverviewViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "GroupOverviewViewControllerID")
                as? GroupOverviewViewController {

                let router: GroupOverviewRouter = GroupOverviewStandardRouter(groupoverviewController: viewController)
                let interactor = GroupOverviewDefaultInteractor(sourceGroups: self.resolve())
                viewController.presenter = GroupOverviewPresenter(view: viewController, router: router, interactor: interactor, data: args.at(0))
                return viewController
            }
            print("Error create GroupOverviewViewController")
            return nil
        }

        define(GroupColorPickerViewController.self) { (args: ArgumentList) -> GroupColorPickerViewController? in

            let storyboard = UIStoryboard(name: "GroupColorPickerViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "GroupColorPickerViewControllerID")
                as? GroupColorPickerViewController {

                let router: GroupColorPickerRouter = GroupColorPickerStandardRouter(groupcolorpickerController: viewController)
                let interactor = GroupColorPickerDefaultInteractor()
                viewController.presenter = GroupColorPickerPresenter(view: viewController, router: router, interactor: interactor, data: args.at(0), callback: args.at(1))
                return viewController
            }
            print("Error create GroupColorPickerViewController")
            return nil
        }

        define(GroupIconPickerViewController.self) { (args: ArgumentList) -> GroupIconPickerViewController? in

            let storyboard = UIStoryboard(name: "GroupIconPickerViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "GroupIconPickerViewControllerID")
                as? GroupIconPickerViewController {

                let router: GroupIconPickerRouter = GroupIconPickerStandardRouter(groupiconpickerController: viewController)
                let interactor = GroupIconPickerDefaultInteractor()
                viewController.presenter = GroupIconPickerPresenter(view: viewController, router: router, interactor: interactor, data: args.at(0), callback: args.at(1))
                return viewController
            }
            print("Error create GroupIconPickerViewController")
            return nil
        }

        define(SettingsViewController.self) { (args: ArgumentList) -> SettingsViewController? in
            
            let storyboard = UIStoryboard(name: "SettingsViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewControllerID")
                as? SettingsViewController {
                
                let router: SettingsRouter = SettingsStandardRouter(settingsController: viewController)
                let interactor = SettingsDefaultInteractor(userService: self.resolve(), groupSource: self.resolve())
                viewController.presenter = SettingsPresenter(view: viewController, router: router, interactor: interactor)
                return viewController
            }
            print("Error create SettingsViewController")
            return nil
        }

        define(NotificationSoundPickerViewController.self) { (args: ArgumentList) -> NotificationSoundPickerViewController? in
            
            let storyboard = UIStoryboard(name: "NotificationSoundPickerViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "NotificationSoundPickerViewControllerID")
                as? NotificationSoundPickerViewController {
                
                let router: NotificationSoundPickerRouter = NotificationSoundPickerStandardRouter(notificationsoundpickerController: viewController)
                let interactor = NotificationSoundPickerDefaultInteractor(soundSource: self.resolve(), mediaPlayer: self.resolve(), remindScheduler: self.resolve())
                viewController.presenter = NotificationSoundPickerPresenter(view: viewController, router: router, interactor: interactor, userPreference: self.resolve())
                return viewController
            }
            print("Error create NotificationSoundPickerViewController")
            return nil
        }

        define(CalendarControlViewController.self) { (args: ArgumentList) -> CalendarControlViewController? in

            let storyboard = UIStoryboard(name: "CalendarControlViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "CalendarControlViewControllerID")
                as? CalendarControlViewController {

                let router: CalendarControlRouter = CalendarControlStandardRouter(calendarcontrolController: viewController)
                let interactor = CalendarControlDefaultInteractor(sourceGroups: self.resolve(), sourceEventkit: self.resolve())
                viewController.presenter = CalendarControlPresenter(view: viewController, router: router, interactor: interactor)
                return viewController
            }
            print("Error create CalendarControlViewController")
            return nil
        }

        define(CalendarViewController.self) { (args: ArgumentList) -> CalendarViewController? in

            let storyboard = UIStoryboard(name: "CalendarViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "CalendarViewControllerID")
                as? CalendarViewController {

                let router: CalendarRouter = CalendarStandardRouter(calendarController: viewController)
                let interactor = CalendarDefaultInteractor(sourceTasks: self.resolve(), sourceGroups: self.resolve(), sourceEventkit: self.resolve())
                let pageDelegate: CalendarPageDelegate = args.at(0)
                viewController.presenter = CalendarPresenter(view: viewController, router: router, interactor: interactor, pageDelegate: pageDelegate)
                return viewController
            }
            print("Error create CalendarViewController")
            return nil
        }

        define(LogInViewController.self) { (_: ArgumentList) -> LogInViewController? in

            let storyboard = UIStoryboard(name: "LogInViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "LogInViewControllerID")
                as? LogInViewController {

                let router: LogInRouter = LogInStandardRouter(loginController: viewController)
                let interactor = LogInDefaultInteractor(userService: self.resolve(), googleSignIn: GIDSignIn.sharedInstance())
                viewController.presenter = LogInPresenter(view: viewController, router: router, interactor: interactor)
                return viewController
            }
            print("Error create LogInViewController")
            return nil
        }

        define(SignInViewController.self) { (_: ArgumentList) -> SignInViewController? in

            let storyboard = UIStoryboard(name: "SignInViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "SignInViewControllerID")
                as? SignInViewController {

                let router: SignInRouter = SignInStandardRouter(signinController: viewController)
                let interactor = SignInDefaultInteractor(userService: self.resolve())
                viewController.presenter = SignInPresenter(view: viewController, router: router, interactor: interactor)
                return viewController
            }
            print("Error create SignInViewController")
            return nil
        }

        define(SignUpViewController.self) { (_: ArgumentList) -> SignUpViewController? in

            let storyboard = UIStoryboard(name: "SignUpViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewControllerID")
                as? SignUpViewController {

                let router: SignUpRouter = SignUpStandardRouter(signupController: viewController)
                let interactor = SignUpDefaultInteractor(userService: self.resolve())
                viewController.presenter = SignUpPresenter(view: viewController, router: router, interactor: interactor)
                return viewController
            }
            print("Error create SignUpViewController")
            return nil
        }

        define(UserTemplatesSetupViewController.self) { (_: ArgumentList) -> UserTemplatesSetupViewController? in

            let storyboard = UIStoryboard(name: "UserTemplatesSetupViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "UserTemplatesSetupViewControllerID")
                as? UserTemplatesSetupViewController {

                let router: UserTemplatesSetupRouter = UserTemplatesSetupStandardRouter(usertemplatessetupController: viewController)
                let interactor = UserTemplatesSetupStandardInteractor(templatesSource: self.resolve(), tasksSource: self.resolve(), groupSource: self.resolve())
                viewController.presenter = UserTemplatesSetupPresenter(view: viewController, router: router, interactor: interactor, onboardingSettings: self.resolve())
                return viewController
            }
            print("Error create UserTemplatesSetupViewController")
            return nil
        }

        define(PasswordResetViewController.self) { (args: ArgumentList) -> PasswordResetViewController? in

            let storyboard = UIStoryboard(name: "PasswordResetViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "PasswordResetViewControllerID")
                as? PasswordResetViewController {

                let router: PasswordResetRouter = PasswordResetStandardRouter(passwordresetController: viewController)
                let interactor = PasswordResetDefaultInteractor(userService: self.resolve())
                viewController.presenter = PasswordResetPresenter(view: viewController, router: router, interactor: interactor, email: args.at(0))
                return viewController
            }
            print("Error create PasswordResetViewController")
            return nil
        }
        
        define(EventOverviewViewController.self) { (args: ArgumentList) -> EventOverviewViewController? in
            
            let storyboard = UIStoryboard(name: "EventOverviewViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "EventOverviewViewControllerID")
                as? EventOverviewViewController {
                
                let router: EventOverviewRouter = EventOverviewStandardRouter(eventoverviewController: viewController)
                let interactor = EventOverviewInteractor()
                viewController.presenter = EventOverviewPresenter(view: viewController, router: router, interactor: interactor, data: args.at(0))
                viewController.event = args.at(0)
                return viewController
            }
            print("Error create EventOverviewViewController")
            return nil
        }
        
        define(UserProfileViewController.self) { (args: ArgumentList) -> UserProfileViewController? in
            
            let storyboard = UIStoryboard(name: "UserProfileViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "UserProfileViewControllerID")
                as? UserProfileViewController {
                
                let router: UserProfileRouter = UserProfileStandardRouter(userprofileController: viewController)
                let interactor = UserProfileDefaultInteractor(userService: self.resolve())
                viewController.presenter = UserProfilePresenter(view: viewController, router: router, interactor: interactor)
                return viewController
            }
            print("Error create UserProfileViewController")
            return nil
        }
        
        define(DefaultGroupPickerViewController.self) { (args: ArgumentList) -> DefaultGroupPickerViewController? in
            
            let storyboard = UIStoryboard(name: "DefaultGroupPickerViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "DefaultGroupPickerViewControllerID")
                as? DefaultGroupPickerViewController {
                
                let router: DefaultGroupPickerRouter = DefaultGroupPickerStandardRouter(defaultgrouppickerController: viewController)
                let interactor = DefaultGroupPickerDefaultInteractor(sourceGroups: self.resolve())
                viewController.presenter = DefaultGroupPickerPresenter(view: viewController, router: router, interactor: interactor)
                return viewController
            }
            print("Error create DefaultGroupPickerViewController")
            return nil
        }
        
        define(CalendarPageViewController.self) { (args: ArgumentList) -> CalendarPageViewController? in
            
            let storyboard = UIStoryboard(name: "CalendarPageViewController", bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: "CalendarPageViewControllerID")
                as? CalendarPageViewController {
                
                let router: CalendarPageRouter = CalendarPageStandardRouter(calendarpageController: viewController)
                let interactor = CalendarPageDefaultInteractor(sourceTasks: self.resolve(), sourceGroups: self.resolve(), sourceEventkit: self.resolve())
                viewController.presenter = CalendarPagePresenter(view: viewController, router: router, interactor: interactor)
                return viewController
            }
            print("Error create CalendarPageViewController")
            return nil
        }
    }

}
