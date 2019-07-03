//
//  TaskReminderTemplateCell.swift
//  Taskem
//
//  Created by Wilson on 14.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class ReminderTemplateCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconPlaceholder: UIView!
    @IBOutlet weak var iconPlaceholderWidth: NSLayoutConstraint!
    @IBOutlet weak var iconPlaceholderHeight: NSLayoutConstraint!
    
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        iconPlaceholder.taskem_cornerRadius = iconPlaceholderWidth.constant / 2
    }
    
    func applyTheme(_ theme: AppTheme) {
        backgroundColor                 = theme.background
        contentView.backgroundColor     = theme.background
        tintColor                       = theme.secondTitle
        title.textColor                 = theme.secondTitle
        icon.tintColor                  = theme.whiteTitle
        iconPlaceholder.backgroundColor = theme.iconTintBlue
    }

    func setup(_ viewModel: ReminderTemplatesViewModel) {
        title.text = viewModel.title
        icon.image = viewModel.icon.image
        
        switch viewModel.model {
        case .customUsingDayTime:
            accessoryType = .disclosureIndicator
        default:
            accessoryType = .none
        }
    }
}
