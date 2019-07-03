//
//  ScheduleNavigationBarCell.swift
//  Taskem
//
//  Created by Wilson on 12/31/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class ScheduleNavigationBarCell: XibFileView {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var data: ScheduleNavbarCell
    
    public var id: EntityId {
        return data.id
    }
    
    public static let size: CGFloat = 40
    
    public init(data: ScheduleNavbarCell) {
        self.data = data
        super.init(frame: .zero)
        
        reload(data: data)
        
        setupUI()
    }
    
    public func reload(data: ScheduleNavbarCell) {        
        self.data = data
        
        icon.image = UIImage(icon: data.icon)
        contentView.backgroundColor = data.color.uicolor
        
        resolveShadow(color: data.color)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        contentView.taskem_cornerRadius = rect.height / 2
        contentView.layer.shadowPath    = UIBezierPath(roundedRect: rect, cornerRadius: rect.height / 2).cgPath
        
        setNeedsLayout()
    }
    
    private func setupUI() {
        removeSuperConstraints()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let height = heightAnchor.constraint(equalToConstant: ScheduleNavigationBarCell.size)
        height.priority = UILayoutPriority(rawValue: 999)
        height.isActive = true
        
        let width = widthAnchor.constraint(equalToConstant: ScheduleNavigationBarCell.size)
        width.priority = UILayoutPriority(rawValue: 999)
        width.isActive = true
    }
    
    private func resolveShadow(color: Color) {
        contentView.layer.shadowColor   = color.uicolor.cgColor
        contentView.layer.shadowRadius  = 3
        contentView.layer.shadowOpacity = 0.5
    }
    
    private func removeSuperConstraints() {
        guard let superview = superview else { return }
        
        for constraint in superview.constraints{
            if let firstItem = constraint.firstItem, firstItem === self {
                superview.removeConstraint(constraint)
            }
            if let secondItem = constraint.secondItem, secondItem === self {
                superview.removeConstraint(constraint)
            }
        }
    }
}
