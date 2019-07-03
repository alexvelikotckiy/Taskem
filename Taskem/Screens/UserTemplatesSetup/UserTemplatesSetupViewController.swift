//
//  UserTemplatesSetupViewController.swift
//  Taskem
//
//  Created by Wilson on 29/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import PainlessInjection

class UserTemplatesSetupViewController: UIViewController, UserTemplatesSetupView, ThemeObservable {

   // MARK: IBOutlet
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!

   // MARK: IBAction
    @IBAction func touchStart(_ sender: Any) {
        delegate?.onTouchContinue()
    }

   // MARK: let & var
    var presenter: UserTemplatesSetupPresenter!
    var viewModel: UserTemplatesSetupListViewModel = .init()
    weak var delegate: UserTemplatesSetupViewDelegate?

    // MARK: class func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        delegate?.onViewWillAppear()
    }

    // MARK: func
    private func setupUI() {
        observeAppTheme()
        setupCollection()
    }
    
    private func setupCollection() {
        collectionView.register(cell: UserTemplatesSetupCell.self)
        collectionView.allowsMultipleSelection = true
    }
    
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.background
        subtitle.textColor   = theme.secondTitle
    }
    
    func display(_ viewModel: UserTemplatesSetupListViewModel) {
        self.viewModel = viewModel
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(setupSelected)
        collectionView.reloadData()
        CATransaction.commit()
    }

    func reloadCell(at index: IndexPath) {
        collectionView.reloadItems(at: [index])
    }

    private func setupSelected() {
        for visibleCell in collectionView.visibleCells {
            if let index = collectionView.indexPath(for: visibleCell) {
                let isSelected = viewModel.cell(for: index.row).isSelected

                if isSelected {
                    collectionView.selectItem(at: index, animated: false, scrollPosition: [])
                } else {
                    collectionView.deselectItem(at: index, animated: false)
                }
            }
        }
    }
}

extension UserTemplatesSetupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + flowLayout.minimumInteritemSpacing * 3
        let size = (collectionView.bounds.width - totalSpace) / CGFloat(3)
        return CGSize(width: size, height: size)
    }
}

extension UserTemplatesSetupViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.onSelectCell(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if viewModel.cell(for: indexPath.row).isSelectable {
            delegate?.onDeselectCell(at: indexPath)
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        }
    }
}

extension UserTemplatesSetupViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cells.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(UserTemplatesSetupCell.self, indexPath)
        cell.setup(viewModel.cell(for: indexPath.row))
        return cell
    }
}
