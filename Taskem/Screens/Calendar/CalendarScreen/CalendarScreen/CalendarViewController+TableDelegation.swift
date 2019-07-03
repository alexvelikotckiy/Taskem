//
//  CalendarViewController+TableDelegation.swift
//  Taskem
//
//  Created by Wilson on 1/24/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

extension CalendarViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let firstCell = tableView.visibleCells.first,
            let index = tableView.indexPath(for: firstCell) else { return }
        
        let top: CGFloat = 0
        let bottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        let scrollPosition = scrollView.contentOffset.y

        // Reached the bottom of the list
        if scrollPosition > bottom {
            delegate?.loadPage(at: .bottom)
        }
        // Reached the top of the list
        else if scrollPosition < top {
            delegate?.loadPage(at: .top)
        }
        
        guard scrollView.isDecelerating else { return }
        delegate?.onScroll(at: index)
    }
}

extension CalendarViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return configureAndCreateHeader(at: section)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = data[indexPath]
        
        if case .freeday = model {
            return tableView.frame.height
        } else {
            let identifier = String(describing: cellType(for: model))
            let key = model.id as NSCopying
            
            return tableView.fd_heightForCell(withIdentifier: identifier, cacheByKey: key) { [weak self] cell in
                guard let strongSelf = self,
                    let cell = cell as? UITableViewCell else { return }
                cell.fd_enforceFrameLayout = true
                strongSelf.configureCell(cell, atIndex: indexPath)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let frame = tableView.convert(cell.frame, to: nil)
        delegate?.onTouch(at: indexPath, frame: frame)
    }
}

extension CalendarViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureAndCreateCell(data[indexPath])
    }
}

// Setup cells
private extension CalendarViewController {
    func configureAndCreateHeader(at index: Int) -> UITableViewHeaderFooterView {
        switch viewModel.style {
        case .standard:
            let header = tableView.dequeueReusableHeader(CalendarTableHeader.self)
            let model = data[index]
            header.title.text = model.title
            header.subtitle.text = model.subtitle
            return header
        case .bydate:
            let header = tableView.dequeueReusableHeader(CalendarExtendedTableHeader.self)
            let model = data[index]
            header.title.text = model.title
            return header
        }
    }
    
    func configureCell(_ cell: UITableViewCell, atIndex index: IndexPath) {
        let model = data[index]
        switch model {
        case .task(let task):
            guard let cell = cell as? CalendarTaskTableCell else { return }
            configureCell(cell, task)
        case .time(let time):
            guard let cell = cell as? CalendarTodayTimeTableCell else { return }
            configureCell(cell, time)
        case .freeday(let freeday):
            guard let cell = cell as? CalendarFreedayTableCell else { return }
            configureCell(cell, freeday)
        case .event(let event):
            guard let cell = cell as? CalendarEventTableCell else { return }
            configureCell(cell, event)
        }
    }
    
    func cellType(for model: CalendarCellViewModel) -> UITableViewCell.Type {
        switch model {
        case .task:
            return CalendarTaskTableCell.self
        case .time:
            return CalendarTodayTimeTableCell.self
        case .freeday:
            return CalendarFreedayTableCell.self
        case .event:
            return CalendarEventTableCell.self
        }
    }
    
    @discardableResult
    func configureAndCreateCell(_ model: CalendarCellViewModel) -> UITableViewCell {
        switch model {
        case .task(let task):
            let cell = tableView.dequeueReusableCell(CalendarTaskTableCell.self)
            return configureCell(cell, task)
        case .time(let time):
            let cell = tableView.dequeueReusableCell(CalendarTodayTimeTableCell.self)
            return configureCell(cell, time)
        case .freeday(let freeday):
            let cell = tableView.dequeueReusableCell(CalendarFreedayTableCell.self)
            return configureCell(cell, freeday)
        case .event(let event):
            let cell = tableView.dequeueReusableCell(CalendarEventTableCell.self)
            return configureCell(cell, event)
        }
    }
    
