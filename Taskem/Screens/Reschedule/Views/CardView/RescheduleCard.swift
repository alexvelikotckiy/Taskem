//
//  RescheduleCard.swift
//  Taskem
//
//  Created by Wilson on 8/22/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class RescheduleCard: MGSwipeCard {
    
    public override init() {
        super.init()
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setup(_ model: RescheduleViewModel) {
        let contentView = RescheduleCardContentView(model: model)
        setContentView(contentView)
    }
    
    func setup(_ overlays: [RescheduleSwipeOverlay]) {
        overlays.forEach { configureOverlay($0) }
    }
    
    private func setupUI() {
        footerHeight = 0
        swipeDirections = SwipeDirection.allDirections
        layer.shadowRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        taskem_cornerRadius = 10
    }
    
    private func configureOverlay(_ overlay: RescheduleSwipeOverlay) {
        let overlayView = RescheduleCardOverlay(overlay: overlay)
        setOverlay(forDirection: overlay.action.swipeDirection, overlay: overlayView)
    }
}

extension RescheduleAction {
    var swipeDirection: SwipeDirection {
        switch direction {
        case .up:
            return .up
        case .down:
            return .down
        case .left:
            return .left
        case .right:
            return .right
        }
    }
}
