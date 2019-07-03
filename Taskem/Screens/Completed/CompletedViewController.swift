//
//  CompletedViewController.swift
//  Taskem
//
//  Created by Wilson on 15/01/2018.
//  Copyright © 2018 WIlson. All rights reserved.
//

import Foundation
import TaskemFoundation

class CompletedViewController: UIViewController, CompletedView, ThemeObservable {
    
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    // MARK: IBAction

    // MARK: let & var
    var presenter: CompletedPresenter!
    var viewModel: CompletedListViewModel = .init()
    weak var delegate: CompletedViewDelegate?

    internal let allDoneView = CompletedAllDoneView(frame: .zero)
    
    private var currentSwipingCell: IndexPath?

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
    @objc private func processClear() {
        delegate?.onTouchClearAll()
    }
    
    func applyTheme(_ theme: AppTheme) {
        navigationController?.view.backgroundColor = theme.background
        tableView.backgroundColor                  = theme.background
        tableView.separatorColor                   = theme.separatorSecond
        view.backgroundColor                       = theme.background
    }

    func processSwipe(swipeCell: MCSwipeTableViewCell?, state: MCSwipeTableViewCellState, cellMode: MCSwipeTableViewCellMode) {
        guard let cell = swipeCell, let index = tableView.indexPath(for: cell) else { return }
        switch state {
        case .state1:
            delegate?.onSwipeRight(at: index)
            
        case .state3:
            delegate?.onSwipeLeft(at: index) { [weak swipeCell] in
                swipeCell?.swipeToOrigin(completion: nil)
            }
        default:
            break
        }
    }

    func display(_ viewModel: CompletedListViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
        setupToolbar()
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
        setupToolbar()
    }
    
    func displayRefresh(_ isRefreshing: Bool) {
        showSpinner(isRefreshing)
    }
}

extension CompletedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeader(CompletedHeaderView.self)
        header.title.text = viewModel[section].status.description.uppercased()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let key = viewModel[indexPath].id as NSCopying
        let identifier = String(describing: TaskTableCell.self)
        
        return tableView.fd_heightForCell(withIdentifier: identifier,cacheByKey: key) { [weak self] cell in
            guard let strongSelf = self, let cell = cell as? TaskTableCell else { return }
            cell.fd_enforceFrameLayout = true
            strongSelf.setupCell(cell, index: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskTableCell else { return }
        let frame = tableView.convert(cell.frame, to: nil)
        delegate?.onTouchCell(at: indexPath, frame: frame)
    }
}

extension CompletedViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TaskTableCell.self)
        setupCell(cell: cell, atIndexPath: indexPath)
        return cell
    }
}

extension CompletedViewController: MCSwipeTableViewCellDelegate {
    //Execute completion block only of a current swiping cell
    func swipeTableViewCellShouldExecuteCompletion(_ cell: MCSwipeTableViewCell!) -> Bool {
        if let currentSwipingCell = currentSwipingCell, let swipingCell = tableView.indexPath(for: cell) {
            return currentSwipingCell == swipingCell
        }
        return false
    }

    //Allow to swipe only a 1 cell per time
    func swipeTableViewCellShouldSwipe(_ cell: MCSwipeTableViewCell!) -> Bool {
        return currentSwipingCell == nil
    }

    func swipeTableViewCellDidStartSwiping(_ cell: MCSwipeTableViewCell!) {
        if currentSwipingCell == nil {
            currentSwipingCell = tableView.indexPath(for: cell)
        }
    }

    func swipeTableViewCellDidEndSwiping(_ cell: MCSwipeTableViewCell!) {
        if currentSwipingCell == tableView.indexPath(for: cell) {
            currentSwipingCell = nil
        }
    }

    func swipeTableViewCell(_ cell: MCSwipeTableViewCell!, didSwipeWithPercentage percentage: CGFloat) {
        if percentage > 0 {
            cell.defaultColor = AppTheme.current.swipeTaskLeftDelete.add(overlay: AppTheme.current.background.withAlphaComponent(1 - percentage * 2.0))
        } else {
            cell.defaultColor = AppTheme.current.swipeTaskRight.add(overlay: AppTheme.current.background.withAlphaComponent(1 + percentage * 2.0))
        }
    }
}

extension CompletedViewController {
    func setupUI() {
        setupTable()
        setupToolbar()
        
        observeAppTheme()
    }

    func setupToolbar() {
        let clear = DestructiveBarButtonItem(
            title: "Clear All",
            style: .done,
            target: self,
            action: #selector(processClear)
        )
        clear.isEnabled = viewModel.allCells.count != 0
        clear.setTitleTextAttributes(
            [
                .foregroundColor: AppTheme.current.redTitle,
                .font: UIFont.avenirNext(ofSize: 16, weight: .demiBold)
            ],
            for: .normal
        )
        clear.setTitleTextAttributes(
            [
                .font: UIFont.avenirNext(ofSize: 16, weight: .demiBold)
            ],
            for: .disabled
        )
        clear.setTitleTextAttributes(
            [
                .font: UIFont.avenirNext(ofSize: 16, weight: .demiBold)
            ],
            for: .highlighted
        )
        
        let space = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        toolbar.items = [space, clear, space]
    }
    
    func setupTable() {
        tableView.register(cell: TaskTableCell.self)
        tableView.register(header: CompletedHeaderView.self)
    }
    
    func setupCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        guard let cell = cell as? TaskTableCell else { return }
        setupCell(cell, index: indexPath)
        setupSwipeCell(cell)
    }
    
    func setupCell(_ cell: TaskTableCell, index: IndexPath) {
        cell.setup(viewModel[index].model)
        cell.delegate = self
        cell.onTouchCheckbox = { [weak self] cell in
            guard let indexPath = self?.tableView.indexPath(for: cell) else { return }
            self?.delegate?.onToogleCompletion(at: indexPath)
        }
    }
    
    func setupSwipeCell(_ cell: TaskTableCell) {
        cell.setSwipeGestureWith(
            UIImageView(image: Icons.icSwipeTrash.image),
            color: AppTheme.current.swipeTaskLeftDelete,
            mode: .exit,
            state: .state1,
            completionBlock: processSwipe
        )
        
        cell.setSwipeGestureWith(
            UIImageView(image: Icons.icSwipeCalendar.image),
            color: AppTheme.current.swipeTaskRight,
            mode: .exit,
            state: .state3,
            completionBlock: processSwipe
        )
    }
}

extension CompletedViewController: TableCoordinatorDelegate {

    func didBeginUpdate() {
        
    }

    func didEndUpdate() {
        
    }

    func willBeginUpdate(at index: IndexPath) {
        let key = viewModel[index].id
        tableView.fd_keyedHeightCache.invalidateHeight(forKey: key as NSCopying)
    }

    func willEndUpdate(at index: IndexPath) {
        
    }
    
    func reloadSections(at indexes: IndexSet) {
        tableView.beginUpdates()
        tableView.reloadSections(indexes, with: .automatic)
        tableView.endUpdates()
    }

    func insertSections(at indexes: IndexSet) {
        tableView.beginUpdates()
        tableView.insertSections(indexes, with: .automatic)
        tableView.endUpdates()
    }

    func deleteSections(at indexes: IndexSet) {
        tableView.beginUpdates()
        tableView.deleteSections(indexes, with: .automatic)
        tableView.endUpdates()
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
