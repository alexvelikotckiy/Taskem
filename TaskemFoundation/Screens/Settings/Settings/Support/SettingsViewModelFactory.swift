//
//  SettingsViewModelFactory.swift
//  TaskemFoundation
//
//  Created by Wilson on 7/25/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol SettingsViewModelFactory {
    func produce(from userPreferences: UserPreferencesProtocol, user: User?, defaultGroupName: String?) -> SettingsListViewModel
    func produce(from sections: [SettingsSectionViewModel]) -> SettingsListViewModel
}

private let images = Images.Foundation.self

public extension SettingsViewModelFactory {
    func produceProfileCell(_ user: User?) -> SettingsViewModel {
        return .simple(
            .init(
                item: .profile,
                title: "PROFILE",
                accessory: .present,
                description: user?.name ?? "",
                icon: .init(images.icSettingsProfile)
            )
        )
    }
    
    func produceThemeCell(_ theme: AppTheme) -> SettingsViewModel {
        return .simple(
            .init(
                item: .theme,
                title: "APP THEME",
                accessory: .none,
                description: theme.description,
                icon: .init(images.icSettingsApptheme)
            )
        )
    }

    func produceReminderSoundCell(_ sound: String) -> SettingsViewModel {
        return .simple(
            .init(
                item: .reminderSound,
                title: "REMINDER SOUND",
                accessory: .present,
                description: sound,
                icon: .init(images.icSettingsRemindsound)
            )
        )
    }
    
    func produceFirstWeekdayCell(_ day: FirstWeekday) -> SettingsViewModel {
        return .simple(
            .init(
                item: .firstWeekday,
                title: "FIRST WEEKDAY",
                accessory: .none,
                description: day.description,
                icon: .init(images.icSettingsFirstweekday)
            )
        )
    }


    func produceMorningCell(_ dayTime: DayTime, extended: Bool, userPref: UserPreferencesProtocol) -> SettingsViewModel {
        return .time(
            .init(
                item: .morning,
                time: dayTime,
                min: .init(hour: 0, minute: 0),
                max: userPref.noon,
                title: "MORNING",
                description: dayTime.description,
                extended: extended, icon: .init(images.icSettingsMorning)
            )
        )
    }
    
    func produceNoonCell(_ dayTime: DayTime, extended: Bool, userPref: UserPreferencesProtocol) -> SettingsViewModel {
        return .time(
            .init(
                item: .noon,
                time: dayTime,
                min: userPref.morning,
                max: userPref.evening,
                title: "NOON",
                description: dayTime.description,
                extended: extended, icon: .init(images.icSettingsNoon)
            )
        )
    }

    func produceEveningCell(_ dayTime: DayTime, extended: Bool, userPref: UserPreferencesProtocol) -> SettingsViewModel {
        return .time(
            .init(
                item: .evening,
                time: dayTime,
                min: userPref.noon,
                max: .init(hour: 23, minute: 59),
                title: "EVENING",
                description: dayTime.description,
                extended: extended, icon: .init(images.icSettingsEvening)
            )
        )
    }


    func produceDefaultListCell(_ name: String?) -> SettingsViewModel {
        return .simple(
            .init(
                item: .deaultList,
                title: "DEFAULT LIST",
                accessory: .present,
                description: name ?? "",
                icon: .init(images.icSettingsDefaultlist)
            )
        )
    }

    func produceComletedTasksCell() -> SettingsViewModel {
        return .simple(
            .init(
                item: .completed,
                title: "ARCHIVE",
                accessory: .present,
                description: nil,
                icon: .init(images.icSettingsArchive)
            )
        )
    }

    func produceRescheduleTasksCell() -> SettingsViewModel {
        return .simple(
            .init(
                item: .reschedule,
                title: "RESCEDULE",
                accessory: .present,
                description: nil,
                icon: .init(images.icSettingsReschedule)
            )
        )
    }


    func produceShareCell() -> SettingsViewModel {
        return .simple(
            .init(
                item: .share,
                title: "SHARE TASKEM",
                accessory: .present,
                description: nil,
                icon: .init(images.icSettingsShare)
            )
        )
    }

