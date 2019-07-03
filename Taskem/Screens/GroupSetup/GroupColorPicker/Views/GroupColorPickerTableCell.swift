//
//  GroupColorPickerTableCell.swift
//  Taskem
//
//  Created by Wilson on 3/31/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class GroupColorPickerTableCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var chevron: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        observeAppTheme()
        
        resolveShadow()
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
        chevron.tintColor               = theme.iconTint
    }
    
    private func resolveShadow() {
        colorView.layer.shadowRadius  = 5
        colorView.layer.shadowOpacity = 0.5
    }
    
    func setup(_ model: GroupColorPickerViewModel) {
        colorView.layer.shadowColor = model.color.uicolor.cgColor
        colorView.backgroundColor = model.color.uicolor
        chevron.isHidden = !model.selected
    }
}
