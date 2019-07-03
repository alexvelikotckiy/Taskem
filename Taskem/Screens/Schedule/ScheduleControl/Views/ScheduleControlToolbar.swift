//
//  ToolbarExtended.swift
//  Taskem
//
//  Created by Wilson on 10/6/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

class ScheduleControlToolbar: UIToolbar {
    
    private let heightAdjustment = UIApplication.shared.statusBarFrame.height
    
    private let uiToolbarContentView = "UIToolbarContentView"
    private let uiButtonBarStackView = "UIButtonBarStackView"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentStack?.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: heightAdjustment, right: 0)
    }
    
    private var contentStack: UIView? {
        for subview in self.subviews where String(describing: type(of: subview)).contains(uiToolbarContentView) {
            for subview in subview.subviews where String(describing: type(of: subview)).contains(uiButtonBarStackView) {
                return subview
            }
        }
        return nil
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height += heightAdjustment
        return size
    }
}
