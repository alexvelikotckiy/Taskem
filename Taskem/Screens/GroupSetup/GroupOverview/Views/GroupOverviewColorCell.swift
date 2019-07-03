//
//  GroupOverviewColorCell.swift
//  Taskem
//
//  Created by Wilson on 3/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class GroupOverviewColorCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var colorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        observeAppTheme()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        colorView.taskem_cornerRadius = colorView.frame.height / 2
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        title.fadeTransition(0.3)
        title.text = editing ? "Set a color" : "List color"
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
    
    func setup(_ color: Color) {
        colorView.backgroundColor = color.uicolor
    }
}
