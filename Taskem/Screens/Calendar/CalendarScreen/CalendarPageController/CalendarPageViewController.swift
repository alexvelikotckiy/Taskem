//
//  CalendarPageViewController.swift
//  Taskem
//
//  Created by Wilson on 30/08/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import FSCalendar
import PainlessInjection

class CalendarPageViewController: UIPageViewController, ThemeObservable {
   // MARK: IBOutlet

   // MARK: IBAction

   // MARK: let & var
    public var presenter: CalendarPagePresenter!
    public var viewModel: CalendarPageViewModel = .init()
    public weak var viewDelegate: CalendarPageViewDelegate?

    private var reusableControllers: Set<CalendarViewController> = .init()
    
    internal var plusButton: PlusButton!
    internal var navbarTitleView: CalendarTitleView!
    
    internal var navigationBarDotsItem: UIBarButtonItem!
    
    internal weak var calendar: FSCalendar!
    internal weak var navBar: CalendarNavigationBar?
    internal weak var calendarDelegate: FSCalendarDelegate?
    internal weak var calendarDataSource: FSCalendarDataSource?
    internal var calendarScopeObserver: NSKeyValueObservation!
    
    internal var timer: TaskemFoundation.TimerProtocol = SystemTimer()
    internal var timerDate: Date = Date.now
    
    // MARK: class func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewDelegate?.onViewWillAppear()
    }

    @objc override func conforms(to aProtocol: Protocol) -> Bool {
        return super.conforms(to: aProtocol)
            || (calendarDelegate?.conforms(to: aProtocol) ?? false)
            || (calendarDataSource?.conforms(to: aProtocol) ?? false)
    }
    
    @objc override func responds(to aSelector: Selector!) -> Bool {
        return super.responds(to: aSelector)
            || (calendarDelegate?.responds(to: aSelector) ?? false)
            || (calendarDataSource?.responds(to: aSelector) ?? false)
    }
    
    @objc override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if calendarDelegate?.responds(to: aSelector) ?? false {
            return calendarDelegate
        } else if calendarDataSource?.responds(to: aSelector) ?? false {
            return calendarDataSource
        }
        return super.forwardingTarget(for: aSelector)
    }
    
    deinit {
        timer.stop()
        calendarScopeObserver.invalidate()
    }
    
    // MARK: func    
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.background
    }
    
    @objc func processToday() {
        viewDelegate?.onTouchToday()
    }

    @objc func processDots() {
        viewDelegate?.onTouchDots()
    }
    
    @objc func processFilter() {
        viewDelegate?.onTouchCalendarControl()
    }
    
    func resolveNewCalendarScope(isTitleUp: Bool, currentScope: FSCalendarScope) -> FSCalendarScope {
        if viewModel.shouldHideCalendarOnWeekScope {
            return isTitleUp ? .week : .month
        } else {
            return currentScope == .month ? .week : .month
        }
    }
    
    func resolveIfPagesScroll(_ isScroll: Bool) {
        dataSource = isScroll ? self : nil
    }
    
    func killChildViewScroll() {
        guard let controller = viewControllers?.first as? CalendarViewController else { return }
        controller.killTableScroll()
    }
    
    var unusedViewController: CalendarViewController {
        let unusedViewControllers = reusableControllers.filter { $0.parent == nil }
        if let unusedViewController = unusedViewControllers.first {
            return unusedViewController
        } else {
            let newViewController: CalendarViewController = Container.get(delegate: presenter)
            reusableControllers.insert(newViewController)
            return newViewController
        }
    }
}

extension CalendarPageViewController: CalendarPageView {
    func diplayCalendar(at date: TimelessDate) {
        viewModel.currentDate = date
        calendar.select(date.value, scrollToDate: true)
    }
    
    func displayNextPage(date: TimelessDate, direction: CalendarPageDirection) {
        viewModel.currentDate = date
        let nextPage = unusedViewController
        nextPage.currentDate = date
        view.isUserInteractionEnabled = false
        setViewControllers([nextPage],
                           direction: direction.pageDirection,
                           animated: true) { _ in
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func displayCurrentPage(date: TimelessDate) {
        viewModel.currentDate = date
        guard let currentPage = viewControllers?.first as? CalendarPage else { return }
        currentPage.currentDate = date
    }
    
    func display(viewModel: CalendarPageViewModel) {
        self.viewModel = viewModel
        display(title: viewModel.title)
        resolveIfPagesScroll(viewModel.isScrollPages)
    }
    
    func display(title: String) {
        viewModel.title = title
        navbarTitleView.title.text = title
    }
    
    func displayCalendar(shouldHide: Bool, animated: Bool) {
        navBar?.setCalendar(shouldHideOnWeekScope: shouldHide, animated: animated)
        resolveAdditionalSafeAreaInsets(animated: animated)
    }
    
    func reloadCalendar() {
        DispatchQueue.main.async {
            self.calendar.reloadData()
        }
    }
}
