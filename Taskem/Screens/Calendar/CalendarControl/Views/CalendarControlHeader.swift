//
//  CalendarControlHeader.swift
//  Taskem
//
//  Created by Wilson on 1/26/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class CalendarControlHeader: UICollectionReusableView, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var separator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        observeAppTheme()
    }
    
    func applyTheme(_ theme: AppTheme) {
        title.textColor             = theme.firstTitle
        separator.backgroundColor   = theme.cellFrame
    }
}
