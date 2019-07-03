//
//  EventOverviewViewController.swift
//  Taskem
//
//  Created by Wilson on 18/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import EventKitUI

class EventOverviewViewController: EKEventViewController, EventOverviewView, ThemeObservable {
    // MARK: IBOutlet

    // MARK: IBAction
    
    // MARK: let & var
    var presenter: EventOverviewPresenter!
    public var viewModel: EventOverviewViewModel = .init()
    weak var viewDelegate: EventOverviewViewDelegate?
    
    private var isTransitioning = false
    private var willViewAppearAfterTransitioning = false
    
    private var tableView: UITableView? {
        return view.viewsWithType(description: "EKEventTableView").first as? UITableView
    }
    
    // MARK: class func
    override func viewDidLoad() {
        super.viewDidLoad()
        allowsEditing = true
        allowsCalendarPreview = false
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewDelegate?.onViewWillAppear()
        
        willViewAppearAfterTransitioning = false
    }
    
    @objc private func processBack() {
        if let deledate = navigationController?.transitioningDelegate as? ExpandTransitioningDelegate {
            deledate.interactiveDismiss = false
            deledate.expandTransitioning = true
        }
        navigationController?.dismiss(animated: true)
    }
    
    func applyTheme(_ theme: AppTheme) {
        
    }
    
    func display(_ viewModel: EventOverviewViewModel) {
        
    }
}

extension EventOverviewViewController: ExpandTransitioningAdapter {
    func shouldBeginExpandInteractiveTransitioning() -> Bool {
        if isEditing { return false }

        guard let tableView = self.tableView else { return false }

        let top: CGFloat = 0
        let bottom: CGFloat = (tableView.contentSize.height - tableView.frame.size.height).rounded(.towardZero)
        let scrollPosition = tableView.contentOffset.y.rounded(.towardZero)

        // Reached the bottom of the table
        if scrollPosition >= bottom {
            return true
        }
        // Reached the top of the table
        if scrollPosition <= top {
            return true
        }
        return false
    }

    func willBeginInteractiveTransitioning() {
        tableView?.isScrollEnabled = false
        isTransitioning = true
    }

    func didEndInteractiveTransitioning() {
        tableView?.isScrollEnabled = true
        isTransitioning = false
        willViewAppearAfterTransitioning = true
    }
}

extension EventOverviewViewController {
    private func setupUI() {
        if let nav = navigationController as? ExpandNavController {
            nav.onDisappear = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.delegate?.eventViewController(strongSelf, didCompleteWith: .done)
            }
        }
        observeAppTheme()
        
        setupNavBar()
    }
    
    private func setupNavBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(Icons.icBackChevron.image, for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIBarButtonItem.appearance()
            .titleTextAttributes(for: .normal)?
            .first(where: { $0.key == .font })
            .map { $0.value } as? UIFont
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        
        backButton.addTarget(
            self,
            action: #selector(processBack),
            for: .touchUpInside
        )
        
        let back = UIBarButtonItem(customView: backButton)
        back.width = 100
        
        navigationItem.leftBarButtonItem = back
    }
}
