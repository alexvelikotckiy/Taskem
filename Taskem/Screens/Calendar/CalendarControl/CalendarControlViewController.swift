//
//  CalendarControlViewController.swift
//  Taskem
//
//  Created by Wilson on 10/04/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class CalendarControlViewController: UICollectionViewController, CalendarControlView, ThemeObservable {

   // MARK: IBOutlet
    
   // MARK: IBAction

   // MARK: let & var
    var presenter: CalendarControlPresenter!
    var viewModel: CalendarControlListViewModel = .init()
    weak var delegate: CalendarControlViewDelegate?
    
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resolveSelection(animated: true)
    }
    
    // MARK: func
    func applyTheme(_ theme: AppTheme) {
        navigationController?.view.backgroundColor = theme.background
        collectionView.backgroundColor             = theme.background
        view.backgroundColor                       = theme.background
    }
    
    @objc private func processDone() {
        delegate?.onTouchDone()
    }
    
    @objc private func processToogle() {
        delegate?.onTouchToogleAll()
    }
    
    func resolveSelection(animated: Bool) {
        for cell in collectionView.visibleCells {
            guard let index = collectionView.indexPath(for: cell) else { continue }
            if viewModel[index].isSelected {
                collectionView.selectItem(at: index, animated: animated, scrollPosition: [])
            } else {
                collectionView.deselectItem(at: index, animated: animated)
            }
        }
    }
    
    func display(viewModel: CalendarControlListViewModel) {
        self.viewModel = viewModel
        collectionView.reloadData()
    }
}

extension CalendarControlViewController {
    override func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.onSelect(at: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        delegate?.onDeselect(at: indexPath)
        setupNavBar() // proxy not working on didDeselectItemAt method ¯\_(ツ)_/¯
    }
}

extension CalendarControlViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
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
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch true {
        case kind == UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableView(CalendarControlHeader.self, kind: kind, for: indexPath)
            header.title.text = viewModel[indexPath.section].title
            return header
        default:
            fatalError()
        }
    }
}

extension CalendarControlViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + flowLayout.minimumInteritemSpacing * 3
        let size = (collectionView.bounds.width - totalSpace) / CGFloat(3)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

extension CalendarControlViewController {
    private func setupUI() {
        setupCollection()
        
        observeAppTheme()
    }
    
    private func setupCollection() {
        collectionView.allowsMultipleSelection = true
        collectionView.allowsSelection = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: CalendarControlGroupCell.self)
        collectionView.register(cell: CalendarControlIOSCalendarCell.self)
        collectionView.registerHeader(view: CalendarControlHeader.self)
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        (collectionView as! CalendarControlCollection).onChangeItemsSelection = { [weak self] _ in
            self?.setupNavBar()
        }
    }
    
    private func setupNavBar() {
        let toogle = UIBarButtonItem(
            title: viewModel.isAllSelected ? "Hide all" : "Show all",
            style: .done,
            target: self,
            action: #selector(processToogle)
        )
        toogle.isEnabled = collectionView.indexPathsForVisibleItems.count != 0
        
        let done = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(processDone)
        )
        navigationItem.leftBarButtonItem = toogle
        navigationItem.rightBarButtonItem = done
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @discardableResult
    func configureAndCreateCell(at index: IndexPath) -> UICollectionViewCell {
        switch viewModel[index] {
        case .group(let model):
            let cell = collectionView.dequeueReusableCell(CalendarControlGroupCell.self, index)
            cell.setup(model)
            return cell

        case .calendar(let model):
            let cell = collectionView.dequeueReusableCell(CalendarControlIOSCalendarCell.self, index)
            cell.setup(model)
            return cell
        }
    }
}

extension CalendarControlViewController: DrawerPresentable {
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
