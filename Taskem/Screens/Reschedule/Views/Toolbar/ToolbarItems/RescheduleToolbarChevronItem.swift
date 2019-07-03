//
//  RescheduleToolbarChevronItem.swift
//  Taskem
//
//  Created by Wilson on 1/19/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class RescheduleToolbarChevronItem: XibFileView, ThemeObservable {
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func onTouch(_ sender: UIButton) {
        onSelect?(direction)
    }
    
    var onSelect: ((Direction) -> Void)?
    
    private var direction: Direction
    
    init(direction: Direction) {
        self.direction = direction
        super.init(frame: .zero)
        
        switch direction {
        case .left:
            button.setImage(Icons.icRescheduleChevronLeft.image, for: .normal)
        case .right:
            button.setImage(Icons.icRescheduleChevronRight.image, for: .normal)
        }
        button.isExclusiveTouch = true
        
        observeAppTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyTheme(_ theme: AppTheme) {
        button.tintColor = theme.iconTint
    }
    
    public enum Direction: Int {
        case left = 0
        case right
    }
}
