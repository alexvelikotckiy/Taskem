//
//  RoundView.swift
//  Taskem
//
//  Created by Wilson on 08.12.2017.
//  Copyright © 2017 Wilson. All rights reserved.
//

import Foundation

@IBDesignable
class RoundView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = ((rect.height + rect.width) / 2) / 2
        self.clipsToBounds = true
    }

}
