//
//  GroupOverviewIconCell.swift
//  Taskem
//
//  Created by Wilson on 3/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class GroupOverviewIconCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var icon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        observeAppTheme()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        title.fadeTransition(0.3)
        title.text = editing ? "Set an icon" : "List icon"
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
        subtitle.textColor              = theme.fifthTitle
        icon.tintColor                  = theme.iconTint
    }
    
    func setup(_ icon: Icon) {
        self.icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
    }
}
