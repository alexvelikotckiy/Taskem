//
//  SettingsTimePickerTableCell.swift
//  Taskem
//
//  Created by Wilson on 8/14/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class SettingsTimePickerTableCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBAction func onChangeTime(_ sender: Any) {
        onChangeTime?(self)
    }
    
    var onChangeTime: ((SettingsTimePickerTableCell) -> Void)?
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        let theme = AppTheme.current
        
        backgroundColor             = highlighted ? theme.cellHighlight : theme.background
        contentView.backgroundColor = highlighted ? theme.cellHighlight : theme.background
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        observeAppTheme()
    }

    func applyTheme(_ theme: AppTheme) {
        backgroundColor                 = theme.background
        contentView.backgroundColor     = theme.background
        tintColor                       = theme.secondTitle
        title.textColor                 = theme.secondTitle
        icon.tintColor                  = theme.iconTint
        timePicker.setValue(theme.secondTitle, forKey: "textColor")
    }
    
    func setup(_ model: SettingsTimeViewModel) {
        title.text = model.title
        icon.image = model.icon.image
        timePicker.minimumDate = model.minTime.date()
        timePicker.maximumDate = model.maxTime.date()
        timePicker.setDate(model.time.date(), animated: false)
    }
}
