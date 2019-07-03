//
//  CompletedHeaderView.swift
//  Taskem
//
//  Created by Wilson on 1/26/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class CompletedHeaderView: UITableViewHeaderFooterView, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        observeAppTheme()
    }
    
    func applyTheme(_ theme: AppTheme) {
        title.textColor = theme.firstTitle
        contentView.backgroundColor = .clear
    }
}
