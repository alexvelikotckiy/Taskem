//
//  DatePickerTemplatesCell.swift
//  Taskem
//
//  Created by Wilson on 14.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class DatePickerTemplatesCell: UICollectionViewCell, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconPlaceholder: UIView!
    
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var descriptionSubtitle: UILabel!
    @IBOutlet weak var descriptionView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        observeAppTheme()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        iconPlaceholder.taskem_cornerRadius = (iconPlaceholder.frame.width) / 2
    }
    
    func applyTheme(_ theme: AppTheme) {
        title.textColor = theme.secondTitle
    }
    
    private func icon(_ value: Icon) {
        icon.isHidden = false
        descriptionView.isHidden = true
        
        icon.image = value.image
    }
    
    private func description(_ value: DatePickerTemplatesViewModel.Description) {
        icon.isHidden = true
        descriptionView.isHidden = false
        
        descriptionTitle.text = value.title
        descriptionSubtitle.text = value.subtitle
    }
    
    func setup(_ viewModel: DatePickerTemplatesViewModel) {
        
        title.text = viewModel.title
        
        switch viewModel.template {
        case .todaySometime(let value):
            icon(value)
            iconPlaceholder.backgroundColor = Color.TaskemMain.blue
            
        case .todayNearest(let value, _):
            icon(value)
            iconPlaceholder.backgroundColor = Color.TaskemMain.blue
            
        case .tomorrow(let value):
            description(value)
            iconPlaceholder.backgroundColor = Color.TaskemMain.yellow
            
        case .weekend(let value):
            description(value)
            iconPlaceholder.backgroundColor = Color.TaskemMain.redLight
            
        case .monday(let value):
            description(value)
            iconPlaceholder.backgroundColor = Color.TaskemMain.purple
            
        case .undefined(let value):
            icon(value)
            iconPlaceholder.backgroundColor = Color.TaskemMain.blue
            
        case .custom(let value):
            icon(value)
            iconPlaceholder.backgroundColor = Color.TaskemMain.blue
        }
    }
}
