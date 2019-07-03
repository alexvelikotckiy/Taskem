//
//  RoundButton.swift
//  Taskem
//
//  Created by Wilson on 06.12.2017.
//  Copyright © 2017 Wilson. All rights reserved.
//

import Foundation

@IBDesignable
class RoundButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = ((rect.height + rect.width) / 2) / 2
        self.clipsToBounds = true
    }

}
