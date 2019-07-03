//
//  GroupControlViewController.swift
//  Taskem
//
//  Created by Wilson on 03/01/2018.
//  Copyright © 2018 WIlson. All rights reserved.
//

import UIKit
import TaskemFoundation

class ScheduleControlViewController: UICollectionViewController, ScheduleControlView, ThemeObservable {
    
    // MARK: IBOutlet
    
    // MARK: IBAction
    
    // MARK: let & var
    var presenter: ScheduleControlPresenter!
    var viewModel: ScheduleControlListViewModel = .init()
    weak var delegate: ScheduleControlViewDelegate?
    
    internal var navbar: ScheduleControlNavigationBar? {
        return navigationController?.navigationBar as? ScheduleControlNavigationBar
    }
    
    // MARK: class func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.drawerPresentationController?.scrollViewForPullToDismiss = collectionView
        navigationController?.isToolbarHidden = false
        
        delegate?.onViewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resolveSelection(animated: true)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        delegate?.onTouchEditing(editing)
        prepareUI(isEditing: editing, animated: animated)
    }
    
    // MARK: func
    func applyTheme(_ theme: AppTheme) {
        collectionView.backgroundColor             = theme.background
        view.backgroundColor                       = theme.background
        navigationController?.view.backgroundColor = theme.background
    }

    @objc private func processAddList() {
        delegate?.onTouchNew()
    }
    
    private func isSelected(at index: IndexPath) -> Bool {
        if viewModel[index].isSelected,
            !viewModel.isEditing {
            return true
        }
        return false
    }
    
    private func setEditingCells(_ editing: Bool) {
        for cell in collectionView.visibleCells {
            guard let index = collectionView.indexPath(for: cell),
                let cell = cell as? ScheduleControlGroupCell else { continue }
            cell.setup(viewModel[index], editing: editing)
        }
    }

    func display(_ viewModel: ScheduleControlListViewModel) {
        self.viewModel = viewModel
        collectionView.reloadData()
        isEditing = viewModel.isEditing
        navbar?.reloadData()
    }
    
    func resolveSelection(animated: Bool = true) {
        for cell in collectionView.visibleCells {
            guard let index = collectionView.indexPath(for: cell) else { continue }
            if isSelected(at: index) {
                collectionView.selectItem(at: index, animated: animated, scrollPosition: [])
            } else {
                collectionView.deselectItem(at: index, animated: animated)
            }
        }
        navbar?.reloadData()
    }
    
    func displaySpinner(_ isVisible: Bool) {
        showSpinner(isVisible)
    }
}

extension ScheduleControlViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.isEditing {
            collectionView.deselectItem(at: indexPath, animated: true)
            delegate?.onTouch(at: indexPath)
        } else {
            delegate?.onSelect(at: indexPath)
        }
        navbar?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        delegate?.onDeselect(at: indexPath)
        navbar?.reloadData()
    }
}

extension ScheduleControlViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel[section].cells.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return viewModel.isEditing
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        delegate?.onMove(from: sourceIndexPath, to: destinationIndexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ScheduleControlGroupCell.self, indexPath)
        cell.setup(viewModel[indexPath], editing: viewModel.isEditing)
        // https://stackoverflow.com/questions/15330844/uicollectionview-select-and-deselect-issue
        if cell.isSelected {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        return cell
    }
}

extension ScheduleControlViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + flowLayout.minimumInteritemSpacing * 3
        let size = (collectionView.bounds.width - totalSpace) / CGFloat(3)
        return CGSize(width: size, height: size)
    }
}

extension ScheduleControlViewController: DrawerPresentable {
    var shouldBeginTransitioning: Bool {
        return true
    }
    
    var drawerViewParticipants: [UIView] {
        return []
    }
    
    var heightOfPartiallyExpandedDrawer: CGFloat {
        return 0
    }
}

extension ScheduleControlViewController: ScheduleControlNavigationBarDataSource {
    func views(_ navbar: ScheduleControlNavigationBar) -> [ScheduleNavigationBarCell] {
        return viewModel.navbarContent.map { .init(data: $0) }
    }
    
    func subtitle(_ navbar: ScheduleControlNavigationBar) -> String {
        return viewModel.subtitle
    }
}

extension ScheduleControlViewController {
    private func setupUI() {
        setupCollection()
        setupNavBar()
        setupToolbar()
        
        observeAppTheme()
    }
    
    private func setupCollection() {
        collectionView.register(cell: ScheduleControlGroupCell.self)
    }
    
    private func setupNavBar() {
        navbar?.dataSource = self
        navbar?.contentView.onClear = { [weak self] in self?.delegate?.onTouchClearSelection() }
    }
    
    private func setupToolbar() {
        let new = UIBarButtonItem(
            title: "Add List",
            style: .plain,
            target: self,
            action: #selector(processAddList)
        )
        
        let empty = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: nil,
            action: nil
        )
        empty.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        
        let space = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let fixedSpace = UIBarButtonItem(
            barButtonSystemItem: .fixedSpace,
            target: nil,
            action: nil
        )
        fixedSpace.width = 15
        
        toolbarItems = [fixedSpace, empty , space, new, space, editButtonItem, fixedSpace]
    }
    
    private func prepareUI(isEditing: Bool, animated: Bool) {
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = !isEditing
        resolveSelection(animated: animated)
        
        let animator = UIViewPropertyAnimator.init(duration: 0.3, curve: .easeInOut) {
            self.navigationItem.title = "Your Lists"
            self.navbar?.setEditing(isEditing)
            self.setEditingCells(isEditing)
            self.setupToolbar()
        }
        animator.startAnimation()
    }
}

extension ScheduleControlViewController: CollectionUpdaterDelegate {
    func didBeginUpdate() {
        
    }
    
    func didEndUpdate() {
        
    }
    
    func willBeginUpdate(at index: IndexPath) {
        
    }
    
    func insertSections(at indexes: IndexSet) {
        collectionView.insertSections(indexes)
    }
    
    func reloadSections(at indexes: IndexSet) {
        collectionView.reloadSections(indexes)
    }
    
    func deleteSections(indexes: IndexSet) {
        collectionView.deleteSections(indexes)
    }
    
    func insertRows(at indexes: [IndexPath]) {
        collectionView.insertItems(at: indexes)
    }
    
    func updateRows(at indexes: [IndexPath]) {
        collectionView.reloadItems(at: indexes)
    }
    
    func deleteRows(at indexes: [IndexPath]) {
        collectionView.deleteItems(at: indexes)
    }
    
    func moveRow(from: IndexPath, to index: IndexPath) {
        collectionView.moveItem(at: from, to: index)
    }
}
