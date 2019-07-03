//
//  CalendarViewController+Setup.swift
//  Taskem
//
//  Created by Wilson on 1/24/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation


// Setup UI
extension CalendarViewController {
    func setupUI() {
        setupTable()
        
        observeAppTheme()
    }
    
    private func setupTable() {
        tableView.register(cell: CalendarTaskTableCell.self)
        tableView.register(cell: CalendarEventTableCell.self)
        tableView.register(cell: CalendarTodayTimeTableCell.self)
        tableView.register(cell: CalendarFreedayTableCell.self)
        tableView.register(header: CalendarTableHeader.self)
        tableView.register(header: CalendarExtendedTableHeader.self)
        tableView.isMultipleTouchEnabled = false
        tableView.sectionHeaderHeight = 35
    }
}
