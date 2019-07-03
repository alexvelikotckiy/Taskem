//
//  Palette.swift
//  TaskemFoundation
//
//  Created by Wilson on 12/4/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

// Global App Scheme
public extension AppTheme {
    private typealias Palette = Color.TaskemMain

    var background: UIColor {
        return isLightTheme ? Palette.white : Palette.dark
    }

    var tableBackgroundDark: UIColor {
        return isLightTheme ? Palette.whiteDark : Palette.darkDimmed
    }
    
    var navbar: UIColor {
        return isLightTheme ? Palette.whiteDark : Palette.darkDimmed
    }
    
    var navBarTitle: UIColor {
        return isLightTheme ? Palette.greyDark : Palette.white
    }
    
    var navBarSubtitle: UIColor {
        return (isLightTheme ? Palette.grey : Palette.whiteDimmed).withAlphaComponent(0.5)
    }
    
    var navBarItem: UIColor {
        return isLightTheme ? Palette.greyDimmed : Palette.white
    }
    
    var navBarItemSecond: UIColor {
        return Palette.blue 
    }

    var navBarItemHighlighted: UIColor {
        return isLightTheme ? Palette.blue : Palette.whiteDark
    }
    
    var navBarItemDisabled: UIColor {
        return isLightTheme ? Palette.whiteDimmed : Palette.greyDark
    }
    
    var toolbar: UIColor {
        return isLightTheme ? Palette.whiteDark : Palette.darkDimmed
    }
    
    var onboardingWave: UIColor {
        return isLightTheme ? Palette.blue.withAlphaComponent(0.5) : Palette.white
    }

    var handleView: UIColor {
        return isLightTheme ? Palette.greyDark : Palette.white
    }
    
    var firstTitle: UIColor {
        return Palette.blue
    }

    var secondTitle: UIColor {
        return isLightTheme ? Palette.greyDark : Palette.white
    }

    var thirdTitle: UIColor {
        return isLightTheme ? Palette.grey : Palette.white
    }
    
    var fourthTitle: UIColor {
        return isLightTheme ? Palette.greyDimmed : Palette.white
    }
    
    var fifthTitle: UIColor {
        return (isLightTheme ? Palette.greyDimmed : Palette.whiteDimmed).withAlphaComponent(0.5)
    }
    
    var textViewPlaceholder: UIColor {
        return isLightTheme ? Palette.grey.withAlphaComponent(0.5) : Palette.greyDimmed
    }
    
    var promt: UIColor {
        return isLightTheme ? Palette.grey.withAlphaComponent(0.5) : Palette.greyDimmed
    }
    
    var textView: UIColor {
        return secondTitle
    }
    
    var blackTitle: UIColor {
        return Palette.greyDark
    }
    
    var whiteTitle: UIColor {
        return Palette.white
    }
    
    var redTitle: UIColor {
        return Palette.red
    }

    var activeBlueButton: UIColor {
        return Palette.blue
    }

    var unactiveBlueButton: UIColor {
        return Palette.blueDark
    }

    var onboardingSlider: UIColor {
        return isLightTheme ? Palette.greyDimmed : Palette.white
    }

    var separator: UIColor {
        return isLightTheme ? Palette.grey.withAlphaComponent(0.5) : Palette.white.withAlphaComponent(0.3)
    }

    var separatorSecond: UIColor {
        return isLightTheme ? Palette.whiteDark : Palette.darkDimmed.withAlphaComponent(0.5)
    }
    
    var separatorThird: UIColor {
        return isLightTheme ? Palette.whiteDark : Palette.darkDimmed
    }
    
    var separatorActive: UIColor {
        return Palette.blue
    }

    var separatorRed: UIColor {
        return Palette.red
    }
    
    var activeTextBoxBorder: UIColor {
        return Palette.blue
    }
    
    var activeIncorrectTextBoxBorder: UIColor {
        return Palette.red
    }
    
    var inactiveTextBoxBorder: UIColor {
        return (isLightTheme ? Palette.grey : Palette.grey).withAlphaComponent(0.5)
    }
    
    var cellFrame: UIColor {
        return isLightTheme ? Palette.whiteDark : Palette.darkDimmed
    }
    
    var cellFrameShadow: UIColor {
        return (isLightTheme ? Palette.grey : Palette.grey).withAlphaComponent(0.5)
    }
    
    var cellHighlight: UIColor {
        return (isLightTheme ? Palette.whiteDark : Palette.greyDark).withAlphaComponent(0.5)
    }
    
    var cellSelection: UIColor {
        return isLightTheme ? Palette.blueLightweight : Palette.blueDark
    }
    
    var cellSubtitle: UIColor {
        return isLightTheme ? Palette.grey : Palette.greyDimmed
    }
    
    var modalViewShadow: UIColor {
        return (isLightTheme ? Palette.grey : Palette.whiteDimmed).withAlphaComponent(0.5)
    }
    
    var iconTint: UIColor {
        return isLightTheme ? Palette.greyDark : Palette.white
    }
    
    var iconTintBlue: UIColor {
        return Palette.blue
    }
    
    var iconTintUnhighlightedTint: UIColor {
        return isLightTheme ? Palette.whiteDimmed : Palette.greyDimmed
    }
    
    var iconHighlightedTint: UIColor {
        return Palette.blue
    }
    
    var iconPlaceholder: UIColor {
        return isLightTheme ? Palette.blue.withAlphaComponent(0.5) : Palette.grey.withAlphaComponent(0.5)
    }
    
    var refreshControl: UIColor {
        return Palette.blue
    }
    
    var checkboxBlue: UIColor {
        return Palette.blueLight
    }
    
    var checkboxRed: UIColor {
        return Palette.redLight
    }
    
    var checkboxYellow: UIColor {
        return Palette.yellow
    }
    
    var badge: UIColor {
        return Palette.blue
    }
    
    var badgeHighlighted: UIColor {
        return Palette.redLight
    }
    
    var today: UIColor {
        return Palette.purple
    }
    
    var swipeTaskLeft: UIColor {
        return Palette.purple
    }
    
    var swipeTaskRight: UIColor {
        return Palette.yellow
    }
    
    var swipeTaskLeftDelete: UIColor {
        return Palette.redLight
    }
}

// User List Colors
public extension AppTheme {
    var listColors: [UIColor] {
        return Color.TaskemLists.allColors
    }
}

private extension AppTheme {
    var isLightTheme: Bool {
        return self == .light
    }
}
