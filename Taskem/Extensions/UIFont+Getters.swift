//
//  UIFont+Getters.swift
//  Taskem
//
//  Created by Wilson on 15.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

//Avenir Next
//AvenirNext-Medium
//AvenirNext-DemiBoldItalic
//AvenirNext-DemiBold
//AvenirNext-HeavyItalic
//AvenirNext-Regular
//AvenirNext-Italic
//AvenirNext-MediumItalic
//AvenirNext-UltraLightItalic
//AvenirNext-BoldItalic
//AvenirNext-Heavy
//AvenirNext-Bold
//AvenirNext-UltraLight

enum FontWeight: String {
    case medium = "Medium"
    case regular = "Regular"
    case light = "UltraLight"
    case bold = "Bold"
    case demiBold = "DemiBold"
}

extension UIFont {
    static func avenirNext(ofSize size: CGFloat, weight: FontWeight = .regular) -> UIFont {
        return UIFont(
            name: "AvenirNext-\(weight.rawValue)",
            size: size)!
    }
}
