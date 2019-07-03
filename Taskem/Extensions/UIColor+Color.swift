//
//  UIColor+Color.swift
//  Taskem
//
//  Created by Wilson on 15.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

extension UIColor {

    convenience init(color clr: Color) {
        let r = CGFloat(clr.red) / 255
        let g = CGFloat(clr.green) / 255
        let b = CGFloat(clr.blue) / 255
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }

    convenience init(red: UInt8, green: UInt8, blue: UInt8) {
        let r = CGFloat(red) / 255
        let g = CGFloat(green) / 255
        let b = CGFloat(blue) / 255
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }

}

extension Color {
    var uicolor: UIColor {
        return UIColor(color: self)
    }
}
