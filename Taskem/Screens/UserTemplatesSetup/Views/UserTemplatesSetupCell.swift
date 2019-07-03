//
//  UserTemplatesSetupCell.swift
//  Taskem
//
//  Created by Wilson on 12/9/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class UserTemplatesSetupCell: UICollectionViewCell, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var star: UIImageView!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var iconPlaceholder: DesignableView!
    @IBOutlet weak var iconPlaceholderHeight: NSLayoutConstraint!
    @IBOutlet weak var iconPlaceholderWidth: NSLayoutConstraint!
    
    private var isAnimateSelection = true
    private var appTheme: AppTheme = .light
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        observeAppTheme()
        
        resolveShadow(appTheme)
        resolveBorder(appTheme)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        resolveSize()
    }
    
    override var isSelected: Bool {
        didSet {
            animateSelection(isAnimated: isAnimateSelection)
        }
    }
    
    private func animateSelection(isAnimated: Bool = true) {
        if isAnimated {
            let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
                self.resolveSelected(self.isSelected)
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
        
        iconPlaceholder.taskem_cornerRadius = (iconPlaceholderWidth.constant) / 2
    }
    
    private func resolveShadow(_ theme: AppTheme) {
        layer.shadowColor   = isSelected ? theme.cellFrameShadow.cgColor : .none
        layer.shadowRadius  = isSelected ? 10 : 0
        layer.shadowOpacity = isSelected ? 0.5 : 0
    }
    
    private func resolveBorder(_ theme: AppTheme) {
        contentView.taskem_borderWidth = isSelected ? 0 : 1
        contentView.taskem_borderColor = isSelected ? .clear : theme.cellFrame
        
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
    
    func setup(_ viewModel: UserTemplatesSetupViewModel) {
        title.text = viewModel.template.group.name
        star.isHidden = !viewModel.isDefault
        icon.image = viewModel.template.group.icon.image
        iconPlaceholder.backgroundColor = viewModel.template.group.color.uicolor
        
        isAnimateSelection = false
        isSelected = viewModel.isSelected
        isAnimateSelection = true
    }
}
