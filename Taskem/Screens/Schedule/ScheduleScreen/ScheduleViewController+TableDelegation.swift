//
//  ScheduleViewController+TableDelegation.swift
//  Taskem
//
//  Created by Wilson on 12/28/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = tableView.dataSourceIndexPath(fromVisibleIndexPath: indexPath)!
        
        let model = viewModel[index]
        let identifier = String(describing: cellType(for: model))
        let key = model.id as NSCopying
        
        return tableView.fd_heightForCell(withIdentifier: identifier, cacheByKey: key) { [weak self] cell in
            guard let strongSelf = self,
                let cell = cell as? UITableViewCell else { return }
            cell.fd_enforceFrameLayout = true
            strongSelf.configureCell(tableView, cell, atIndex: index)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeader(ScheduleTableViewHeader.self)
        header.setup(viewModel.sections[section], isEditing: isEditing, isSearching: searchController.isActive)
        header.onAction = { [weak self] header in self?.delegate?.onTouchHeaderAction(with: header.type) }
        header.onToogle = { [weak self] header in self?.delegate?.onTouchToogleHeader(with: header.type) }
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        switch cell {
        case is TaskTableCell:
            if !isEditing {
                tableView.deselectRow(at: indexPath, animated: true)
                let frame = tableView.convert(cell.frame, to: nil)
                delegate?.onTouch(at: indexPath, frame: frame)
            }
            
        default:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let isSelected = tableView.indexPathsForSelectedRows?.contains(indexPath) {
            cell.setSelected(isSelected, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = viewModel.sections[section].isExpanded ? viewModel.sections[section].cells.count : 0
        return tableView.adjustedValueForReordering(ofRowCount: rowCount, forSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = tableView.dataSourceIndexPath(fromVisibleIndexPath: indexPath)!
        return configureAndCreateCell(tableView, atIndex: index)
    }
}

extension ScheduleViewController: UITableViewDelegateReorderExtension {
    func tableView(_ tableView: UITableView,
                   targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                   toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if self.viewModel.sections[proposedDestinationIndexPath.section].isExpanded {
            return proposedDestinationIndexPath
        }
        return sourceIndexPath
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return viewModel[indexPath].canMove
    }
    
    func tableView(_ tableView: UITableView!, willMoveRowAt indexPath: IndexPath!) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.onReorderingWillBegin(initial: indexPath)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        delegate?.onReorderingDidEnd(source: sourceIndexPath, destination: destinationIndexPath)
    }
}

extension ScheduleViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationBarMenu.display(in: self, visible: false)
    }
}

// TODO: Fix a bag when the table stucks swiping after 2 cells was swiped per one time
extension ScheduleViewController: MCSwipeTableViewCellDelegate {
    //Execute a completion block only for the current swiping cell
    func swipeTableViewCellShouldExecuteCompletion(_ cell: MCSwipeTableViewCell!) -> Bool {
        if let currentSwipingCell = currentSwipingCell, let swipingCell = tableView.indexPath(for: cell) {
            return currentSwipingCell == swipingCell
        }
        return false
    }
    
    //Allow to swipe only a 1 cell per time
    func swipeTableViewCellShouldSwipe(_ cell: MCSwipeTableViewCell!) -> Bool {
//        return currentSwipingCell == nil
        return true
    }
    
    func swipeTableViewCellDidStartSwiping(_ cell: MCSwipeTableViewCell!) {
        if currentSwipingCell == nil {
            currentSwipingCell = tableView.indexPath(for: cell)
        }
        if isEditing {
            if let selectedIndex = tableView.indexPath(for: cell) {
                tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            }
        }
    }
    
    func swipeTableViewCellDidEndSwiping(_ cell: MCSwipeTableViewCell!) {
        if currentSwipingCell == tableView.indexPath(for: cell) {
            currentSwipingCell = nil
        }
    }
    
    func swipeTableViewCell(_ cell: MCSwipeTableViewCell!, didSwipeWithGesture gesture: UIPanGestureRecognizer!) {
        let selectedCells = self.tableView.visibleCells.filter({ $0.isSelected })
        for selectedCell in selectedCells {
            if let swipeCell = selectedCell as? MCSwipeTableViewCell, swipeCell != cell {
                swipeCell.handle(with: gesture)
            }
        }
    }
    
    func swipeTableViewCell(_ cell: MCSwipeTableViewCell!, didSwipeWithPercentage percentage: CGFloat) {
        if percentage > 0 {
            cell.defaultColor = AppTheme.current.swipeTaskRight.add(overlay: AppTheme.current.background.withAlphaComponent(1 - percentage * 2.0))
        } else {
            cell.defaultColor = AppTheme.current.swipeTaskLeft.add(overlay: AppTheme.current.background.withAlphaComponent(1 + percentage * 2.0))
        }
    }
}

// Setup cells
private extension ScheduleViewController {
    @discardableResult
    func configureAndCreateCell(_ tableView: UITableView, atIndex index: IndexPath) -> UITableViewCell {
        switch viewModel[index] {
        case .task:
            let cell = tableView.dequeueReusableCell(TaskTableCell.self)
            return configureCell(tableView, cell, atIndex: index)!
            
        case .time:
            let cell = tableView.dequeueReusableCell(CalendarTodayTimeTableCell.self)
            return configureCell(tableView, cell, atIndex: index)!
        }
    }
    
    @discardableResult
    func configureCell(_ tableView: UITableView, _ cell: UITableViewCell, atIndex index: IndexPath) -> UITableViewCell? {
        switch viewModel[index] {
        case .task(let task):
            guard let cell = cell as? TaskTableCell else { return nil }
            if tableView.shouldSubstitutePlaceHolderForCellBeingMoved(at: index) {
                cell.isHidden = true
            }
            return configureCell(cell, task)
        case .time(let time):
            guard let cell = cell as? CalendarTodayTimeTableCell else { return nil }
            if tableView.shouldSubstitutePlaceHolderForCellBeingMoved(at: index) {
                cell.isHidden = true
            }
            return configureCell(cell, time)
        }
    }
    
    func cellType(for model: ScheduleCellViewModel) -> UITableViewCell.Type {
        switch model {
        case .task:
            return TaskTableCell.self
        case .time:
            return CalendarTodayTimeTableCell.self
        }
    }
    
    @discardableResult
    func configureCell(_ cell: TaskTableCell, _ model: TaskModel) -> TaskTableCell {
        cell.setup(model)
        cell.onTouchCheckbox = { [weak self] cell in
            guard let strongSelf = self else { return }
            
            if strongSelf.isEditing {
                cell.checkbox.isChecked.toogle()
            } else if let indexPath = strongSelf.tableView.indexPath(for: cell) {
                strongSelf.delegate?.onSwipeRight(at: [indexPath])
            }
        }
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
        return cell
    }
    
    @discardableResult
    func configureCell(_ cell: CalendarTodayTimeTableCell, _ model: CalendarTimeCell) -> CalendarTodayTimeTableCell {
        cell.selectionStyle = .none
        cell.time.text = model.time
        return cell
    }
}
