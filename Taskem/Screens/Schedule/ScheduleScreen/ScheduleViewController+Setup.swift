//
//  ScheduleViewController+Setup.swift
//  Taskem
//
//  Created by Wilson on 12/28/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

extension ScheduleViewController {
    func setupUI() {
        setupRefresh()
        setupTable()
        setupPlusButton()
        setupNavBar()
        setupSearchController()
        setupDroupDownMenu()
        setupCustomViews()
        
        observeAppTheme()
    }
    
    func setupCustomViews() {
        allDoneView = .init(frame: .init())
        notFoundView = .init(frame: .init())
    }
    
    func setupDroupDownMenu() {
        navigationBarMenu = .init(frame: view.bounds)
        navigationBarMenu.dataSource = self
        navigationBarMenu.selectAction = { [weak self] sorting in
            self?.delegate?.onChangeSorting(sorting)
        }
    }
    
    func setupRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(processRefresh),
            for: .valueChanged
        )
        refreshControl.tintColor = AppTheme.current.refreshControl
        tableView.refreshControl = refreshControl
    }
    
    func setupToolbar() {
        let selected = tableView.indexPathsForSelectedRows?.count ?? 0
        toolbar = ScheduleToolbar(selected: selected, all: tableView.indexesOfTable.count)
        toolbar?.onList = { [weak self] in
            guard let indexes = self?.tableView.indexPathsForSelectedRows else { return }
            self?.delegate?.onEditGroup(at: indexes)
        }
        toolbar?.onDelete = { [weak self] in
            guard let indexes = self?.tableView.indexPathsForSelectedRows else { return }
            self?.delegate?.onEditDelete(at: indexes)
        }
        toolbar?.onShare = { [weak self] in
            guard let indexes = self?.tableView.indexPathsForSelectedRows else { return }
            self?.delegate?.onShare(at: indexes)
        }
        toolbar?.show(in: self)
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.keyboardType = .asciiCapable
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search events"
    }
    
    func setupNavBar() {
        let navbar = navigationController?.navigationBar as? ScheduleNavigationBar
        navbar?.dataSource = self
        
        if isEditing {
            let selectedRowsCount = tableView.indexPathsForSelectedRows?.count ?? 0
            
            let toogle = UIBarButtonItem(
                title: selectedRowsCount == 0 ? "Mark All" : "Clear All",
                style: .plain,
                target: self,
                action: #selector(processToogleSelection)
            )
            toogle.isEnabled = tableView.indexesOfTable.count != 0
            
            navigationItem.rightBarButtonItems = [editButtonItem]
            navigationItem.leftBarButtonItems = [toogle]
        } else {
            let burger = UIBarButtonItem(
                image: UIImage(asset: Icons.icBurger),
                style: .plain,
                target: self,
                action: #selector(processBurger)
            )
            
            let sort = UIBarButtonItem(
                image: navigationSortingItemIcon.image,
                style: .plain,
                target: self,
                action: #selector(processSorting)
            )
            navigationBarSortItem = sort
            
            let dots = UIBarButtonItem(
                image: UIImage(asset: Icons.icThreeDots),
                style: .plain,
                target: self,
                action: #selector(processDots)
            )
            navigationBarDotsItem = dots
            
            navigationItem.leftBarButtonItem = burger
            navigationItem.rightBarButtonItems = [dots, sort]
        }
    }
    
    func setupPlusButton() {
        plusButton = .init(frame: .zero)
        plusButton.onTap = { [weak self] in self?.delegate?.onTouchPlus(isLongTap: false) }
        plusButton.onLongTap = { [weak self] in self?.delegate?.onTouchPlus(isLongTap: true) }
        plusButton.show(in: self)
    }
    
    func setupTable() {
        tableView.contentInset = tableView.defaultSafeAreaInsets(in: self)
        tableView.register(cell: CalendarTodayTimeTableCell.self)
        tableView.register(cell: TaskTableCell.self)
        tableView.register(header: ScheduleTableViewHeader.self)
        tableView.allowsLongPressToReorder = true
        tableView.isMultipleTouchEnabled = false
        tableView.isExclusiveTouch = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.onChangeRowsSelection = { [weak self] _ in self?.processChangeSelection() }
    }
}
