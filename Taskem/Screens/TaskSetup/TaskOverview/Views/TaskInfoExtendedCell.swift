//
//  TaskRepeatTableViewCell.swift
//  Taskem
//
//  Created by Wilson on 15.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class TaskInfoExtendedCell: UITableViewCell, ThemeObservable {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var descriptions: UILabel!

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var remove: UIButton!

    @IBAction func touchRemove(_ sender: Any) {
        onRemove?(self)
    }

    var onRemove: ((_ cell: TaskInfoExtendedCell) -> Void)?

    private var removable = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        observeAppTheme()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.remove.isHidden = !(editing && self.removable)
        }
        animator.startAnimation()
    }
    
    func applyTheme(_ theme: AppTheme) {
        backgroundColor             = .clear
        contentView.backgroundColor = .clear
        
        title.textColor             = theme.secondTitle
        subtitle.textColor          = theme.fifthTitle
        descriptions.textColor      = theme.fifthTitle
        icon.tintColor              = theme.iconTint
    }
    
    func setup(_ viewModel: TaskOverviewViewModel.DateAndTime) {
        title.text = viewModel.title
        subtitle.text = viewModel.subtitle
        icon.image = viewModel.icon.image
        descriptions.text = viewModel.description
        descriptions.isHidden = viewModel.description == nil
        removable = viewModel.removable
        remove.isHidden = !(isEditing && removable)
        
        subtitle.letterSpace = 1.5
    }
    
    func setup(_ viewModel: TaskOverviewViewModel.Repeat) {
        title.text = viewModel.title
        subtitle.text = viewModel.subtitle
        icon.image = viewModel.icon.image
        descriptions.text = viewModel.description
        descriptions.isHidden = viewModel.description == nil
        removable = viewModel.removable
        remove.isHidden = !(isEditing && removable)
        
        subtitle.letterSpace = 1.5
    }
}
