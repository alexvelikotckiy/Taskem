//
//  CalendarEventTableCell.swift
//  Taskem
//
//  Created by Wilson on 4/14/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class CalendarEventTableCell: UITableViewCell, ThemeObservable {
    @IBOutlet weak var checkbox: Checkbox!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var end: UILabel!
    
    @IBOutlet weak var topPadding: NSLayoutConstraint!
    @IBOutlet weak var bottomPadding: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkbox.isChecked = true
        
        observeAppTheme()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let theme = AppTheme.current
        
        backgroundColor             = selected ? theme.cellSelection : theme.background
        contentView.backgroundColor = selected ? theme.cellSelection : theme.background
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var totalHeight: CGFloat = 0
        totalHeight += title.sizeThatFits(size).height
        totalHeight += subtitle.sizeThatFits(size).height
        totalHeight += topPadding.constant
        totalHeight += bottomPadding.constant
        return CGSize(width: size.width, height: totalHeight)
    }
    
    func applyTheme(_ theme: AppTheme) {
        backgroundColor                  = isSelected ? theme.cellSelection : theme.background
        contentView.backgroundColor      = isSelected ? theme.cellSelection : theme.background
        title.textColor                  = theme.secondTitle
        subtitle.textColor               = theme.cellSubtitle
        start.textColor                  = theme.cellSubtitle
        end.textColor                    = theme.cellSubtitle
        checkbox.backgroundColor         = .clear
        checkbox.checkboxBackgroundColor = .clear
        tintColor                        = theme.iconTint
    }
    
    private func refreshCheckbox(color: Color) {
        checkbox.checkmarkStyle = .circle
        checkbox.borderStyle = .circle
        checkbox.layer.shadowRadius  = 4
        checkbox.layer.shadowOpacity = 0.3
        checkbox.layer.shadowColor = color.uicolor.cgColor
        checkbox.checkmarkColor = color.uicolor
        checkbox.uncheckedBorderColor = color.uicolor
        checkbox.checkedBorderColor = .clear
        checkbox.setNeedsLayout()
    }
    
    func setup(_ model: EventModel) {
        title.text = model.name
        subtitle.text = model.calendarName
        
        switch true {
        case model.isAllDay:
            start.isHidden = true
            end.isHidden = true
            
        case model.isSingleDayEvent:
            start.text = model.startTimeFormatted
            end.text = model.endTimeFormatted
            
            end.isHidden = false
            start.isHidden = false
        default:
            start.text = model.startTimeFormatted
            
            end.isHidden = true
            start.isHidden = false
        }
        
        refreshCheckbox(color: model.color)
    }
}
