//
//  CalendarExtendedTableHeader.swift
//  Taskem
//
//  Created by Wilson on 7/18/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class CalendarExtendedTableHeader: UITableViewHeaderFooterView, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var separatorFirst: UIView!
    @IBOutlet weak var separatorSecond: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        observeAppTheme()
    }
    
    func applyTheme(_ theme: AppTheme) {
        contentView.backgroundColor     = theme.background
        title.textColor                 = theme.firstTitle
        separatorFirst.backgroundColor  = theme.separatorThird
        separatorSecond.backgroundColor = theme.separatorThird
    }
}
