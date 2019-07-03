//
//  ScheduleControlGroupCell.swift
//  Taskem
//
//  Created by Wilson on 8/10/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class ScheduleControlGroupCell: UICollectionViewCell, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconPlaceholder: DesignableView!
    @IBOutlet weak var iconPlaceholderWidth: NSLayoutConstraint!
    @IBOutlet weak var iconPlaceholderHeight: NSLayoutConstraint!
    
    @IBOutlet weak var star: UIImageView!
    
    @IBOutlet weak var badge: UIView!
    @IBOutlet weak var badgeContent: UIButton!
    @IBOutlet weak var badgeHeight: NSLayoutConstraint!
    
    @IBOutlet weak var content: UIView!
    
    private var isAnimateSelection = true
    private var appTheme: AppTheme = .light
    private var isEditing: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        observeAppTheme()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        resolveSize()
        
        layer.shadowPath                 = UIBezierPath(rect: bounds).cgPath
        badgeContent.layer.shadowPath    = UIBezierPath(rect: badgeContent.bounds).cgPath
    }
    
    override var isHighlighted: Bool {
        didSet {
            animateSelection(isSelected: isHighlighted, isAnimated: isAnimateSelection)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            animateSelection(isSelected: isSelected, isAnimated: isAnimateSelection)
        }
    }
    
    private func animateSelection(isSelected: Bool, isAnimated: Bool = true) {
        if isAnimated {
            let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
                self.resolveSelected(isSelected)
            }
            animator.startAnimation()
        } else {
            resolveSelected(isSelected)
        }
    }
    
    private func resolveSelected(_ isSelected: Bool) {
        contentView.transform = isSelected ? .init(scaleX: 1.03, y: 1.03) : .identity
        resolveShadow(appTheme)
        resolveBorder(appTheme)
    }
    
    private func resolveSize() {
        iconPlaceholderWidth.constant   = frame.height / 2
        iconPlaceholderHeight.constant  = frame.height / 2
        
        iconPlaceholder.taskem_cornerRadius = iconPlaceholderWidth.constant / 2
        
        badge.taskem_cornerRadius = badgeHeight.constant / 2
    }
    
    private func resolveShadow(_ theme: AppTheme) {
        layer.shadowColor   = isSelected ? theme.cellFrameShadow.cgColor : .none
        layer.shadowRadius  = isSelected ? 10 : 0
        layer.shadowOpacity = isSelected ? 0.5 : 0
        
        badgeContent.layer.shadowRadius  = 5
        badgeContent.layer.shadowOpacity = 0.5
        badgeContent.layer.shadowColor   = isEditing ? theme.badgeHighlighted.cgColor : theme.badge.cgColor
    }
    
    private func resolveBorder(_ theme: AppTheme) {
        content.taskem_borderWidth = isSelected ? 0 : 1
        content.taskem_borderColor = isSelected ? .clear : theme.cellFrame
        
        switch theme {
        case .light:
            contentView.backgroundColor = .white
            
        case .dark:
            contentView.backgroundColor = isSelected ? theme.cellFrame : .clear
        }
    }
    
    func applyTheme(_ theme: AppTheme) {
        appTheme = theme
        
        contentView.backgroundColor = theme.background
        title.textColor             = theme.secondTitle
        
        resolveBorder(theme)
        resolveShadow(theme)
    }
    
    func setup(_ viewModel: ScheduleControlViewModel, editing: Bool) {
        title.text = viewModel.group.name
        star.isHidden = !viewModel.group.isDefault
        icon.image = viewModel.group.icon.image
        iconPlaceholder.backgroundColor = viewModel.group.color.uicolor
        
        badgeContent.setImage(nil, for: .normal)
        badgeContent.setTitle(nil, for: .normal)
        if editing {
            badge.isHidden = false
            badge.backgroundColor = appTheme.badgeHighlighted
            badge.taskem_shadowColor = appTheme.badgeHighlighted
            badgeContent.setImage(Icons.icBadgeEdit.image, for: .normal)
        } else {
            if viewModel.uncompletedCount > 0 {
                badge.isHidden = false
                badge.backgroundColor = appTheme.badge
                badge.taskem_shadowColor = appTheme.badge
                badgeContent.setTitle("\(viewModel.uncompletedCount)", for: .normal)
            } else {
                badge.isHidden = true
            }
        }
        
//        isAnimateSelection = false
        isSelected = editing ? false : viewModel.isSelected
//        isAnimateSelection = true
        isEditing = editing
    }
}
