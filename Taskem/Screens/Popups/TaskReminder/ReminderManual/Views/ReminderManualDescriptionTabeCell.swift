//
//  ReminderManualDescriptionTabeCell.swift
//  Taskem
//
//  Created by Wilson on 9/4/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class ReminderManualDescriptionTabeCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        observeAppTheme()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func applyTheme(_ theme: AppTheme) {
        backgroundColor             = theme.background
        contentView.backgroundColor = theme.background
        title.textColor             = theme.secondTitle
        time.textColor              = theme.secondTitle
    }
    
    public func setup(_ model: ReminderManualDescriptionViewModel) {
        time.text = model.time
    }
}
