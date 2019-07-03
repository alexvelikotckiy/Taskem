//
//  ScheduleTableViewHeader.swift
//  Taskem
//
//  Created by Wilson on 11.11.2017.
//  Copyright © 2017 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class ScheduleTableViewHeader: UITableViewHeaderFooterView, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var expand: UIButton!
    @IBOutlet weak var action: UIButton!
    @IBOutlet weak var chevron: UIButton!
    
    @IBAction func onTouchToogle(_ sender: Any) {
        onToogle?(self)
    }
    
    @IBAction func onTouchAction(_ sender: Any) {
        onAction?(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        observeAppTheme()
        
        action.imageView?.contentMode = .scaleAspectFit
    }
    
    var onToogle: ((ScheduleTableViewHeader) -> Void)?
    var onAction: ((ScheduleTableViewHeader) -> Void)?
    
    var type: ScheduleSectionType!
    
    func applyTheme(_ theme: AppTheme) {
        contentView.backgroundColor     = theme.background
        tintColor                       = theme.iconTint
        title.textColor                 = theme.firstTitle
        action.titleLabel?.textColor    = theme.firstTitle
    }
    
    private func setupWithAction(with model: ScheduleSectionViewModel) {
        title.text = model.title
        action.setTitle(nil, for: .normal)
        action.setImage(Icon(name: model.actionType.icon).image, for: .normal)
        action.isEnabled = true
    }

    private func setupWithoutAction(with model: ScheduleSectionViewModel) {
        title.text = model.title
        action.setImage(nil, for: .normal)
        action.setTitle("\(model.headerCellsCount)", for: .normal)
        action.isEnabled = false
    }

    func setup(_ model: ScheduleSectionViewModel, isEditing: Bool, isSearching: Bool) {
        type = model.type
        
        if isEditing || isSearching {
            setupWithoutAction(with: model)
            chevron.isHidden = true
        } else {
            if model.isExpanded {
                setupWithAction(with: model)
            } else {
                setupWithoutAction(with: model)
            }
            chevron.isHidden = false
        }
        
        chevron.setImage(model.isExpanded ? Icons.icScheduleChevron.image : Icons.icScheduleChevronUp.image, for: .normal)
    }
}
