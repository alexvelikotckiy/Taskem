//
//  UserProfileTableCell.swift
//  Taskem
//
//  Created by Wilson on 7/26/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class UserProfileTableCell: UITableViewCell, ThemeObservable {

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
    
    func setup(_ model: UserProfileViewModel) {
        title.text = model.title
        icon.image = model.icon.image
        descriptions.text = model.description
        
        switch model.accessory {
        case .none:
            accessoryType = .none
        case .present:
            accessoryType = .disclosureIndicator
        case .checked:
            accessoryType = .checkmark
        }
    }
}
