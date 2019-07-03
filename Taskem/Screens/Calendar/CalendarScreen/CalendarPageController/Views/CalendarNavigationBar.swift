//
//  CalendarNavigationBar.swift
//  Taskem
//
//  Created by Wilson on 8/30/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import FSCalendar
import TaskemFoundation

@IBDesignable
class CalendarNavigationBar: UINavigationBar, ThemeObservable {
    
    public private(set) var calendar: TaskemCalendar!
    private var calendarHeightAnchor: NSLayoutConstraint!
    
    public var shouldHideCalendarOnWeekScope = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return .init(width: size.width, height: 44 + calendarHeightAnchor.constant)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sizeToFit()
        resolveHeightForSubviews()
    }
    
    override func pushItem(_ item: UINavigationItem, animated: Bool) {
        super.pushItem(item, animated: animated)
    }
    
    private func resolveHeightForSubviews() {
        for subview in subviews where !(subview is TaskemCalendar) {
            var viewFrame = subview.frame
            viewFrame.size.height = self.frame.height - viewFrame.origin.y
            subview.frame = viewFrame
        }
    }
    
    func applyTheme(_ theme: AppTheme) {
        calendar.headerHeight = 0
    }
    
    private func setupView() {
        setupCalendar()
        layoutSubviews()
        
        observeAppTheme()
    }
    
    private func setupCalendar() {
        calendar = TaskemCalendar()
        calendar.headerHeight = 0
        calendar.delegate = self
        calendar.dataSource = self
        calendar.setScope(.week, animated: false)
        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture));
        calendar.addGestureRecognizer(scopeGesture)
        addSubview(calendar)
        anchorCalendar()
    }
    
    private func anchorCalendar() {
        let guide = safeAreaLayoutGuide
        calendar.anchor(top: guide.topAnchor, left: guide.leftAnchor, bottom: nil, right: guide.rightAnchor, paddingTop: 44)
        calendarHeightAnchor = calendar.heightAnchor.constraint(equalToConstant: 250)
        calendarHeightAnchor.isActive = true
    }
    
    public func setCalendar(shouldHideOnWeekScope: Bool, animated: Bool) {
        shouldHideCalendarOnWeekScope = shouldHideOnWeekScope
        
        if shouldHideOnWeekScope, calendar.scope == .week {
            animateHideCalendar(animated: animated)
        } else {
            if isCalendarHidden {
                animateShowCalendar(animated: animated)
            }
        }
        calendar.reloadData()
    }
    
    public func setCalendarScope(_ scope: FSCalendarScope, shouldHideOnWeekScope: Bool, animated: Bool) {
        shouldHideCalendarOnWeekScope = shouldHideOnWeekScope
        
        if shouldHideCalendarOnWeekScope, scope == .week {
            calendar.setScope(scope, animated: true)
            animateHideCalendar(animated: animated)
        } else {
            if isCalendarHidden {
                animateShowCalendar(animated: animated)
            }
            calendar.setScope(scope, animated: animated)
        }
    }
    
    private var isCalendarHidden: Bool {
        return calendarHeightAnchor.constant == 0
    }
    
    private func animateShowCalendar(animated: Bool) {
        guard isCalendarHidden else { return }
        
        calendarHeightAnchor.constant = 70
        animateLayout(animated: animated)
    }
    
    private func animateHideCalendar(animated: Bool) {
        guard !isCalendarHidden else { return }
        
        calendarHeightAnchor.constant = 0
        animateLayout(animated: animated)
    }
    
    private func animateLayout(animated: Bool) {
        if animated {
            let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
                self.layoutIfNeeded()
            }
            animator.startAnimation()
        } else {
            layoutIfNeeded()
        }
    }
}

extension CalendarNavigationBar: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        if animated, calendar.scope == .week, shouldHideCalendarOnWeekScope {
            animateHideCalendar(animated: true)
        } else {
            calendarHeightAnchor.constant = bounds.height
            layoutIfNeeded()
        }
    }
}
