//
//  DatePickerTemplatesViewController.swift
//  Taskem
//
//  Created by Wilson on 14/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class DatePickerTemplatesViewController: UIViewController, DatePickerTemplatesView, ModalPresentable, ThemeObservable {

   // MARK: IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var longTapDescription: UILabel!
    
   // MARK: IBAction

   // MARK: let & var
    var presenter: DatePickerTemplatesPresenter!
    var viewModel: DatePickerTemplatesListViewModel = DatePickerTemplatesListViewModel()
    weak var delegate: DatePickerTemplatesViewDelegate?

    private var wasFirstAppear = false

    // MARK: class func
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        delegate?.onViewWillAppear()
        adjustHeight()
    }

    // MARK: func
    public func applyTheme(_ theme: AppTheme) {
        view.backgroundColor  = theme.background
        longTapDescription.textColor = theme.promt
    }
    
    private func setupUI() {
        observeAppTheme()
        
        setupCollection()
        setupLongTap()
    }
    
    private func setupCollection() {
        collectionView.register(cell: DatePickerTemplatesCell.self)
    }
    
    private func setupLongTap() {
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    internal func willDismiss() {
        delegate?.onViewWillDismiss()
    }

    @objc private func handleLongPress(sender: UILongPressGestureRecognizer!) {
        if sender.state == .began {
            let point = sender.location(in: self.view)
            
            if let indexPath = collectionView.indexPathForItem(at: point) {
                delegate?.onLongTouch(at: indexPath)
            }
        }
    }

    private func reloadCollection() {
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            self?.adjustHeight()
            self?.wasFirstAppear = true
        }
        collectionView.reloadData()
        CATransaction.commit()
    }

    private func adjustHeight() {
        let height: CGFloat = collectionView.contentSize.height + longTapDescription.frame.height + 20
        adjustTo(height: height, animated: wasFirstAppear)
    }
    
    public func display(_ viewModel: DatePickerTemplatesListViewModel) {
        self.viewModel = viewModel
        reloadCollection()
    }
}

extension DatePickerTemplatesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellCount = CGFloat(viewModel.sections[section].cells.count)
        let cellWidth = collectionView.frame.width / 3
        let totalWidth = cellWidth * cellCount
        let collectionWidth = collectionView.frame.width

        let rightInset = (collectionWidth - totalWidth) / 2
        let leftInset = rightInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = collectionView.frame.width / 3
        return CGSize(width: cellSize, height: cellSize)
    }
}

extension DatePickerTemplatesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.onTouch(at: indexPath)
    }
}

extension DatePickerTemplatesViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sections[section].cells.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(DatePickerTemplatesCell.self, indexPath)
        cell.setup(viewModel.cell(indexPath))
        return cell
    }
}
