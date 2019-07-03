//
//  CalendarFreedayTableCell.swift
//  Taskem
//
//  Created by Wilson on 1/26/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class CalendarFreedayTableCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconPlaceholder: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        observeAppTheme()
    }
    
    func applyTheme(_ theme: AppTheme) {
        title.textColor           = theme.firstTitle
        subtitle.textColor        = theme.secondTitle
        iconPlaceholder.tintColor = theme.iconPlaceholder
        
        switch theme {
        case .light:
            icon.image = Icons.icFreeDayLight.image
            
        case .dark:
            icon.image = Icons.icFreeDayDark.image
        }
    }
}
