//
//  CalendarPageViewController+Setup.swift
//  Taskem
//
//  Created by Wilson on 1/26/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

extension CalendarPageViewController {
    
    func setupUI() {
        setupPageController()
        setupControllers()
        setupPlus()
        setupNavBar()
        setupNavCalendar()
        setupNavTitle()
        setupTimer()
        
        observeAppTheme()
    }
    
    private func setupTimer() {
        timer.start()
        timer.setOnTick { [weak self] in
            guard let strongSelf = self else { return }
            let now = Date.now
            if strongSelf.timerDate.day != now.day {
                strongSelf.setupNavBar()
            }
            strongSelf.timerDate = now
        }
    }
    
    private func setupControllers() {
        let controller = unusedViewController
        setViewControllers([controller], direction: .forward, animated: false)
    }
    
    private func setupPageController() {
        delegate = self
        dataSource = self
    }
    
    private func setupNavCalendar() {
        guard let navigationBar = navigationController?.navigationBar as? CalendarNavigationBar else { return }
        navBar = navigationBar
        calendarDelegate = navBar
        calendarDataSource = navBar
        calendar = navigationBar.calendar
        calendar?.dataSource = self
        calendar?.delegate = self
        
        calendarScopeObserver = calendar.observe(\.scope, options: [.new, .old]) { [weak self] calendar, _ in
            guard let strongSelf = self else { return }
            strongSelf.navbarTitleView.setScope(calendarScope: calendar.scope)
            strongSelf.killChildViewScroll()
        }
    }
    
    private func setupNavTitle() {
        navbarTitleView = .init(frame: .zero)
        navbarTitleView.onToogle = { [weak self] isUp in
            guard let strongSelf = self else { return }
            let newScope = strongSelf.resolveNewCalendarScope(isTitleUp: isUp, currentScope: strongSelf.calendar.scope)
            if newScope != strongSelf.calendar.scope {
                strongSelf.navBar?.setCalendarScope(newScope, shouldHideOnWeekScope: strongSelf.viewModel.shouldHideCalendarOnWeekScope, animated: true)
            }
        }
        navigationItem.titleView = navbarTitleView
    }
    
    private func setupNavBar() {
        let filter = UIBarButtonItem(
            image: Icons.icCalendarFilter.image,
            style: .done,
            target: self,
            action: #selector(processFilter)
        )
        
        let dots = UIBarButtonItem(
            image: Icons.icThreeDots.image,
            style: .plain,
            target: self,
            action: #selector(processDots)
        )
        navigationBarDotsItem = dots
        
        let todayButton = UIButton(type: .system)
        
        todayButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        todayButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        todayButton.setBackgroundImage(Icons.icCalendarTodayBackgroud.image, for: .normal)
        todayButton.titleLabel?.lineBreakMode = .byWordWrapping
        todayButton.titleLabel?.textAlignment = .center
        
        let dayString = NSMutableAttributedString(
            string: Date.now.dateToString(format: "d"),
            attributes: [
                .font: UIFont.avenirNext(ofSize: 14, weight: .demiBold),
                .foregroundColor: AppTheme.current.whiteTitle,
                .paragraphStyle: {
                    let style = NSMutableParagraphStyle()
                    style.alignment = .center
                    style.lineHeightMultiple = 0.9
                    return style
                }()
            ]
        )
        
        let monthString = NSMutableAttributedString(
            string: Date.now.dateToString(format: "MMM"),
            attributes: [
                .font: UIFont.avenirNext(ofSize: 10, weight: .demiBold),
                .foregroundColor: AppTheme.current.whiteTitle,
                .paragraphStyle: {
                    let style = NSMutableParagraphStyle()
                    style.alignment = .center
                    style.lineHeightMultiple = 0.7
                    return style
                }()
            ]
        )
        
        dayString.append(.init(string: "\n"))
        dayString.append(monthString)
        
        todayButton.setAttributedTitle(dayString, for: .normal)
        todayButton.addTarget(
            self,
            action: #selector(processToday),
            for: .touchUpInside
        )
        
        let today = UIBarButtonItem(customView: todayButton)
        
        navigationItem.rightBarButtonItems = [dots, today]
        navigationItem.leftBarButtonItem = filter
        
        resolveAdditionalSafeAreaInsets(animated: false)
    }
    
    private func setupPlus() {
        plusButton = .init(frame: .zero)
        plusButton.onTap = { [weak self] in self?.viewDelegate?.onTouchPlus(isLongTap: false) }
        plusButton.onLongTap = { [weak self] in self?.viewDelegate?.onTouchPlus(isLongTap: true) }
        plusButton.show(in: self)
    }
    
    func resolveAdditionalSafeAreaInsets(animated: Bool) {
        guard let navBarHeight = navigationController?.navigationBar.sizeThatFits(.init()).height else { return }
        
        additionalSafeAreaInsets = .init(top: navBarHeight - 44, left: 0, bottom: 0, right: 0)
        
        if animated {
            let animator = UIViewPropertyAnimator.init(duration: 0.3, curve: .easeInOut) {
                self.view.layoutIfNeeded()
            }
            animator.startAnimation()
        } else {
            view.layoutIfNeeded()
        }
    }
}
