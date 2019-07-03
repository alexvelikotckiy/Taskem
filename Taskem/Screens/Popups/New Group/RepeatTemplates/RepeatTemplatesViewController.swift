//
//  RepeatTemplatesViewController.swift
//  Taskem
//
//  Created by Wilson on 11/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class RepeatTemplatesViewController: UITableViewController, RepeatTemplatesView, ThemeObservable {
 
   // MARK: IBOutlet

   // MARK: IBAction

   // MARK: let & var
    var presenter: RepeatTemplatesPresenter!
    var viewModel: RepeatTemplatesListViewModel = RepeatTemplatesListViewModel()
    weak var delegate: RepeatTemplatesViewDelegate?

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
        setupNavBar()
        setupTable()
        
        observeAppTheme()
    }
    
    @objc private func processBack() {
        delegate?.onTouchBack()
    }

    func setupNavBar() {
        let cancelAction = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(processBack)
        )

        navigationItem.rightBarButtonItem = cancelAction
    }

    func setupTable() {
        tableView.register(cell: RepeatTemplateTableViewCell.self)
    }

    func display(_ viewModel: RepeatTemplatesListViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
}

extension RepeatTemplatesViewController {
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

extension RepeatTemplatesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel[section].cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(RepeatTemplateTableViewCell.self)
        cell.setup(viewModel[indexPath])
        return cell
    }
}

extension RepeatTemplatesViewController: DrawerPresentable {
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
