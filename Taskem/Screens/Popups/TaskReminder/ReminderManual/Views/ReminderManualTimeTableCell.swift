//
//  ReminderManualTimeTableCell.swift
//  Taskem
//
//  Created by Wilson on 9/4/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class ReminderManualTimeTableCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBAction func onChangeTime(_ sender: UIDatePicker) {
        onTimeCange?(sender.date)
    }
    
    public var onTimeCange: ((Date) -> Void)?
    
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
        
        timePicker.setValue(theme.secondTitle, forKey: "textColor")
    }
    
    public func setup(_ model: ReminderManualTimePickerViewModel) {
        timePicker.date = model.date
    }
}
