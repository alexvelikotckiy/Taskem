//
//  TaskReminderSetupViewController.swift
//  Taskem
//
//  Created by Wilson on 09/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class ReminderManualViewController: UITableViewController, ReminderManualView, ThemeObservable {
   // MARK: IBOutlet
    
   // MARK: IBAction

    // MARK: let & var
    var presenter: ReminderManualPresenter!
    var viewModel: ReminderManualListViewModel = .init()
    weak var delegate: ReminderManualViewDelegate?

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
    
    func display(_ viewModel: ReminderManualListViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
    
    func reload(at index: IndexPath) {
        tableView.beginUpdates()
        tableView.reloadRows(at: [index], with: .none)
        tableView.endUpdates()
    }
}

extension ReminderManualViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionsCount()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel[indexPath]
        
        switch model {
        case .description(let model):
            let cell = tableView.dequeueReusableCell(ReminderManualDescriptionTabeCell.self)
            cell.setup(model)
            return cell
            
        case .timePicker(let model):
            let cell = tableView.dequeueReusableCell(ReminderManualTimeTableCell.self)
            cell.setup(model)
            cell.onTimeCange = { [weak self] time in self?.delegate?.onChangeTime(date: time) }
            return cell
        }
    }
}

extension ReminderManualViewController {
    private func setupUI() {
        setupTable()
        setupNavBar()
        
        observeAppTheme()
    }
    
    private func setupTable() {
        tableView.register(cell: ReminderManualDescriptionTabeCell.self)
        tableView.register(cell: ReminderManualTimeTableCell.self)
    }
    
    private func setupNavBar() {
        let save = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(processSave)
        )
        
        navigationItem.rightBarButtonItem = save
    }
}

extension ReminderManualViewController: DrawerPresentable {
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
