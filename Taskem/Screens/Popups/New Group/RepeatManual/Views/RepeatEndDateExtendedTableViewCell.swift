//
//  RepeatEndDateExtendedTableViewCell.swift
//  Taskem
//
//  Created by Wilson on 09.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class RepeatEndDateExtendedTableViewCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var endDateSubtitle: UILabel!
    
    @IBOutlet weak var removeButton: UIButton!

    @IBOutlet weak var datePicker: UIDatePicker!

    @IBAction func touchRemoveDate(_ sender: Any) {
        removeEndDate?()
    }

    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        endDateChanged?(sender.date)
    }

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
        backgroundColor                 = theme.background
        contentView.backgroundColor     = theme.background
        tintColor                       = theme.secondTitle
        title.textColor                 = theme.secondTitle
        endDate.textColor               = theme.secondTitle
        endDateSubtitle.textColor       = theme.secondTitle
        datePicker.setValue(theme.secondTitle, forKey: "textColor")
    }
    
    var removeEndDate: (() -> Void)?
    var endDateChanged: ((_ date: Date) -> Void)?
    
    func setup(_ viewModel: RepeatEndDateData) {
        if let date = viewModel.date {
            datePicker.setDate(date, animated: false)
            
            let theme = AppTheme.current
            if date < Date.now {
                endDate.textColor               = theme.redTitle
                endDateSubtitle.textColor       = theme.redTitle
            } else {
                endDate.textColor               = theme.secondTitle
                endDateSubtitle.textColor       = theme.secondTitle
            }
        } else {
            datePicker.setDate(Date.now, animated: true)
        }
        endDate.text = viewModel.dateTitle
        endDateSubtitle.text = viewModel.dateSubtitle
        removeButton.isHidden = viewModel.date == nil
    }
}
