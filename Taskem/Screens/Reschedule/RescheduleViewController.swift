//
//  RescheduleViewController.swift
//  Taskem
//
//  Created by Wilson on 18/12/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import UIKit
import TaskemFoundation

class RescheduleViewController: UIViewController, RescheduleView, ThemeObservable {
    
    // MARK: IBOutlet
    @IBOutlet weak var cardView: MGCardStackView!
    @IBOutlet weak var toolbarSlider: SliderView!

    // MARK: IBAction

    // MARK: let & var
    var presenter: ReschedulePresenter!
    public var viewModel: RescheduleListViewModel = .init()
    weak var delegate: RescheduleViewDelegate?
    
    private var undoItem: UIBarButtonItem!
    
    private var allDoneView = RescheduleAllDoneView(frame: .zero)
    private var notingFoundView = RescheduleNothingFoundView(frame: .zero)
    
    private var slides: [RescheduleToolbar] = []
    private var cards: [RescheduleCard] = []
    
    private var swipeIndex = -1
    
    // MARK: class func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        delegate?.onViewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        cardView.delegate = nil
        cardView.dataSource = nil
        delegate?.onViewWillDisappear()
    }
    
    // MARK: func
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor                       = theme.background
        navigationController?.view.backgroundColor = theme.background
        cardView.backgroundColor                   = theme.background
    }
    
    @objc private func processUndoLast() {
        delegate?.onTouchUndoLast()
    }

    func displaySpinner(_ visible: Bool) {
        switch visible {
        case true:
            displaySpinner()
        case false:
            removeSpinner()
        }
    }
    
    func displayAllDone(_ visible: Bool) {
        switch visible {
        case true:
            allDoneView.alpha = 0
            view.insertSubview(allDoneView, at: 0)
            allDoneView.anchorSuperView()
            
            let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
                self.allDoneView.alpha = 1
                self.cardView.alpha = 0
                self.toolbarSlider.alpha = 0
            }
            animator.addCompletion { position in
                self.cardView.isHidden = true
                self.toolbarSlider.isHidden = true
            }
            animator.startAnimation()
            
        case false:
            allDoneView.removeFromSuperview()
            self.cardView.alpha = 1
            self.toolbarSlider.alpha = 1
            cardView.isHidden = false
            toolbarSlider.isHidden = false
        }
    }
    
    func displayNothingFound(_ visible: Bool) {
        switch visible {
        case true:
            view.insertSubview(notingFoundView, at: 0)
            cardView.isHidden = true
            toolbarSlider.isHidden = true
            notingFoundView.anchorSuperView()
            
        case false:
            notingFoundView.removeFromSuperview()
            cardView.isHidden = false
            toolbarSlider.isHidden = false
        }
    }
    
    func display(_ viewModel: RescheduleListViewModel) {
        self.viewModel = viewModel
        toolbarSlider.reloadSlides()
        cards.removeAll()
        cardView.reloadData()
        swipeIndex = -1
        setupNavBar()
    }
    
    func swipeCurrentCard(at direction: TaskemFoundation.SwipeDirection) {
        cardView.swipe(direction.mg)
    }
     
    func undoLastSwipe() {
        cardView.undoLastSwipe()
        setupNavBar()
    }
}

extension RescheduleViewController: MGCardStackViewDataSource {
    func numberOfCards(in cardStack: MGCardStackView) -> Int {
        return viewModel.cards.count
    }

    func cardStack(_ cardStack: MGCardStackView, cardForIndexAt index: Int) -> MGSwipeCard {
        let card = RescheduleCard()
        card.setup(viewModel[index])
        card.setup(viewModel.overlays)
        cards.append(card)
        return card
    }
}

extension RescheduleViewController: MGCardStackViewDelegate {
    func additionalOptions(_ cardStack: MGCardStackView) -> MGCardStackViewOptions {
        let options = MGCardStackViewOptions()
        options.cardStackInsets = UIEdgeInsets(top: 14, left: 10, bottom: 14, right: 10)
        return options
    }
    
    func cardStack(_ cardStack: MGCardStackView, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        swipeIndex = index
        delegate?.onSwipe(at: index, direction: TaskemFoundation.SwipeDirection(direction: direction))
        setupNavBar()
    }
    
    func cardStack(_ cardStack: MGCardStackView, didUndoSwipeOnCardAt index: Int, from direction: SwipeDirection) {
        if index == 0 {
            swipeIndex = -1
        } else {
            swipeIndex = index
        }
    }
}

extension RescheduleViewController: SliderViewDelegate {
    func sliderViewNumberOfSlideds(_ view: SliderView) -> Int {
        return viewModel.toolbarItems(for: viewModel.toolbar).count
    }
    
    func sliderView(_ view: SliderView, slideAt: Int) -> UIView {
        let items = viewModel.toolbarItems(for: slideAt == 0 ? .edit : .dates)
        let toolbar = RescheduleToolbar(items: items, chevronDirection: slideAt == 0 ? .right : .left)
        toolbar.onSelect = { [weak self] action in
            guard let strongSelf = self else { return }
            strongSelf.cardView.swipe(action.direction.mg)
        }
        toolbar.onChangeDirection = { [weak self] direction in
            self?.toolbarSlider.setCurrentSlide(direction == .left ? 0 : 1, animated: true)
        }
        return toolbar
    }

    func sliderView(_ view: SliderView, didChangeSlide: Int) {
        switch didChangeSlide {
        case 0:
            viewModel.toolbar = .edit
        case 1:
            viewModel.toolbar = .dates
        default:
            break
        }
        cards.forEach {
            $0.setup(viewModel.overlays)
        }
    }
}

extension RescheduleViewController {
    private func setupUI() {
        setupCardView()
        setupNavBar()
        setupSlider()
        
        observeAppTheme()
    }
    
    private func setupSlider() {
        toolbarSlider.sliderDelegate = self
    }
    
    private func setupCardView() {
        cardView.isExclusiveTouch = true
        cardView.delegate = self
        cardView.dataSource = self
    }
    
    private func setupNavBar() {
        if undoItem == nil {
            undoItem = UIBarButtonItem(
                barButtonSystemItem: .undo,
                target: self,
                action: #selector(processUndoLast)
            )
            navigationItem.rightBarButtonItem = undoItem
        }
        undoItem.isEnabled = swipeIndex != -1
    }
}

extension TaskemFoundation.SwipeDirection {
    public init(direction: SwipeDirection) {
        switch direction {
        case .down:
            self = .down
        case .left:
            self = .left
        case .right:
            self = .right
        case .up:
            self = .up
        }
    }
    
    public var mg: SwipeDirection {
        switch self {
        case .down:
            return .down
        case .left:
            return .left
        case .right:
            return .right
        case .up:
            return .up
        }
    }
}
