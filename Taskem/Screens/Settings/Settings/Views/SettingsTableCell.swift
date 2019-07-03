//
//  SettingsTableCell.swift
//  Taskem
//
//  Created by Wilson on 4/5/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class SettingsTableCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptions: UILabel!

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
        tintColor                       = theme.secondTitle
        title.textColor                 = theme.secondTitle
        descriptions.textColor          = theme.secondTitle
        icon.tintColor                  = theme.iconTint
    }
    
    func setup(_ model: SettingsSimpleViewModel) {
        title.text = model.title
        descriptions.text = model.description
        icon.image = model.icon.image

        switch model.accessory {
        case .none:
            accessoryType = .none
        case .present:
            accessoryType = .disclosureIndicator
        case .checked:
            accessoryType = .checkmark
        }
    }
    
    func setup(_ model: SettingsTimeViewModel) {
        title.text = model.title
        icon.image = model.icon.image
        descriptions.text = model.description
        accessoryType = .none
    }
}
