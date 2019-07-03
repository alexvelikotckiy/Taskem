//
//  ScheduleTableViewCell.swift
//  Taskem
//
//  Created by Wilson on 11.11.2017.
//  Copyright © 2017 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class TaskTableCell: MCSwipeTableViewCell, ThemeObservable {

    @IBOutlet weak var checkbox: Checkbox!
    @IBOutlet weak var checkboxWrapper: UIButton!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var repeatIcon: UIImageView!
    @IBOutlet weak var reminderIcon: UIImageView!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconPlaceholder: UIView!
    
    @IBOutlet weak var topPadding: NSLayoutConstraint!
    @IBOutlet weak var bottomPadding: NSLayoutConstraint!

    @IBAction func touchCheckboxWrapper(_ sender: Any) {
        checkbox.isChecked.toogle()
        onTouchCheckbox?(self)
    }

    var onTouchCheckbox: ((TaskTableCell) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        observeAppTheme()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let theme = AppTheme.current
        
        backgroundColor             = selected ? theme.cellSelection : theme.background
        contentView.backgroundColor = selected ? theme.cellSelection : theme.background
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var totalHeight: CGFloat = 5
        totalHeight += self.title.sizeThatFits(size).height
        totalHeight += self.date.sizeThatFits(size).height
        totalHeight += self.topPadding.constant
        totalHeight += self.bottomPadding.constant
        return .init(width: size.width, height: totalHeight)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        iconPlaceholder.taskem_cornerRadius = iconPlaceholder.frame.height / 2
    }
    
    private func setupSwipe(_ theme: AppTheme) {
        defaultColor = theme.background
        shouldAnimateIcons = true
    }
    
    private func setupCheckbox(_ theme: AppTheme) {
        checkbox.checkmarkStyle = .circle
        checkbox.borderStyle = .circle
        
        checkbox.layer.shadowRadius  = 4
        checkbox.layer.shadowOpacity = 0.3
    }
    
    private func refreshCheckbox(color: Color) {
        checkbox.layer.shadowColor = color.uicolor.cgColor
        checkbox.checkmarkColor = color.uicolor
        checkbox.uncheckedBorderColor = color.uicolor
        checkbox.checkedBorderColor = color.uicolor
        checkbox.setNeedsLayout()
    }
    
    func applyTheme(_ theme: AppTheme) {
        setupSwipe(theme)
        setupCheckbox(theme)
        
        backgroundColor                  = isSelected ? theme.cellSelection : theme.background
        contentView.backgroundColor      = isSelected ? theme.cellSelection : theme.background
        title.textColor                  = theme.secondTitle
        date.textColor                   = theme.cellSubtitle
        checkbox.backgroundColor         = .clear
        checkbox.checkboxBackgroundColor = .clear
        tintColor                        = theme.iconTint
    }

    private var strikethroughTitleAttribute: [NSAttributedString.Key : Any] = [
        .strikethroughStyle: NSUnderlineStyle.single.rawValue,
        .strikethroughColor: AppTheme.current.secondTitle
    ]
    
    private var strikethroughSubtitleAttribute: [NSAttributedString.Key : Any] = [
        .strikethroughStyle: NSUnderlineStyle.single.rawValue,
        .strikethroughColor: AppTheme.current.cellSubtitle
    ]
    
    private func refreshPresentation(_ presentation: Presentation) {
        switch presentation {
        case .normal:
            subviews.forEach { $0.alpha = 1 }

        case .translucent:
            subviews.forEach { $0.alpha = 1 }

        case .strikethrough:
            title.attributedText = NSAttributedString(string: title.attributedText?.string ?? "", attributes: strikethroughTitleAttribute)
            date.attributedText = NSAttributedString(string: date.attributedText?.string ?? "", attributes: strikethroughSubtitleAttribute)
            subviews.forEach { $0.alpha = 1 }
        }
    }
    
    func setup(_ model: TaskModel) {
        title.attributedText = NSAttributedString(string: model.name)
        checkbox.isChecked = model.isComplete
        icon.image = model.group.icon.image
        iconPlaceholder.backgroundColor = model.projectColor.uicolor
        date.attributedText = NSAttributedString(string: model.dateFormatted ?? "")
        date.isHidden = date.text == nil
        repeatIcon.isHidden = !model.task.repeatPreferences.isOn
        reminderIcon.isHidden = !model.task.reminder.isOn
        
        refreshCheckbox(color: model.color)
        refreshPresentation(.init(from: model.status))
    }
}

private extension TaskTableCell {
    enum Presentation: Int {
        case normal = 0
        case translucent
        case strikethrough
        
        init(from status: ScheduleSection) {
            switch status {
            case .complete:
                self = .strikethrough
            case .overdue:
                self = .translucent
            default:
                self = .normal
            }
        }
    }
}
