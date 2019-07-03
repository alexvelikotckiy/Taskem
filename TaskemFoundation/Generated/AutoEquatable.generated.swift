// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable file_length
public func compareOptionals<T>(lhs: T?, rhs: T?, compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    switch (lhs, rhs) {
    case let (lValue?, rValue?):
        return compare(lValue, rValue)
    case (nil, nil):
        return true
    default:
        return false
    }
}

public func compareArrays<T>(lhs: [T], rhs: [T], compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for (idx, lhsItem) in lhs.enumerated() {
        guard compare(lhsItem, rhs[idx]) else { return false }
    }

    return true
}


// MARK: - AutoEquatable for classes, structs
// MARK: - CalendarControlListViewModel AutoEquatable
extension CalendarControlListViewModel: Equatable {}
public func == (lhs: CalendarControlListViewModel, rhs: CalendarControlListViewModel) -> Bool {
    guard lhs.sections == rhs.sections else { return false }
    return true
}
// MARK: - CalendarControlSectionViewModel AutoEquatable
extension CalendarControlSectionViewModel: Equatable {}
public func == (lhs: CalendarControlSectionViewModel, rhs: CalendarControlSectionViewModel) -> Bool {
    guard lhs.cells == rhs.cells else { return false }
    guard lhs.title == rhs.title else { return false }
    return true
}
// MARK: - CalendarListViewModel AutoEquatable
extension CalendarListViewModel: Equatable {}
public func == (lhs: CalendarListViewModel, rhs: CalendarListViewModel) -> Bool {
    guard lhs.sections == rhs.sections else { return false }
    guard lhs.currentDate == rhs.currentDate else { return false }
    guard lhs.style == rhs.style else { return false }
    return true
}
// MARK: - CalendarPageViewModel AutoEquatable
extension CalendarPageViewModel: Equatable {}
public func == (lhs: CalendarPageViewModel, rhs: CalendarPageViewModel) -> Bool {
    guard lhs.currentDate == rhs.currentDate else { return false }
    guard lhs.calendarType == rhs.calendarType else { return false }
    guard lhs.title == rhs.title else { return false }
    return true
}
// MARK: - CalendarSectionViewModel AutoEquatable
extension CalendarSectionViewModel: Equatable {}
public func == (lhs: CalendarSectionViewModel, rhs: CalendarSectionViewModel) -> Bool {
    guard lhs.cells == rhs.cells else { return false }
    guard lhs.date == rhs.date else { return false }
    return true
}
// MARK: - CompletedListViewModel AutoEquatable
extension CompletedListViewModel: Equatable {}
public func == (lhs: CompletedListViewModel, rhs: CompletedListViewModel) -> Bool {
    guard lhs.sections == rhs.sections else { return false }
    return true
}
// MARK: - CompletedSectionViewModel AutoEquatable
extension CompletedSectionViewModel: Equatable {}
public func == (lhs: CompletedSectionViewModel, rhs: CompletedSectionViewModel) -> Bool {
    guard lhs.cells == rhs.cells else { return false }
    guard lhs.status == rhs.status else { return false }
    return true
}
// MARK: - DatePickerManualViewModel AutoEquatable
extension DatePickerManualViewModel: Equatable {}
public func == (lhs: DatePickerManualViewModel, rhs: DatePickerManualViewModel) -> Bool {
    guard lhs.datePreferences == rhs.datePreferences else { return false }
    guard lhs.mode == rhs.mode else { return false }
    return true
}
// MARK: - DatePickerTemplatesListViewModel AutoEquatable
extension DatePickerTemplatesListViewModel: Equatable {}
public func == (lhs: DatePickerTemplatesListViewModel, rhs: DatePickerTemplatesListViewModel) -> Bool {
    guard lhs.sections == rhs.sections else { return false }
    return true
}
// MARK: - DatePickerTemplatesSectionViewModel AutoEquatable
extension DatePickerTemplatesSectionViewModel: Equatable {}
public func == (lhs: DatePickerTemplatesSectionViewModel, rhs: DatePickerTemplatesSectionViewModel) -> Bool {
    guard lhs.cells == rhs.cells else { return false }
    return true
}
// MARK: - DatePickerTemplatesViewModel AutoEquatable
extension DatePickerTemplatesViewModel: Equatable {}
public func == (lhs: DatePickerTemplatesViewModel, rhs: DatePickerTemplatesViewModel) -> Bool {
    guard lhs.title == rhs.title else { return false }
    guard lhs.template == rhs.template else { return false }
    return true
}
// MARK: - DefaultGroupPickerListViewModel AutoEquatable
extension DefaultGroupPickerListViewModel: Equatable {}
public func == (lhs: DefaultGroupPickerListViewModel, rhs: DefaultGroupPickerListViewModel) -> Bool {
    guard lhs.cells == rhs.cells else { return false }
    return true
}
// MARK: - GroupColorPickerListViewModel AutoEquatable
extension GroupColorPickerListViewModel: Equatable {}
public func == (lhs: GroupColorPickerListViewModel, rhs: GroupColorPickerListViewModel) -> Bool {
    guard lhs.cells == rhs.cells else { return false }
    return true
}
// MARK: - GroupIconPickerListViewModel AutoEquatable
extension GroupIconPickerListViewModel: Equatable {}
public func == (lhs: GroupIconPickerListViewModel, rhs: GroupIconPickerListViewModel) -> Bool {
    guard lhs.cells == rhs.cells else { return false }
    return true
}
// MARK: - GroupOverviewListViewModel AutoEquatable
extension GroupOverviewListViewModel: Equatable {}
public func == (lhs: GroupOverviewListViewModel, rhs: GroupOverviewListViewModel) -> Bool {
    guard lhs.sections == rhs.sections else { return false }
    guard lhs.editing == rhs.editing else { return false }
    guard lhs.project == rhs.project else { return false }
    return true
}
// MARK: - GroupOverviewSectionViewModel AutoEquatable
extension GroupOverviewSectionViewModel: Equatable {}
public func == (lhs: GroupOverviewSectionViewModel, rhs: GroupOverviewSectionViewModel) -> Bool {
    guard lhs.cells == rhs.cells else { return false }
    return true
}
// MARK: - GroupPopupListViewModel AutoEquatable
extension GroupPopupListViewModel: Equatable {}
public func == (lhs: GroupPopupListViewModel, rhs: GroupPopupListViewModel) -> Bool {
    guard lhs.sections == rhs.sections else { return false }
    return true
}
// MARK: - GroupPopupSectionViewModel AutoEquatable
extension GroupPopupSectionViewModel: Equatable {}
public func == (lhs: GroupPopupSectionViewModel, rhs: GroupPopupSectionViewModel) -> Bool {
    guard lhs.cells == rhs.cells else { return false }
    return true
}
// MARK: - NotificationSoundPickerListViewModel AutoEquatable
extension NotificationSoundPickerListViewModel: Equatable {}
public func == (lhs: NotificationSoundPickerListViewModel, rhs: NotificationSoundPickerListViewModel) -> Bool {
    guard lhs.sections == rhs.sections else { return false }
    return true
}
// MARK: - NotificationSoundPickerSectionViewModel AutoEquatable
extension NotificationSoundPickerSectionViewModel: Equatable {}
public func == (lhs: NotificationSoundPickerSectionViewModel, rhs: NotificationSoundPickerSectionViewModel) -> Bool {
    guard lhs.cells == rhs.cells else { return false }
    return true
}
// MARK: - ReminderManualListViewModel AutoEquatable
extension ReminderManualListViewModel: Equatable {}
public func == (lhs: ReminderManualListViewModel, rhs: ReminderManualListViewModel) -> Bool {
    guard lhs.sections == rhs.sections else { return false }
    guard lhs.reminder == rhs.reminder else { return false }
    return true
}
// MARK: - ReminderManualSectionViewModel AutoEquatable
extension ReminderManualSectionViewModel: Equatable {}
public func == (lhs: ReminderManualSectionViewModel, rhs: ReminderManualSectionViewModel) -> Bool {
    guard lhs.cells == rhs.cells else { return false }
    return true
}
// MARK: - ReminderTemplatesListViewModel AutoEquatable
extension ReminderTemplatesListViewModel: Equatable {}
public func == (lhs: ReminderTemplatesListViewModel, rhs: ReminderTemplatesListViewModel) -> Bool {
    guard lhs.reminder == rhs.reminder else { return false }
    guard lhs.sections == rhs.sections else { return false }
    return true
}
// MARK: - ReminderTemplatesSectionViewModel AutoEquatable
extension ReminderTemplatesSectionViewModel: Equatable {}
public func == (lhs: ReminderTemplatesSectionViewModel, rhs: ReminderTemplatesSectionViewModel) -> Bool {
    guard lhs.cells == rhs.cells else { return false }
    return true
}
// MARK: - RepeatManualListViewModel AutoEquatable
extension RepeatManualListViewModel: Equatable {}
public func == (lhs: RepeatManualListViewModel, rhs: RepeatManualListViewModel) -> Bool {
    guard lhs.sections == rhs.sections else { return false }
    guard lhs.`repeat` == rhs.`repeat` else { return false }
    return true
}
// MARK: - RepeatManualSectionViewModel AutoEquatable
extension RepeatManualSectionViewModel: Equatable {}
public func == (lhs: RepeatManualSectionViewModel, rhs: RepeatManualSectionViewModel) -> Bool {
    guard lhs.cells == rhs.cells else { return false }
    return true
}
// MARK: - RepeatTemplatesListViewModel AutoEquatable
extension RepeatTemplatesListViewModel: Equatable {}
public func == (lhs: RepeatTemplatesListViewModel, rhs: RepeatTemplatesListViewModel) -> Bool {
    guard lhs.sections == rhs.sections else { return false }
    return true
}
// MARK: - RepeatTemplatesSectionViewModel AutoEquatable
extension RepeatTemplatesSectionViewModel: Equatable {}
public func == (lhs: RepeatTemplatesSectionViewModel, rhs: RepeatTemplatesSectionViewModel) -> Bool {
    guard lhs.cells == rhs.cells else { return false }
    return true
}
// MARK: - RescheduleListViewModel AutoEquatable
extension RescheduleListViewModel: Equatable {}
public func == (lhs: RescheduleListViewModel, rhs: RescheduleListViewModel) -> Bool {
    guard lhs.cards == rhs.cards else { return false }
    guard lhs.overlays == rhs.overlays else { return false }
    guard lhs.toolbar == rhs.toolbar else { return false }
    return true
}
// MARK: - ScheduleControlListViewModel AutoEquatable
extension ScheduleControlListViewModel: Equatable {}
public func == (lhs: ScheduleControlListViewModel, rhs: ScheduleControlListViewModel) -> Bool {
    guard lhs.sections == rhs.sections else { return false }
    guard lhs.isEditing == rhs.isEditing else { return false }
    return true
}
// MARK: - ScheduleControlSectionViewModel AutoEquatable
extension ScheduleControlSectionViewModel: Equatable {}
public func == (lhs: ScheduleControlSectionViewModel, rhs: ScheduleControlSectionViewModel) -> Bool {
    guard lhs.cells == rhs.cells else { return false }
    return true
}
// MARK: - ScheduleListViewModel AutoEquatable
extension ScheduleListViewModel: Equatable {}
public func == (lhs: ScheduleListViewModel, rhs: ScheduleListViewModel) -> Bool {
    guard lhs.sections == rhs.sections else { return false }
    guard lhs.title == rhs.title else { return false }
    guard lhs.type == rhs.type else { return false }
    guard lhs.navbarData == rhs.navbarData else { return false }
    return true
}
// MARK: - ScheduleSectionViewModel AutoEquatable
extension ScheduleSectionViewModel: Equatable {}
public func == (lhs: ScheduleSectionViewModel, rhs: ScheduleSectionViewModel) -> Bool {
    guard lhs.cells == rhs.cells else { return false }
    guard lhs.title == rhs.title else { return false }
    guard lhs.isExpanded == rhs.isExpanded else { return false }
    guard lhs.actionType == rhs.actionType else { return false }
    guard lhs.type == rhs.type else { return false }
    return true
}
// MARK: - SettingsListViewModel AutoEquatable
extension SettingsListViewModel: Equatable {}
public func == (lhs: SettingsListViewModel, rhs: SettingsListViewModel) -> Bool {
    guard lhs.sections == rhs.sections else { return false }
    return true
}
// MARK: - SettingsSectionViewModel AutoEquatable
extension SettingsSectionViewModel: Equatable {}
public func == (lhs: SettingsSectionViewModel, rhs: SettingsSectionViewModel) -> Bool {
    guard lhs.cells == rhs.cells else { return false }
    guard lhs.title == rhs.title else { return false }
    return true
}
// MARK: - TaskOverviewListViewModel AutoEquatable
extension TaskOverviewListViewModel: Equatable {}
public func == (lhs: TaskOverviewListViewModel, rhs: TaskOverviewListViewModel) -> Bool {
    guard lhs.sections == rhs.sections else { return false }
    guard lhs.editing == rhs.editing else { return false }
    guard lhs.model == rhs.model else { return false }
    guard lhs.initialData == rhs.initialData else { return false }
    return true
}
// MARK: - TaskOverviewSectionViewModel AutoEquatable
extension TaskOverviewSectionViewModel: Equatable {}
public func == (lhs: TaskOverviewSectionViewModel, rhs: TaskOverviewSectionViewModel) -> Bool {
    guard lhs.cells == rhs.cells else { return false }
    guard compareOptionals(lhs: lhs.footer, rhs: rhs.footer, compare: ==) else { return false }
    return true
}
// MARK: - UserProfileListViewModel AutoEquatable
extension UserProfileListViewModel: Equatable {}
public func == (lhs: UserProfileListViewModel, rhs: UserProfileListViewModel) -> Bool {
    guard lhs.sections == rhs.sections else { return false }
    return true
}
// MARK: - UserProfileSectionViewModel AutoEquatable
extension UserProfileSectionViewModel: Equatable {}
public func == (lhs: UserProfileSectionViewModel, rhs: UserProfileSectionViewModel) -> Bool {
    guard lhs.title == rhs.title else { return false }
    guard lhs.footer == rhs.footer else { return false }
    guard lhs.cells == rhs.cells else { return false }
    return true
}

// MARK: - AutoEquatable for Enums
