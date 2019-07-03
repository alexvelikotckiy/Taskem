//
//  UIColor+Helpers.swift
//  Taskem
//
//  Created by Wilson on 11.11.2017.
//  Copyright © 2017 Wilson. All rights reserved.
//

import UIKit
import Foundation

public extension UIColor {

    class func uicolorFromHex(rgbValue: UInt32) -> UIColor {
        return uicolorFromHex(rgbValue: rgbValue, alpha: 1.0)
    }

    class func uicolorFromHex(rgbValue: UInt32, alpha: CGFloat) -> UIColor {
        let red     = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green   = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue    = CGFloat(rgbValue & 0xFF)/256.0

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    func add(overlay: UIColor) -> UIColor {
        var bgR: CGFloat = 0
        var bgG: CGFloat = 0
        var bgB: CGFloat = 0
        var bgA: CGFloat = 0

        var fgR: CGFloat = 0
        var fgG: CGFloat = 0
        var fgB: CGFloat = 0
        var fgA: CGFloat = 0

        self.getRed(&bgR, green: &bgG, blue: &bgB, alpha: &bgA)
        overlay.getRed(&fgR, green: &fgG, blue: &fgB, alpha: &fgA)

        let r = fgA * fgR + (1 - fgA) * bgR
        let g = fgA * fgG + (1 - fgA) * bgG
        let b = fgA * fgB + (1 - fgA) * bgB

        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }

    static func + (lhs: UIColor, rhs: UIColor) -> UIColor {
        return lhs.add(overlay: rhs)
    }

    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format: "#%06x", rgb) as String
    }
    
    func toColor() -> Color {
        let hex = toHexString()
        return Color(hex: hex)
    }
}
