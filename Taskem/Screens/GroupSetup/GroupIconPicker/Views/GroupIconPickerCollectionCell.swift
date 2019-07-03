//
//  GroupIconPickerCollectionCell.swift
//  Taskem
//
//  Created by Wilson on 3/31/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class GroupIconPickerCollectionCell: UICollectionViewCell, ThemeObservable {

    @IBOutlet weak var icon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        observeAppTheme()
        
        icon.layer.shadowRadius  = 2
        icon.layer.shadowOpacity = 0.5
    }
    
    override var isHighlighted: Bool {
        didSet {
            contentView.transform = isHighlighted ? .init(scaleX: 1.03, y: 1.03) : .identity
        }
    }
    
    func applyTheme(_ theme: AppTheme) {
        contentView.backgroundColor = theme.background
        icon.tintColor              = theme.iconTint
    }

    func setup(_ model: GroupIconPickerViewModel) {
        icon.image = model.icon.image?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = model.selected ? AppTheme.current.iconTint : AppTheme.current.iconTintUnhighlightedTint
        icon.layer.shadowColor = icon.tintColor.cgColor
        contentView.transform = model.selected ? .init(scaleX: 1.03, y: 1.03) : .identity
    }
}
