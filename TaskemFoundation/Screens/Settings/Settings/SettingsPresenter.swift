//
//  SettingsPresenter.swift
//  Taskem
//
//  Created by Wilson on 24/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class SettingsPresenter: SettingsViewDelegate {
    
    private weak var view: SettingsView?
    private var router: SettingsRouter
    private var interactor: SettingsInteractor

    private var wasFirstAppear = false
    
    private let factory: SettingsViewModelFactory
    private let userPreferences: UserPreferencesProtocol
    
    public init(
        view: SettingsView,
        router: SettingsRouter,
        interactor: SettingsInteractor
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        //
        self.userPreferences = UserPreferences.current
        self.factory = SettingsDefaultViewModelFactory()
        //
        self.interactor.delegate = self
        self.view?.delegate = self
    }
    
    private var viewModel: SettingsListViewModel {
        get { return view?.viewModel ?? .init() }
        set { view?.viewModel = newValue }
    }
    
    private func reloadAll() {
        let user = interactor.currentUser
        let defaultGroupName = interactor.defaultGroup?.name
        let viewModel = factory.produce(from: userPreferences, user: user, defaultGroupName: defaultGroupName)
        view?.display(viewModel)
    }
    
    public func onViewWillAppear() {
        if !wasFirstAppear {
            wasFirstAppear = true
            interactor.start()
        }
        reloadAll()
    }

    public func onChangeTime(at index: IndexPath, date: Date) {
        switch viewModel[index] {
        case .time(let model):
            let time = DayTime(date: date)
            
            switch model.item {
            case .morning:
                viewModel[index] = factory.produceMorningCell(time, extended: model.extended, userPref: userPreferences)
                userPreferences.morning = time
                
            case .noon:
                viewModel[index] = factory.produceNoonCell(time, extended: model.extended, userPref: userPreferences)
                userPreferences.noon = time
                
            case .evening:
                viewModel[index] = factory.produceEveningCell(time, extended: model.extended, userPref: userPreferences)
                userPreferences.evening = time
                
            default:
                break
            }
            
        default:
            break
        }
        
        for var model in viewModel.timeCells() {
            guard let index = viewModel.index(for: model.id) else { continue }
            
            switch model.item {
            case .morning:
                model.maxTime = userPreferences.noon
                break
                
            case .noon:
                model.minTime = userPreferences.morning
                model.maxTime = userPreferences.evening
                
            case .evening:
                model.minTime = userPreferences.noon
                
            default:
                break
            }
            viewModel[index] = .time(model)
            view?.reloadRows(at: [index], with: .none)
        }
    }
    
    public func onSelect(at index: IndexPath) {
        switch viewModel[index] {
        case .simple(let cell):
            switch cell.item {
            case .profile:
                if let user = interactor.currentUser, user.isAnonymous {
                    router.presentLogIn()
                } else {
                    router.presentUserProfile()
                }

            case .theme:
                switch userPreferences.theme {
                case .light:
                    userPreferences.theme = .dark
                    
                case .dark:
                    userPreferences.theme = .light
                }
                let themeCell = factory.produceThemeCell(userPreferences.theme)
                viewModel[index] = themeCell
                view?.reloadRows(at: [index], with: .automatic)
                
            case .reminderSound:
                router.presentNotificationSoundPicker()
            case .firstWeekday:
                switch userPreferences.firstWeekday {
                    
                case .sunday:
                    userPreferences.firstWeekday = .monday
                    
                case .monday:
                    userPreferences.firstWeekday = .sunday
                }
                let firstWeekdayCell = factory.produceFirstWeekdayCell(userPreferences.firstWeekday)
                viewModel[index] = firstWeekdayCell
                view?.reloadRows(at: [index], with: .automatic)

            case .deaultList:
                router.presentDefaultList()
            case .completed:
                router.presentCompletedTasks()
            case .reschedule:
                router.presentReschedule()

            case .share:
                break
            case .rateUs:
                break
            case .leaveFeedback:
                break
            case .help:
                break

            case .privacyPolicy:
                break
            case .termsOfUse:
                break
                
            case .morning:
                break
            case .noon:
                break
            case .evening:
                break
            }
            
        case .time(var time):
            for cell in viewModel.allCells {
                guard let index = viewModel.index(for: cell),
                    case .time(var model) = cell else { continue }
                model.extended = false
                viewModel[index] = .time(model)
                view?.reloadRows(at: [index], with: .none)
            }
            
            time.extended.toogle()
            viewModel[index] = .time(time)
            view?.reloadRows(at: [index], with: .automatic)
        }
    }
}

extension SettingsPresenter: SettingsInteractorOutput {
    public func settingsInteractorDidUpdateSettings() {
        if wasFirstAppear {
            reloadAll()
        }
    }
}
