//
//  BorderRoundButton.swift
//  Taskem
//
//  Created by Wilson on 08.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

@IBDesignable
class BorderRoundButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = bounds.size.height / 2
    }
}
