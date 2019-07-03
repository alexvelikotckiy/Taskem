//
//  GroupIconPickerViewController.swift
//  Taskem
//
//  Created by Wilson on 21/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class GroupIconPickerViewController: UICollectionViewController, GroupIconPickerView, ThemeObservable {

   // MARK: IBOutlet
    
   // MARK: IBAction

   // MARK: let & var
    var presenter: GroupIconPickerPresenter!
    var viewModel: GroupIconPickerListViewModel = .init()
    weak var delegate: GroupIconPickerViewDelegate?

    // MARK: class func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.onViewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.onViewWillDisappear()
    }
    
    // MARK: func
    func applyTheme(_ theme: AppTheme) {
        collectionView.backgroundColor = theme.background
        view.backgroundColor           = theme.background
    }
    
    private func setupUI() {
        setupCollection()
        
        observeAppTheme()
    }
    
    private func setupCollection() {
        collectionView.register(cell: GroupIconPickerCollectionCell.self)
    }

    func display(viewModel: GroupIconPickerListViewModel) {
        self.viewModel = viewModel
        collectionView.reloadData()
    }
    
    func reload(at indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
    
    func scroll(to indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
    }
}

extension GroupIconPickerViewController: UICollectionViewDelegateFlowLayout {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        delegate?.onSelect(at: indexPath)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cells.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GroupIconPickerCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setup(viewModel.cell(indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + flowLayout.minimumInteritemSpacing * 4
        let size = (collectionView.bounds.width - totalSpace) / CGFloat(4)
        return CGSize(width: size, height: size)
    }
}