    func produceRateUsCell() -> SettingsViewModel {
        return .simple(
            .init(
                item: .rateUs,
                title: "RATE US",
                accessory: .present,
                description: nil,
                icon: .init(images.icSettingsRateus)
            )
        )
    }

    func produceLeaveFeebackCell() -> SettingsViewModel {
        return .simple(
            .init(
                item: .leaveFeedback,
                title: "LEAVE FEEDBACK",
                accessory: .present,
                description: nil,
                icon: .init(images.icSettingsFeedback)
            )
        )
    }

    func produceHelpCell() -> SettingsViewModel {
        return .simple(
            .init(
                item: .help,
                title: "HELP",
                accessory: .present,
                description: nil,
                icon: .init(images.icSettingsHelp)
            )
        )
    }


    func producePrivacyPolicyCell() -> SettingsViewModel {
        return .simple(
            .init(
                item: .privacyPolicy,
                title: "PRIVACY POLICY",
                accessory: .present,
                description: nil,
                icon: .init(images.icSettingsPrivacyPolicy)
            )
        )
    }

    func produceTermsOfUseCell() -> SettingsViewModel {
        return .simple(
            .init(
                item: .termsOfUse,
                title: "TERMS OF USE",
                accessory: .present,
                description: nil,
                icon: .init(images.icSettingsTermsOfUse)
            )
        )
    }
}

public extension SettingsViewModelFactory {
    func produceProfileSection(_ cells: [SettingsViewModel]) -> SettingsSectionViewModel {
        return .init(cells: cells, title: "USER")
    }
    
    func produceGeneralSection(_ cells: [SettingsViewModel]) -> SettingsSectionViewModel {
        return .init(cells: cells, title: "GENERAL")
    }
    
    func produceTimeSection(_ cells: [SettingsViewModel]) -> SettingsSectionViewModel {
        return .init(cells: cells, title: "TIME")
    }
    
    func produceTasksGroupsSection(_ cells: [SettingsViewModel]) -> SettingsSectionViewModel {
        return .init(cells: cells, title: "DATA")
    }
    
    func produceShareFeedabackSection(_ cells: [SettingsViewModel]) -> SettingsSectionViewModel {
        return .init(cells: cells, title: "SHARE & FEEDBACK")
    }
    
    func produceLegalSection(_ cells: [SettingsViewModel]) -> SettingsSectionViewModel {
        return .init(cells: cells, title: "LEGAL")
    }
}

public class SettingsDefaultViewModelFactory: SettingsViewModelFactory {
    
    public init() {
        
    }
    
    public func produce(from userPreferences: UserPreferencesProtocol,
                        user: User?,
                        defaultGroupName: String?) -> SettingsListViewModel {
        
        let profile = produceProfileSection(
            [
                produceProfileCell(user)
            ]
        )
        
        let general = produceGeneralSection(
            [
                produceThemeCell(userPreferences.theme),
                produceReminderSoundCell(userPreferences.reminderSound),
                produceFirstWeekdayCell(userPreferences.firstWeekday)
            ]
        )
        
        let time = produceTimeSection(
            [
                produceMorningCell(userPreferences.morning, extended: false, userPref: userPreferences),
                produceNoonCell(userPreferences.noon, extended: false, userPref: userPreferences),
                produceEveningCell(userPreferences.evening, extended: false, userPref: userPreferences)
            ]
        )
        
        let taskAndGroups = produceTasksGroupsSection(
            [
                produceDefaultListCell(defaultGroupName),
                produceComletedTasksCell(),
                produceRescheduleTasksCell()
            ]
        )
        
        let shareAndFeedback = produceShareFeedabackSection(
            [
                produceShareCell(),
                produceRateUsCell(),
                produceLeaveFeebackCell(),
                produceHelpCell()
            ]
        )
        
        let legal = produceLegalSection(
            [
                producePrivacyPolicyCell(),
                produceTermsOfUseCell()
            ]
        )
        
        let section = [
            profile,
            general,
            time,
            taskAndGroups,
            shareAndFeedback,
            legal
        ]
        
        return .init(sections: section)
    }
    
    public func produce(from sections: [SettingsSectionViewModel]) -> SettingsListViewModel {
        return .init(sections: sections)
    }
}
