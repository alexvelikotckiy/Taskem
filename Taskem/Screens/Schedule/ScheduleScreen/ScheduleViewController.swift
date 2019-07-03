//
//  ScheduleViewController.swift
//  Taskem
//
//  Created by Wilson on 11/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation
import TaskemFoundation
import PopMenu

class ScheduleViewController: UIViewController, ScheduleView, ThemeObservable {
    
    // MARK: IBOutlet
    @IBOutlet weak var tableView: ScheduleTable!

    // MARK: IBAction 
    
    // MARK: let & var
    var presenter: SchedulePresenter!
    weak var delegate: ScheduleViewDelegate?
    var viewModel: ScheduleListViewModel = .init()

    // MARK: UI let & var
    internal var plusButton: PlusButton!
    internal let searchController = SearchController(searchResultsController: nil)
    internal var toolbar: ScheduleToolbar?
    
    internal var navigationBarMenu: ScheduleSortingSelector!
    internal var navigationBarSortItem: UIBarButtonItem!
    internal var navigationBarDotsItem: UIBarButtonItem!
    
    internal var currentSwipingCell: IndexPath?
    
    internal var allDoneView: ScheduleAllDoneView!
    internal var notFoundView: ScheduleEmptySearchView!
    
    internal var navbar: ScheduleNavigationBar! {
        return navigationController?.navigationBar as? ScheduleNavigationBar
    }
    
    internal var navigationSortingItemIcon: Icon {
        let theme = AppTheme.current
        switch viewModel.type {
        case .schedule:
            switch theme {
            case .light:
                return Icon(Images.Foundation.icScheduleSortByDateLight)
            case .dark:
                return Icon(Images.Foundation.icScheduleSortByDateDark)
            }
        case .project:
            switch theme {
            case .light:
                return Icon(Images.Foundation.icScheduleSortByListLight)
            case .dark:
                return Icon(Images.Foundation.icScheduleSortByListDark)
            }
        case .flat:
            switch theme {
            case .light:
                return Icon(Images.Foundation.icScheduleSortByCompletionLight)
            case .dark:
                return Icon(Images.Foundation.icScheduleSortByCompletionDark)
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        prepareUI(isEditing: editing)
        
        if editing {
            delegate?.onBeginEditing()
        } else {
            delegate?.onEndEditing()
        }
    }
    
    // MARK: func
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor                  = theme.background
        tableView.separatorColor                   = theme.separatorSecond
        view.backgroundColor                       = theme.background
        navigationController?.view.backgroundColor = theme.background
        navigationBarSortItem.image                = navigationSortingItemIcon.image
    }
    
    @objc internal func processPlus(_ sender: UITapGestureRecognizer) {
        guard sender.state != .ended else { return }
        delegate?.onTouchPlus(isLongTap: false)
    }

    @objc internal func processPlusLongTap(_ sender: UILongPressGestureRecognizer) {
        guard sender.state != .began else { return }
        delegate?.onTouchPlus(isLongTap: true)
    }
    
    @objc internal func processBurger() {
        delegate?.onTouchScheduleControl()
    }

    @objc internal func processDots() {
        delegate?.onTouchThreeDots()
    }
    
    @objc internal func processRefresh() {
        delegate?.onRefresh()
    }
    
    @objc internal func processSorting() {
        navigationBarMenu.toogle(in: self)
    }
    
    @objc internal func processToogleSelection() {
        let selectedCount = tableView.indexPathsForSelectedRows?.count ?? 0
        
        if selectedCount == 0 {
            tableView.select(at: viewModel.indexes(where: { $0.canSelect }), animated: true)
        } else {
            tableView.deselect(at: viewModel.indexes(where: { $0.canSelect }), animated: true)
        }
    }
    
    internal func processSwipe(swipeCell: MCSwipeTableViewCell?, state: MCSwipeTableViewCellState, cellMode: MCSwipeTableViewCellMode) {
        var selectedIndexes: [IndexPath] = []
        if isEditing {
            if let currentIndexes = tableView.indexPathsForSelectedRows {
                selectedIndexes = currentIndexes
            }
        } else {
            if let cell = swipeCell, let index = tableView.indexPath(for: cell) {
                selectedIndexes = [index]
            }
        }

        switch state {
        case .state1:
            selectedIndexes.forEach {
                tableView.deselectRow(at: $0, animated: true)
            }
            delegate?.onSwipeRight(at: selectedIndexes)
            
        case .state3:
            delegate?.onSwipeLeft(at: selectedIndexes) { [weak self] shouldDeselect in
                guard let strongSelf = self else { return }
                
                selectedIndexes.forEach {
                    if let swipeCell = strongSelf.tableView.cellForRow(at: $0) as? MCSwipeTableViewCell {
                        swipeCell.swipeToOrigin(completion: nil)
                        
                        if shouldDeselect {
                            strongSelf.tableView.deselectRow(at: $0, animated: true)
                        }
                    }
                }
            }
        default:
            break
        }
    }
    
    internal func processChangeSelection() {
        switch isEditing {
        case true:
            let selectedCount = tableView.indexPathsForSelectedRows?.count ?? 0
            let allCount = tableView.indexesOfTable.count
            toolbar?.update(current: selectedCount, all: allCount)
            setupNavBar()
        default:
            return
        }
    }
}

extension ScheduleViewController {
    func display(viewModel: ScheduleListViewModel) {
        self.viewModel = viewModel
        
        tableView.reloadData()
        navbar.reloadData()
        navigationBarMenu.reloadData()
        navigationItem.title = viewModel.title
        navigationBarSortItem.image = navigationSortingItemIcon.image
    }
    
    func display(title: String) {
        viewModel.title = title
        navigationItem.title = viewModel.title
    }
    
    func displaySpinner(_ isRefreshing: Bool) {
//        DispatchQueue.main.async {
//            if isRefreshing {
//                if !self.tableView.refreshControl!.isRefreshing {
//                    self.displaySpinner()
//                }
//            } else {
//                if self.tableView.refreshControl!.isRefreshing {
//                    self.tableView.refreshControl?.endRefreshing()
//                }
//                self.removeSpinner()
//            }
//        }
    }
    
    func displayAllDone(_ isVisible: Bool) {
        switch isVisible {
        case true:
            view.insertSubview(allDoneView, at: 0)
            tableView.isHidden = true
            allDoneView.anchorSuperView()
            
        case false:
            allDoneView.removeFromSuperview()
            tableView.isHidden = false
        }
    }
    
    func displayNotFound(_ isVisible: Bool) {
        switch isVisible {
        case true:
            view.insertSubview(notFoundView, at: 0)
            tableView.isHidden = true
            notFoundView.anchorSuperView()
            
        case false:
            notFoundView.removeFromSuperview()
            tableView.isHidden = false
        }
    }
    
    func displayHeader(model: ScheduleSectionViewModel, at index: Int) {
        guard let header = tableView.headerView(forSection: index) as? ScheduleTableViewHeader else { return }
        header.setup(model, isEditing: isEditing, isSearching: searchController.isActive)
    }
}

extension ScheduleViewController: ScheduleNavigationBarDataSource {
    func views(_ navbar: ScheduleNavigationBar) -> [ScheduleNavigationBarCell] {
        return viewModel.navbarData.map { .init(data: $0) }
    }
}

extension ScheduleViewController: ScheduleSortingSelectorDataSource {
    func sorting(_ view: ScheduleSortingSelector) -> ScheduleTableType {
        return viewModel.type
    }
}
