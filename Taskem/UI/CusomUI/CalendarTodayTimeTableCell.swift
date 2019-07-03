//
//  CalendarTodayTimeTableCell.swift
//  Taskem
//
//  Created by Wilson on 4/11/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class CalendarTodayTimeTableCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var topPadding: NSLayoutConstraint!
    @IBOutlet weak var bottomPadding: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        observeAppTheme()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var totalHeight: CGFloat = 0
        totalHeight += time.sizeThatFits(size).height
        totalHeight += topPadding.constant
        totalHeight += bottomPadding.constant
        return CGSize(width: size.width, height: totalHeight)
    }
    
    func applyTheme(_ theme: AppTheme) {
        backgroundColor                  = isSelected ? theme.cellSelection : theme.background
        contentView.backgroundColor      = isSelected ? theme.cellSelection : theme.background
    }
}
