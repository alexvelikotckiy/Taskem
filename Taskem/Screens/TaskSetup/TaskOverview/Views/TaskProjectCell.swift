//
//  TaskProjectCell.swift
//  Taskem
//
//  Created by Wilson on 1/15/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class TaskProjectCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var listIconPlaceholder: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        observeAppTheme()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        listIconPlaceholder.taskem_cornerRadius = listIconPlaceholder.frame.height / 2
    }
    
    func applyTheme(_ theme: AppTheme) {
        backgroundColor             = .clear
        contentView.backgroundColor = .clear
        
        title.textColor             = theme.secondTitle
        subtitle.textColor          = theme.fifthTitle
    }
    
    func setup(_ viewModel: TaskOverviewViewModel.Project) {
        title.text = viewModel.title
        subtitle.text = viewModel.subtitle
        listIcon.image = viewModel.listIcon.image
        listIconPlaceholder.backgroundColor = viewModel.color.uicolor
        
        subtitle.letterSpace = 1.5
    }
}
