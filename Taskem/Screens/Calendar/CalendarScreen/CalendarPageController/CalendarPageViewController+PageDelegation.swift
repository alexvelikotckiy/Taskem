//
//  CalendarPageViewController+PageDelegation.swift
//  Taskem
//
//  Created by Wilson on 1/26/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

extension CalendarPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard viewModel.isScrollPages,
            let currentPage = viewController as? CalendarPage else { return nil }
        
        let nextViewController = unusedViewController
        return viewDelegate?.configurePage(nextViewController, direction: .reverse, currentPage: currentPage)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard viewModel.isScrollPages,
            let currentPage = viewController as? CalendarPage else { return nil }
        
        let nextViewController = unusedViewController
        return viewDelegate?.configurePage(nextViewController, direction: .forward, currentPage: currentPage)
    }
}

extension CalendarPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard let page = pageViewController.viewControllers?.first as? CalendarPage else { return }
        viewDelegate?.didShowCalendar(page: page)
    }
}

