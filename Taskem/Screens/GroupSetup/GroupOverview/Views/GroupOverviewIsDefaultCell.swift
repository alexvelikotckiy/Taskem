//
//  GroupOverviewIsDefaultCell.swift
//  Taskem
//
//  Created by Wilson on 3/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class GroupOverviewIsDefaultCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var switcher: UISwitch!

    @IBAction func changedSwitch(_ sender: UISwitch) {
        switcher.isEnabled = !sender.isOn
        onSwitch?(sender.isOn)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        observeAppTheme()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        title.fadeTransition(0.3)
        title.text = editing ? "Set as default" : "List is not default"
        
        switcher.fadeTransition(0.3)
        if editing {
            if switcher.isOn {
                title.text = "List is default"
                switcher.isEnabled = false
            } else {
                switcher.isEnabled = true
            }
        } else {
            switcher.isEnabled = false
        }
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
    
    var onSwitch: ((_ isOn: Bool) -> Void)?

    func setup(_ isOn: Bool) {
        switcher.isOn = isOn
        switcher.isEnabled = !isOn
    }
}
