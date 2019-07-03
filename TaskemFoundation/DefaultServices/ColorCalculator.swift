//
//  ColorCalculator.swift
//  TaskemFoundation
//
//  Created by Wilson on 4/3/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class ColorCalculator {
    public init() {

    }

    public static func colorFlag(for task: Task) -> Color {
        let theme = AppTheme.current
        
        guard !task.isComplete else {
            return theme.checkboxBlue.color
        }
        
        let calendar = Calendar.current
        if let date = task.datePreference.date,
            calendar.taskem_isDayInToday(date: date),
            !calendar.taskem_isDayBefore(date: date, to: Date.now) {
            return theme.checkboxYellow.color
        }
        return theme.checkboxRed.color
    }
}
