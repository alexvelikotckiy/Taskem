//
//  NotificationSoundPickerTableCell.swift
//  Taskem
//
//  Created by Wilson on 4/7/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class NotificationSoundPickerTableCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        observeAppTheme()
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        let theme = AppTheme.current
        
        backgroundColor             = highlighted ? theme.cellHighlight : theme.background
        contentView.backgroundColor = highlighted ? theme.cellHighlight : theme.background
    }
    
    func applyTheme(_ theme: AppTheme) {
        tintColor                       = theme.iconHighlightedTint
        title.textColor                 = theme.secondTitle
    }

    func setup(_ model: NotificationSoundPickerViewModel) {
        title.text = model.sound.name
        accessoryType = model.selected ? .checkmark : .none
    }
}
