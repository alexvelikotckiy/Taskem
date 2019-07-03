//
//  TaskemCalendar.swift
//  Taskem
//
//  Created by Wilson on 15.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import FSCalendar

@IBDesignable
class TaskemCalendar: FSCalendar, ThemeObservable {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    override func prepareForInterfaceBuilder() {
        setupView()
        super.prepareForInterfaceBuilder()
    }

    private func setupView() {
        observeAppTheme()
        
        applyTheme(AppTheme.current)
        
        clipsToBounds = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateFirstWeekday),
            name: .UserPreferencesDidChangeFirstWeekday,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func applyTheme(_ theme: AppTheme) {
        let palette = Color.TaskemMain.self
        
        appearance.titleFont           = .avenirNext(ofSize: 12, weight: .medium)
        appearance.headerTitleFont     = .avenirNext(ofSize: 18, weight: .medium)
        appearance.weekdayFont         = .avenirNext(ofSize: 12, weight: .medium)
        
        appearance.selectionColor           = palette.red
        appearance.todaySelectionColor      = palette.red
        appearance.todayColor               = palette.blue
        appearance.headerTitleColor         = theme == .light ? palette.greyDark    : palette.white
        appearance.titlePlaceholderColor    = theme == .light ? palette.whiteDimmed : palette.greyDimmed
        appearance.titleDefaultColor        = theme == .light ? palette.greyDark    : palette.white
        appearance.weekdayTextColor         = theme == .light ? palette.grey        : palette.white
        appearance.headerTitleColor         = theme == .light ? palette.greyDark    : palette.white
        
        rowHeight = 30
        headerHeight = 70
        weekdayHeight = 20
        
        appearance.caseOptions = [.weekdayUsesUpperCase]
    }
    
    @objc private func updateFirstWeekday() {
        firstWeekday = UInt(UserPreferences.current.firstWeekday.rawValue) ?? 1
        reloadData()
    }
}
