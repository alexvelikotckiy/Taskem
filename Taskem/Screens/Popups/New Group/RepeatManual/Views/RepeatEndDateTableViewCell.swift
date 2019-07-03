//
//  RepeatEndDateTableViewCell.swift
//  Taskem
//
//  Created by Wilson on 08.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class RepeatEndDateTableViewCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var endDateSubtitle: UILabel!
    
    @IBOutlet weak var removeButton: UIButton!

    @IBAction func touchRemoveDate(_ sender: Any) {
        removeEndDate?()
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
    }
    
    var removeEndDate: (() -> Void)?
    
    func setup(_ viewModel: RepeatEndDateData) {
        if let date = viewModel.date {
            let theme = AppTheme.current
            if date < Date.now {
                endDate.textColor               = theme.redTitle
                endDateSubtitle.textColor       = theme.redTitle
            } else {
                endDate.textColor               = theme.secondTitle
                endDateSubtitle.textColor       = theme.secondTitle
            }
        }
        endDate.text = viewModel.dateTitle
        endDateSubtitle.text = viewModel.dateSubtitle
        removeButton.isHidden = viewModel.date == nil
    }
}
