// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias AssetColorTypeAlias = NSColor
  internal typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias AssetColorTypeAlias = UIColor
  internal typealias AssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Icons {
  internal static let icAllDoneDark = ImageAsset(name: "ic_all_done_dark")
  internal static let icAllDoneLight = ImageAsset(name: "ic_all_done_light")
  internal static let icFreeDayDark = ImageAsset(name: "ic_free_day_dark")
  internal static let icFreeDayLight = ImageAsset(name: "ic_free_day_light")
  internal static let icNicelyDoneDark = ImageAsset(name: "ic_nicely_done_dark")
  internal static let icNicelyDoneLight = ImageAsset(name: "ic_nicely_done_light")
  internal static let icNothingFoundDark = ImageAsset(name: "ic_nothing_found_dark")
  internal static let icNothingFoundLight = ImageAsset(name: "ic_nothing_found_light")
  internal static let icOnboardingDark1 = ImageAsset(name: "ic_onboarding_dark_1")
  internal static let icOnboardingDark2 = ImageAsset(name: "ic_onboarding_dark_2")
  internal static let icOnboardingDark3 = ImageAsset(name: "ic_onboarding_dark_3")
  internal static let icOnboardingLight1 = ImageAsset(name: "ic_onboarding_light_1")
  internal static let icOnboardingLight2 = ImageAsset(name: "ic_onboarding_light_2")
  internal static let icOnboardingLight3 = ImageAsset(name: "ic_onboarding_light_3")
  internal static let icAdd = ImageAsset(name: "ic_add")
  internal static let icAppIcon = ImageAsset(name: "ic_app_icon")
  internal static let icBadgeEdit = ImageAsset(name: "ic_badge_edit")
  internal static let icCalendarHideCompleted = ImageAsset(name: "ic_calendar_hide_completed")
  internal static let icCalendarShowCompleted = ImageAsset(name: "ic_calendar_show_completed")
  internal static let icCalendarTodayBackgroud = ImageAsset(name: "ic_calendar_today_backgroud")
  internal static let icCalendarType = ImageAsset(name: "ic_calendar_type")
  internal static let icCancel = ImageAsset(name: "ic_cancel")
  internal static let icCorrect = ImageAsset(name: "ic_correct")
  internal static let icGoogle = ImageAsset(name: "ic_google")
  internal static let icIncorrect = ImageAsset(name: "ic_incorrect")
  internal static let icPlus = ImageAsset(name: "ic_plus")
  internal static let icRemoveSmall = ImageAsset(name: "ic_remove_small")
  internal static let icScheduleChevron = ImageAsset(name: "ic_schedule_chevron")
  internal static let icScheduleChevronUp = ImageAsset(name: "ic_schedule_chevron_up")
  internal static let icScheduleRefresh = ImageAsset(name: "ic_schedule_refresh")
  internal static let icScheduleRescheduleLarge = ImageAsset(name: "ic_schedule_reschedule_large")
  internal static let icScheduleSearch = ImageAsset(name: "ic_schedule_search")
  internal static let icScheduleSorting = ImageAsset(name: "ic_schedule_sorting")
  internal static let icStar = ImageAsset(name: "ic_star")
  internal static let icSwipeCalendar = ImageAsset(name: "ic_swipe_calendar")
  internal static let icSwipeComplete = ImageAsset(name: "ic_swipe_complete")
  internal static let icSwipeTrash = ImageAsset(name: "ic_swipe_trash")
  internal static let icBackChevron = ImageAsset(name: "ic_back_chevron")
  internal static let icBurger = ImageAsset(name: "ic_burger")
  internal static let icCalendarChevron = ImageAsset(name: "ic_calendar_chevron")
  internal static let icCalendarFilter = ImageAsset(name: "ic_calendar_filter")
  internal static let icColorPickerChecked = ImageAsset(name: "ic_color_picker_checked")
  internal static let icCrosshair = ImageAsset(name: "ic_crosshair")
  internal static let icDateCalendar = ImageAsset(name: "ic_date_calendar")
  internal static let icList = ImageAsset(name: "ic_list")
  internal static let icPicturePlaceholder = ImageAsset(name: "ic_picture_placeholder")
  internal static let icReminder = ImageAsset(name: "ic_reminder")
  internal static let icRepeat = ImageAsset(name: "ic_repeat")
  internal static let icRescheduleChevronLeft = ImageAsset(name: "ic_reschedule_chevron_left")
  internal static let icRescheduleChevronRight = ImageAsset(name: "ic_reschedule_chevron_right")
  internal static let icScheduleEditDelete = ImageAsset(name: "ic_schedule_edit_delete")
  internal static let icScheduleEditList = ImageAsset(name: "ic_schedule_edit_list")
  internal static let icScheduleEditShare = ImageAsset(name: "ic_schedule_edit_share")
  internal static let icScheduleReminder = ImageAsset(name: "ic_schedule_reminder")
  internal static let icScheduleRepeat = ImageAsset(name: "ic_schedule_repeat")
  internal static let icTabbarCalendar = ImageAsset(name: "ic_tabbar_calendar")
  internal static let icTabbarSchedule = ImageAsset(name: "ic_tabbar_schedule")
  internal static let icTabbarSettings = ImageAsset(name: "ic_tabbar_settings")
  internal static let icTaskOverviewShare = ImageAsset(name: "ic_task_overview_share")
  internal static let icThreeDots = ImageAsset(name: "ic_three_dots")
  internal static let icWave1 = ImageAsset(name: "ic_wave_1")
  internal static let icWave2 = ImageAsset(name: "ic_wave_2")
  internal static let icWave3 = ImageAsset(name: "ic_wave_3")
  internal static let icWave4 = ImageAsset(name: "ic_wave_4")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  internal var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

internal extension AssetColorTypeAlias {
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

internal struct DataAsset {
  internal fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(OSX)
  @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
  internal var data: NSDataAsset {
    return NSDataAsset(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(OSX)
@available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
internal extension NSDataAsset {
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

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  internal var image: AssetImageTypeAlias {
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

internal extension AssetImageTypeAlias {
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
