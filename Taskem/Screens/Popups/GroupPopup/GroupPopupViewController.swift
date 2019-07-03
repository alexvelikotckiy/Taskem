//
//  GroupPopupViewController.swift
//  Taskem
//
//  Created by Wilson on 24/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import UIKit
import TaskemFoundation

class GroupPopupViewController: UICollectionViewController, GroupPopupView, ThemeObservable {
    // MARK: IBOutlet

    // MARK: IBAction

    // MARK: let & var
    var presenter: GroupPopupPresenter!
    var viewModel: GroupPopupListViewModel = .init()
    weak var delegate: GroupPopupViewDelegate?
    
    // MARK: class func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.drawerPresentationController?.scrollViewForPullToDismiss = collectionView
        delegate?.onViewWillAppear()
    }
    
    // MARK: func
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.background
        collectionView.backgroundColor = theme.background
    }
    
    @objc private func processCancel() {
        delegate?.onTouchCancel()
    }
    
    func display(_ viewModel: GroupPopupListViewModel) {
        self.viewModel = viewModel
        collectionView?.reloadData()
    }
}

extension GroupPopupViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.onSelect(at: indexPath)
    }
}

extension GroupPopupViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sectionsCount()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel[section].cells.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = configureAndCreateCell(at: indexPath)
        // https://stackoverflow.com/questions/15330844/uicollectionview-select-and-deselect-issue
        if cell.isSelected {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        return cell
    }
}

extension GroupPopupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + flowLayout.minimumInteritemSpacing * 3
        let size = (collectionView.bounds.width - totalSpace) / CGFloat(3)
        return CGSize(width: size, height: size)
    }
}

extension GroupPopupViewController {
    func setupUI() {
        setupNavBar()
        setupCollection()
        
        observeAppTheme()
    }
    
    func setupCollection() {
        collectionView?.register(cell: GroupPopupNewGroupCell.self)
        collectionView?.register(cell: GroupPopupGroupCell.self)
    }
    
    func setupNavBar() {
        let cancel = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(processCancel)
        )
        
        navigationItem.rightBarButtonItem = cancel
    }
    
    @discardableResult
    func configureAndCreateCell(at index: IndexPath) -> UICollectionViewCell {
        switch viewModel[index] {
        case .list(let model):
            let cell = collectionView!.dequeueReusableCell(GroupPopupGroupCell.self, index)
            cell.setup(model)
            return cell
            
        case .newList:
            return collectionView!.dequeueReusableCell(GroupPopupNewGroupCell.self, index)
        }
    }
}

extension GroupPopupViewController: DrawerPresentable {
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
