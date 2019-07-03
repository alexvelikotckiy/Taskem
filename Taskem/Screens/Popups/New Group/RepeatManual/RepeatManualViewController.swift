//
//  TaskRepeatSetupViewController.swift
//  Taskem
//
//  Created by Wilson on 05/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class RepeatManualViewController: UITableViewController, RepeatManualView, ThemeObservable {
   // MARK: IBOutlet
    
   // MARK: IBAction

   // MARK: let & var
    var presenter: RepeatManualPresenter!
    var viewModel: RepeatManualListViewModel = RepeatManualListViewModel()
    weak var delegate: RepeatManualViewDelegate?

    // MARK: class func
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.drawerPresentationController?.scrollViewForPullToDismiss = tableView
        delegate?.onViewWillAppear()
    }

    // MARK: func
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = theme.background
        tableView.separatorColor = theme.separatorSecond
    }
    
    @objc private func processSave() {
        delegate?.onTouchSave()
    }

    private func setupUI() {
        setupTable()
        setupNavBar()
        
        observeAppTheme()
    }
    
    private func setupNavBar() {
        let saveAction = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(processSave)
        )

        navigationItem.rightBarButtonItem = saveAction
    }

    private func setupTable() {
        tableView.register(cell: RepeatTypeTableViewCell.self)
        tableView.register(cell: RepeatEndDateTableViewCell.self)
        tableView.register(cell: RepeatEndDateExtendedTableViewCell.self)
        tableView.register(cell: RepeatDaysTableViewCell.self)
    }
    
    func display(_ viewModel: RepeatManualListViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }

    func reloadViewModel() {
        tableView.reloadData()
    }

    func reloadCell(at index: IndexPath, with animation: UITableView.RowAnimation) {
        tableView.beginUpdates()
        tableView.reloadRows(at: [index], with: animation)
        tableView.endUpdates()
    }

    func removeCell(at index: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [index], with: .automatic)
        tableView.endUpdates()
    }

    func insertCell(at index: IndexPath) {
        tableView.beginUpdates()
        tableView.insertRows(at: [index], with: .automatic)
        tableView.endUpdates()
    }
}

extension RepeatManualViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.onTouchCell(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
}

extension RepeatManualViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel[section].cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel[indexPath]

        switch model {
        case .repetition(let value):
            let cell = tableView.dequeueReusableCell(RepeatTypeTableViewCell.self)
            cell.setup(value)
            cell.touchRepeatType = { [weak self, indexPath] index in self?.delegate?.onTouchRepeatType(cellIndex: indexPath, at: index) }
            return cell
        case .endDate(let value):
            switch value.style {
            case .extended:
                let cell = tableView.dequeueReusableCell(RepeatEndDateExtendedTableViewCell.self)
                cell.setup(value)
                cell.removeEndDate = { [weak self, indexPath] in self?.delegate?.onChangeEndDate(cellIndex: indexPath, date: nil) }
                cell.endDateChanged = { [weak self, indexPath] date in self?.delegate?.onChangeEndDate(cellIndex: indexPath, date: date) }
                return cell
                
            case .simple:
                let cell = tableView.dequeueReusableCell(RepeatEndDateTableViewCell.self)
                cell.setup(value)
                cell.removeEndDate = { [weak self, indexPath] in self?.delegate?.onChangeEndDate(cellIndex: indexPath, date: nil) }
                return cell
            }
        case .daysOfWeek(let value):
            let cell = tableView.dequeueReusableCell(RepeatDaysTableViewCell.self)
            cell.setup(value)
            cell.touchDay = { [weak self, indexPath] index in self?.delegate?.onTouchDaysOfWeek(cellIndex: indexPath, at: index) }
            return cell
        }
    }
}

extension RepeatManualViewController: DrawerPresentable {
    var shouldBeginTransitioning: Bool {
        return true
    }
    
    var drawerViewParticipants: [UIView] {
        return []
    }
    
    var heightOfPartiallyExpandedDrawer: CGFloat {
        return (2 * UIScreen.main.bounds.height) / 3
    }
}
