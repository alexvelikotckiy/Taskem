// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  public typealias AssetColorTypeAlias = NSColor
  public typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  public typealias AssetColorTypeAlias = UIColor
  public typealias AssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Images {
  public enum Foundation {
    public static let icCalendarCustom = ImageAsset(name: "ic_calendar_custom")
    public static let icCalendarNoneLarge = ImageAsset(name: "ic_calendar_none_large")
    public static let icClockLarge = ImageAsset(name: "ic_clock_large")
    public static let icEvening = ImageAsset(name: "ic_evening")
    public static let icMorning = ImageAsset(name: "ic_morning")
    public static let icNoon = ImageAsset(name: "ic_noon")
    public static let icRescheduleUndefinedCalendar = ImageAsset(name: "ic_reschedule__undefined_calendar")
    public static let icRescheduleCalendar = ImageAsset(name: "ic_reschedule_calendar")
    public static let icRescheduleComplete = ImageAsset(name: "ic_reschedule_complete")
    public static let icRescheduleDelete = ImageAsset(name: "ic_reschedule_delete")
    public static let icRescheduleSkip = ImageAsset(name: "ic_reschedule_skip")
    public static let icScheduleSortByCompletionDark = ImageAsset(name: "ic_schedule_sort_by_completion_dark")
    public static let icScheduleSortByCompletionLight = ImageAsset(name: "ic_schedule_sort_by_completion_light")
    public static let icScheduleSortByDateDark = ImageAsset(name: "ic_schedule_sort_by_date_dark")
    public static let icScheduleSortByDateLight = ImageAsset(name: "ic_schedule_sort_by_date_light")
    public static let icScheduleSortByListDark = ImageAsset(name: "ic_schedule_sort_by_list_dark")
    public static let icScheduleSortByListLight = ImageAsset(name: "ic_schedule_sort_by_list_light")
    public static let icCalendar = ImageAsset(name: "ic_calendar")
    public static let icCalendarNone = ImageAsset(name: "ic_calendar_none")
    public static let icClock = ImageAsset(name: "ic_clock")
    public static let icReminderAtEventDate = ImageAsset(name: "ic_reminder_at_event_date")
    public static let icReminderCustomDate = ImageAsset(name: "ic_reminder_custom_date")
    public static let icReminderFiveMinutesBefore = ImageAsset(name: "ic_reminder_five_minutes_before")
    public static let icReminderHourBefore = ImageAsset(name: "ic_reminder_hour_before")
    public static let icReminderOneDay = ImageAsset(name: "ic_reminder_one_day")
    public static let icReminderOneWeek = ImageAsset(name: "ic_reminder_one_week")
    public static let icReminderThirtyMinutesBefore = ImageAsset(name: "ic_reminder_thirty_minutes_before")
    public static let icRepeatCustom = ImageAsset(name: "ic_repeat_custom")
    public static let icRepeatDaily = ImageAsset(name: "ic_repeat_daily")
    public static let icRepeatMonthly = ImageAsset(name: "ic_repeat_monthly")
    public static let icRepeatWeekdays = ImageAsset(name: "ic_repeat_weekdays")
    public static let icRepeatWeekends = ImageAsset(name: "ic_repeat_weekends")
    public static let icRepeatWeekly = ImageAsset(name: "ic_repeat_weekly")
    public static let icRepeatYearly = ImageAsset(name: "ic_repeat_yearly")
    public static let icScheduleAddTask = ImageAsset(name: "ic_schedule_add_task")
    public static let icScheduleClearCompleted = ImageAsset(name: "ic_schedule_clear_completed")
    public static let icScheduleReschedule = ImageAsset(name: "ic_schedule_reschedule")
    public static let icSettingsApptheme = ImageAsset(name: "ic_settings_apptheme")
    public static let icSettingsArchive = ImageAsset(name: "ic_settings_archive")
    public static let icSettingsDefaultlist = ImageAsset(name: "ic_settings_defaultlist")
    public static let icSettingsEvening = ImageAsset(name: "ic_settings_evening")
    public static let icSettingsFeedback = ImageAsset(name: "ic_settings_feedback")
    public static let icSettingsFirstweekday = ImageAsset(name: "ic_settings_firstweekday")
    public static let icSettingsHelp = ImageAsset(name: "ic_settings_help")
    public static let icSettingsMorning = ImageAsset(name: "ic_settings_morning")
    public static let icSettingsNoon = ImageAsset(name: "ic_settings_noon")
    public static let icSettingsPrivacyPolicy = ImageAsset(name: "ic_settings_privacy_policy")
    public static let icSettingsProfile = ImageAsset(name: "ic_settings_profile")
    public static let icSettingsRateus = ImageAsset(name: "ic_settings_rateus")
    public static let icSettingsRemindsound = ImageAsset(name: "ic_settings_remindsound")
    public static let icSettingsReschedule = ImageAsset(name: "ic_settings_reschedule")
    public static let icSettingsShare = ImageAsset(name: "ic_settings_share")
    public static let icSettingsTermsOfUse = ImageAsset(name: "ic_settings_terms_of_use")
    public static let icTaskOverviewDate = ImageAsset(name: "ic_task_overview_date")
    public static let icTaskOverviewList = ImageAsset(name: "ic_task_overview_list")
    public static let icTaskOverviewNotes = ImageAsset(name: "ic_task_overview_notes")
    public static let icTaskOverviewReminder = ImageAsset(name: "ic_task_overview_reminder")
    public static let icTaskOverviewRepeat = ImageAsset(name: "ic_task_overview_repeat")
    public static let icUserprofileDeleteAccount = ImageAsset(name: "ic_userprofile_delete_account")
    public static let icUserprofileEmail = ImageAsset(name: "ic_userprofile_email")
    public static let icUserprofileLogin = ImageAsset(name: "ic_userprofile_login")
    public static let icUserprofileResetPass = ImageAsset(name: "ic_userprofile_reset_pass")
    public static let icUserprofileSignOut = ImageAsset(name: "ic_userprofile_sign_out")
    // swiftlint:disable trailing_comma
    public static let allColors: [ColorAsset] = [
    ]
    public static let allDataAssets: [DataAsset] = [
    ]
    public static let allImages: [ImageAsset] = [
      icCalendarCustom,
      icCalendarNoneLarge,
      icClockLarge,
      icEvening,
      icMorning,
      icNoon,
      icRescheduleUndefinedCalendar,
      icRescheduleCalendar,
      icRescheduleComplete,
      icRescheduleDelete,
      icRescheduleSkip,
      icScheduleSortByCompletionDark,
      icScheduleSortByCompletionLight,
      icScheduleSortByDateDark,
      icScheduleSortByDateLight,
      icScheduleSortByListDark,
      icScheduleSortByListLight,
      icCalendar,
      icCalendarNone,
      icClock,
      icReminderAtEventDate,
      icReminderCustomDate,
      icReminderFiveMinutesBefore,
      icReminderHourBefore,
      icReminderOneDay,
      icReminderOneWeek,
      icReminderThirtyMinutesBefore,
      icRepeatCustom,
      icRepeatDaily,
      icRepeatMonthly,
      icRepeatWeekdays,
      icRepeatWeekends,
      icRepeatWeekly,
      icRepeatYearly,
      icScheduleAddTask,
      icScheduleClearCompleted,
      icScheduleReschedule,
      icSettingsApptheme,
      icSettingsArchive,
      icSettingsDefaultlist,
      icSettingsEvening,
      icSettingsFeedback,
      icSettingsFirstweekday,
      icSettingsHelp,
      icSettingsMorning,
      icSettingsNoon,
      icSettingsPrivacyPolicy,
      icSettingsProfile,
      icSettingsRateus,
      icSettingsRemindsound,
      icSettingsReschedule,
      icSettingsShare,
      icSettingsTermsOfUse,
      icTaskOverviewDate,
      icTaskOverviewList,
      icTaskOverviewNotes,
      icTaskOverviewReminder,
      icTaskOverviewRepeat,
      icUserprofileDeleteAccount,
      icUserprofileEmail,
      icUserprofileLogin,
      icUserprofileResetPass,
      icUserprofileSignOut,
    ]
    // swiftlint:enable trailing_comma
  }
  public enum Lists {
    public static let icAirTransport = ImageAsset(name: "ic_air-transport")
    public static let icAppleBlackSilhouetteWithALeaf = ImageAsset(name: "ic_apple-black-silhouette-with-a-leaf")
    public static let icBriefcase = ImageAsset(name: "ic_briefcase")
    public static let icBuddhistYogaPose = ImageAsset(name: "ic_buddhist-yoga-pose")
    public static let icCalendarList = ImageAsset(name: "ic_calendar_list")
    public static let icCollegeGraduation = ImageAsset(name: "ic_college-graduation")
    public static let icDesktopMonitor = ImageAsset(name: "ic_desktop-monitor")
    public static let icDropletOfWater = ImageAsset(name: "ic_droplet-of-water")
    public static let icDrugs = ImageAsset(name: "ic_drugs")
    public static let icDumbbellVariantOutline = ImageAsset(name: "ic_dumbbell-variant-outline")
    public static let icEmailinbox = ImageAsset(name: "ic_emailinbox")
    public static let icGift = ImageAsset(name: "ic_gift")
    public static let icHeartbeat = ImageAsset(name: "ic_heartbeat")
    public static let icJoystick = ImageAsset(name: "ic_joystick")
    public static let icMusicPlayer = ImageAsset(name: "ic_music-player")
    public static let icOpenBook = ImageAsset(name: "ic_open-book")
    public static let icRunning = ImageAsset(name: "ic_running")
    public static let icShoppingCart = ImageAsset(name: "ic_shopping-cart")
    public static let icVideoCamera = ImageAsset(name: "ic_video-camera")
    // swiftlint:disable trailing_comma
    public static let allColors: [ColorAsset] = [
    ]
    public static let allDataAssets: [DataAsset] = [
    ]
    public static let allImages: [ImageAsset] = [
      icAirTransport,
      icAppleBlackSilhouetteWithALeaf,
      icBriefcase,
      icBuddhistYogaPose,
      icCalendarList,
      icCollegeGraduation,
      icDesktopMonitor,
      icDropletOfWater,
      icDrugs,
      icDumbbellVariantOutline,
      icEmailinbox,
      icGift,
      icHeartbeat,
      icJoystick,
      icMusicPlayer,
      icOpenBook,
      icRunning,
      icShoppingCart,
      icVideoCamera,
    ]
    // swiftlint:enable trailing_comma
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public struct ColorAsset {
  public fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  public var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

public extension AssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

public struct DataAsset {
  public fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(OSX)
  @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
  public var data: NSDataAsset {
    return NSDataAsset(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(OSX)
@available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
public extension NSDataAsset {
  convenience init!(asset: DataAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(OSX)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

public struct ImageAsset {
  public fileprivate(set) var name: String

  public var image: AssetImageTypeAlias {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = AssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = AssetImageTypeAlias(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

public extension AssetImageTypeAlias {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {}
