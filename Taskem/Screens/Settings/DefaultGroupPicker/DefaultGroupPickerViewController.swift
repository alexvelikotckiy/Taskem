//
//  DefaultGroupPickerViewController.swift
//  Taskem
//
//  Created by Wilson on 27/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class DefaultGroupPickerViewController: UICollectionViewController, DefaultGroupPickerView, ThemeObservable {
   // MARK: IBOutlet

   // MARK: IBAction

   // MARK: let & var
    var presenter: DefaultGroupPickerPresenter!
    var viewModel: DefaultGroupPickerListViewModel = .init()
    weak var delegate: DefaultGroupPickerViewDelegate?

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
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.background
        collectionView.backgroundColor = theme.background
    }
    
    func display(_ viewModel: DefaultGroupPickerListViewModel) {
        self.viewModel = viewModel
        collectionView?.reloadData()
    }
    
    func displaySpinner(_ isVisible: Bool) {
        if isVisible {
            displaySpinner()
        } else {
            removeSpinner()
        }
    }
    
    func reload(at index: Int) {
        guard let cell = collectionView.cellForItem(at: .init(row: index, section: 0)) as? DefaultGroupPickerCollectionCell else { return }
        cell.setup(viewModel.cell(for: index))
    }
}

extension DefaultGroupPickerViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cells.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.onSelect(at: indexPath.row)
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

extension DefaultGroupPickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + flowLayout.minimumInteritemSpacing * 3
        let size = (collectionView.bounds.width - totalSpace) / CGFloat(3)
        return CGSize(width: size, height: size)
    }
}

extension DefaultGroupPickerViewController {
    func setupUI() {
        setupCollection()
        observeAppTheme()
    }
    
    func setupCollection() {
        collectionView?.register(cell: DefaultGroupPickerCollectionCell.self)
    }
    
    func configureAndCreateCell(at index: IndexPath) -> UICollectionViewCell {
        let cell = collectionView!.dequeueReusableCell(DefaultGroupPickerCollectionCell.self, index)
        cell.setup(viewModel.cell(for: index.row))
        return cell
    }
}
