//
//  GroupOverviewCreationCell.swift
//  Taskem
//
//  Created by Wilson on 1/6/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class GroupOverviewCreationCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
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
        subtitle.textColor              = theme.fifthTitle
    }
    
    func setup(_ title: String) {
        self.title.text = title
    }
}
