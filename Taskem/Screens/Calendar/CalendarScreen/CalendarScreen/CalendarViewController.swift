//
//  CalendarViewController.swift
//  Taskem
//
//  Created by Wilson on 10/04/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import FSCalendar
import FDTemplateLayoutCell
import DifferenceKit
import EventKitUI

class CalendarViewController: UITableViewController, ThemeObservable {
    
    // MARK: IBOutlet
    
    // MARK: IBAction
    
    // MARK: let & var
    public var presenter: CalendarPresenter!
    public var viewModel: CalendarListViewModel = .init()
    public weak var delegate: CalendarViewDelegate?
    
    internal typealias CalendarList = [CalendarSectionViewModel]
    
    internal var data: CalendarList = .init()
    internal var dataInput: CalendarList {
        get {
            return data
        }
        set {
            let changeset = StagedChangeset(source: data, target: newValue)
            UIView.performWithoutAnimation {
                tableView.reload(
                    using: changeset,
                    with: .none) { data in
                        self.data = data
                        self.viewModel.sections = data
                }
            }
        }
    }
    
    // MARK: class func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.onViewWillAppear()
    }
    
    // MARK: func
    func killTableScroll() {
        tableView.setContentOffset(tableView.contentOffset, animated: false)
    }
    
    func processSwipe(swipeCell: MCSwipeTableViewCell?,
                      state: MCSwipeTableViewCellState,
                      cellMode: MCSwipeTableViewCellMode) {
        guard let cell = swipeCell,
            let index = tableView.indexPath(for: cell) else { return }
        switch state {
        case .state1:
            delegate?.onSwipeRight(at: [index])
        case .state3:
            delegate?.onSwipeLeft(at: [index]) { _ in
                cell.swipeToOrigin(completion: nil)
            }
        default:
            break
        }
    }
    
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor                  = theme.background
        tableView.separatorColor                   = theme.separatorSecond
        view.backgroundColor                       = theme.background
        navigationController?.view.backgroundColor = theme.background
    }
}

extension CalendarViewController: CalendarView {
    var currentDate: TimelessDate {
        get { return viewModel.currentDate }
        set { delegate?.onChangeDisplayDate(newValue) }
    }
    
    func dislpay(difference viewModel: CalendarListViewModel) {
        self.viewModel = viewModel
        self.dataInput = viewModel.sections
        self.viewModel.onChangeSections = { [weak self] newValue in
            self?.data = newValue
        }
        tableView.isScrollEnabled = viewModel.canScrollTable
    }
    
    func display(viewModel: CalendarListViewModel) {
        self.viewModel = viewModel
        self.dataInput = viewModel.sections
        self.viewModel.onChangeSections = { [weak self] newValue in
            self?.data = newValue
        }
        tableView.isScrollEnabled = viewModel.canScrollTable
    }
    
    func display(sections: [CalendarSectionViewModel],
                 at position: PageDirection) {
        switch position {
        case .top:
            data.insert(contentsOf: sections, at: 0)
            viewModel.sections.insert(contentsOf: sections, at: 0)
            
            let initialContentSize = tableView.contentSize
            tableView.reloadData()
            let resultContentSize = tableView.contentSize
            tableView.contentOffset.y = resultContentSize.height - initialContentSize.height
            
        case .bottom:
            data.append(contentsOf: sections)
            viewModel.sections.append(contentsOf: sections)
            
            tableView.reloadData()
            
        default:
            break
        }
    }
    
    func displaySpinner(_ isVisible: Bool) {
        showSpinner(isVisible)
    }
    
    func canScroll(_ can: Bool) {
        tableView.isScrollEnabled = can
    }
    
    func scroll(to section: Int, animated: Bool) {
        tableView.scrollToRow(at: .init(row: 0, section: section), at: .top, animated: animated)
        guard let header = tableView.headerView(forSection: section) else { return }
        tableView.scrollRectToVisible(header.frame, animated: animated)
    }
}

extension CalendarViewController: EKEventViewDelegate {
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        switch action {
        case .deleted:
            if let deledate = controller.navigationController?.transitioningDelegate as? ExpandTransitioningDelegate {
                deledate.interactiveDismiss = false
                deledate.expandTransitioning = true
            }
            controller.navigationController?.dismiss(animated: true) {
                self.delegate?.onChange(controller.event)
            }
        default:
            delegate?.onChange(controller.event)
        }
    }
}
