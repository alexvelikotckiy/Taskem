//
//  RescheduleToolbar.swift
//  Taskem
//
//  Created by Wilson on 8/22/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class RescheduleToolbar: XibFileView {

    @IBOutlet weak var stackView: UIStackView!
    
    var onSelect: ((RescheduleAction) -> Void)?
    var onChangeDirection: ((RescheduleToolbarChevronItem.Direction) -> Void)?
    
    init(items: [RescheduleSwipeOverlay], chevronDirection: RescheduleToolbarChevronItem.Direction) {
        super.init(frame: .zero)
        
        items.forEach {
            let item = RescheduleToolbarItem(action: $0.action)
            item.onSelect = { [weak self] action in self?.onSelect?(action) }
            stackView.addArrangedSubview(item)
        }
        
        let chevron = RescheduleToolbarChevronItem(direction: chevronDirection)
        chevron.onSelect = { [weak self] direction in
            self?.onChangeDirection?(direction)
        }
        switch chevronDirection {
        case .left:
            stackView.insertArrangedSubview(chevron, at: 0)
            
        case .right:
            stackView.addArrangedSubview(chevron)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