    @discardableResult
    func configureCell(_ cell: CalendarTaskTableCell, _ model: TaskModel) -> CalendarTaskTableCell {
        cell.delegate = self
        
        cell.setSwipeGestureWith(
            UIImageView(image: Icons.icSwipeComplete.image),
            color: AppTheme.current.swipeTaskRight,
            mode: .exit,
            state: .state1,
            completionBlock: processSwipe
        )
        
        cell.setSwipeGestureWith(
            UIImageView(image: Icons.icSwipeCalendar.image),
            color: AppTheme.current.swipeTaskLeft,
            mode: .exit,
            state: .state3,
            completionBlock: processSwipe
        )
        
        cell.setup(model)
        cell.onTouchCheckbox = { [weak self] cell in
            guard let index = self?.tableView.indexPath(for: cell) else { return }
            self?.delegate?.onSwipeRight(at: [index])
        }
        return cell
    }
    
    @discardableResult
    func configureCell(_ cell: CalendarTodayTimeTableCell, _ model: CalendarTimeCell) -> CalendarTodayTimeTableCell {
        cell.selectionStyle = .none
        cell.time.text = model.time
        return cell
    }
    
    @discardableResult
    func configureCell(_ cell: CalendarFreedayTableCell, _ model: CalendarFreeDayCell) -> CalendarFreedayTableCell {
        return cell
    }
    
    @discardableResult
    func configureCell(_ cell: CalendarEventTableCell, _ model: EventModel) -> CalendarEventTableCell {
        cell.setup(model)
        return cell
    }
}

extension CalendarViewController: MCSwipeTableViewCellDelegate {
    func swipeTableViewCell(_ cell: MCSwipeTableViewCell!, didSwipeWithPercentage percentage: CGFloat) {
        let theme = AppTheme.current
        if percentage > 0 {
            cell.defaultColor = theme.swipeTaskRight.add(overlay: theme.background.withAlphaComponent(1 - percentage * 2.0))
        } else {
            cell.defaultColor = theme.swipeTaskLeft.add(overlay: theme.background.withAlphaComponent(1 + percentage * 2.0))
        }
    }
}

extension CalendarViewController: TableCoordinatorDelegate {
    func didBeginUpdate() {
        
    }
    
    func didEndUpdate() {
        
    }
    
    func insertSections(at indexes: IndexSet) {
        tableView.beginUpdates()
        tableView.insertSections(indexes, with: .automatic)
        tableView.endUpdates()
    }
    
    func reloadSections(at indexes: IndexSet) {
        tableView.beginUpdates()
        tableView.reloadSections(indexes, with: .automatic)
        tableView.endUpdates()
    }
    
    func deleteSections(at indexes: IndexSet) {
        tableView.beginUpdates()
        tableView.deleteSections(indexes, with: .automatic)
        tableView.endUpdates()
    }
    
    func willBeginUpdate(at index: IndexPath) {
        let key = data[index].id as NSCopying
        tableView.fd_keyedHeightCache.invalidateHeight(forKey: key)
    }
    
    func willEndUpdate(at index: IndexPath) {
        
    }
    
    func insertRows(at indexes: [IndexPath]) {
        tableView.beginUpdates()
        tableView.insertRows(at: indexes, with: .automatic)
        tableView.endUpdates()
    }
    
    func updateRows(at indexes: [IndexPath]) {
        tableView.beginUpdates()
        tableView.reloadRows(at: indexes, with: .automatic)
        tableView.endUpdates()
    }
    
    func deleteRows(at indexes: [IndexPath]) {
        tableView.beginUpdates()
        tableView.deleteRows(at: indexes, with: .automatic)
        tableView.endUpdates()
    }
    
    func moveRow(from: IndexPath, to index: IndexPath) {
        tableView.beginUpdates()
        tableView.moveRow(at: from, to: index)
        tableView.endUpdates()
    }
}

private extension Array where Element == CalendarSectionViewModel {
    subscript(index: IndexPath) -> CalendarCellViewModel {
        get {
            return self[index.section].cells[index.row]
        }
        set {
            self[index.section].cells[index.row] = newValue
        }
    }
}
