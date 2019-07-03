//
//  CalendarControlIOSCalendarCell.swift
//  Taskem
//
//  Created by Wilson on 1/26/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class CalendarControlIOSCalendarCell: UICollectionViewCell, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var namePlaceholder: DesignableView!
    @IBOutlet weak var namePlaceholderWidth: NSLayoutConstraint!
    @IBOutlet weak var namePlaceholderHeight: NSLayoutConstraint!
    
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
        namePlaceholderWidth.constant   = frame.height / 2
        namePlaceholderHeight.constant  = frame.height / 2
        
        namePlaceholder.taskem_cornerRadius = namePlaceholderWidth.constant / 2
    }
    
    private func resolveShadow(_ theme: AppTheme) {
        layer.shadowPath    = UIBezierPath(rect: bounds).cgPath
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
    
    func setup(_ viewModel: CalendarControlIOSCalendarModel) {
        title.text = viewModel.calendar.title
        name.text = String.init(viewModel.calendar.title.first ?? .init(""))
        namePlaceholder.backgroundColor = viewModel.calendar.color.uicolor
        
        isSelected = viewModel.isSelected
    }
}
