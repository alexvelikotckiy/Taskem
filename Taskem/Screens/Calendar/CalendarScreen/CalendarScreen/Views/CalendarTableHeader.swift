//
//  CalendarTableHeader.swift
//  Taskem
//
//  Created by Wilson on 4/14/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class CalendarTableHeader: UITableViewHeaderFooterView, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!

    @IBOutlet weak var separatorFirst: UIView!
    @IBOutlet weak var separatorSecond: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        observeAppTheme()
    }

    func applyTheme(_ theme: AppTheme) {
        contentView.backgroundColor     = theme.background
        title.textColor                 = theme.firstTitle
        subtitle.textColor              = theme.cellSubtitle
        separatorFirst.backgroundColor  = theme.separatorThird
        separatorSecond.backgroundColor = theme.separatorThird
    }
}
