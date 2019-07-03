//
//  TaskReminderTemplateSetupViewController.swift
//  Taskem
//
//  Created by Wilson on 13/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class ReminderTemplatesViewController: UITableViewController, ReminderTemplatesView, ThemeObservable {
    
   // MARK: IBOutlet
    
   // MARK: IBAction

   // MARK: let & var
    var presenter: ReminderTemplatesPresenter!
    var viewModel: ReminderTemplatesListViewModel = ReminderTemplatesListViewModel()
    weak var delegate: ReminderTemplatesViewDelegate?

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
    
    private func setupUI() {
        setupNav()
        setupTable()
        
        observeAppTheme()
    }
    
    @objc private func processBack() {
        delegate?.onTouchBack()
    }

    private func setupNav() {
        let cancelAction = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(processBack)
        )

        navigationItem.rightBarButtonItem = cancelAction
    }

    private func setupTable() {
        tableView.register(cell: ReminderTemplateCell.self)
    }
    
    func display(_ viewModel: ReminderTemplatesListViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
}

extension ReminderTemplatesViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.onTouchCell(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

extension ReminderTemplatesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionsCount()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel[section].cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ReminderTemplateCell.self)
        cell.setup(viewModel[indexPath])
        return cell
    }
}

extension ReminderTemplatesViewController: DrawerPresentable {
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
