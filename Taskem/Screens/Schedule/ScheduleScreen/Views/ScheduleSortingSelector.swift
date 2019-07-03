//
//  ScheduleTypeSelectorCollectionCell.swift
//  Taskem
//
//  Created by Wilson on 8/10/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

protocol ScheduleSortingSelectorDataSource {
    func sorting(_ view: ScheduleSortingSelector) -> ScheduleTableType
}

class ScheduleSortingSelector: XibFileView, ThemeObservable {
    
    @IBOutlet weak var sortByDate: UIButton!
    @IBOutlet weak var sortByList: UIButton!
    @IBOutlet weak var sortByComp: UIButton!
    
    @IBAction func onSelect(_ sender: UIButton) {
        switch sender {
        case sortByDate:
            select(sorting: .schedule)
            selectAction?(.schedule)
            
        case sortByList:
            select(sorting: .project)
            selectAction?(.project)
            
        case sortByComp:
            select(sorting: .flat)
            selectAction?(.flat)
            
        default:
            break
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        observeAppTheme()
        
        select(sorting: .schedule, animated: false)
    }
    
    func applyTheme(_ theme: AppTheme) {
        switch AppTheme.current {
        case .light:
            sortByDate.setImage(Images.Foundation.icScheduleSortByDateLight.image, for: .normal)
            sortByList.setImage(Images.Foundation.icScheduleSortByListLight.image, for: .normal)
            sortByComp.setImage(Images.Foundation.icScheduleSortByCompletionLight.image, for: .normal)
            sortByDate.setImage(Images.Foundation.icScheduleSortByDateLight.image, for: .highlighted)
            sortByList.setImage(Images.Foundation.icScheduleSortByListLight.image, for: .highlighted)
            sortByComp.setImage(Images.Foundation.icScheduleSortByCompletionLight.image, for: .highlighted)
        case .dark:
            sortByDate.setImage(Images.Foundation.icScheduleSortByDateDark.image, for: .normal)
            sortByList.setImage(Images.Foundation.icScheduleSortByListDark.image, for: .normal)
            sortByComp.setImage(Images.Foundation.icScheduleSortByCompletionDark.image, for: .normal)
            sortByDate.setImage(Images.Foundation.icScheduleSortByDateDark.image, for: .highlighted)
            sortByList.setImage(Images.Foundation.icScheduleSortByListDark.image, for: .highlighted)
            sortByComp.setImage(Images.Foundation.icScheduleSortByCompletionDark.image, for: .highlighted)
        }
        backgroundColor = theme.tableBackgroundDark
    }
    
    public var selectAction: ((ScheduleTableType) -> Void)?
    public var dataSource: ScheduleSortingSelectorDataSource?
    
    private var isVisible: Bool {
        return superview != nil
    }
    
    public func reloadData() {
        guard let dataSource = dataSource else { return }
        select(sorting: dataSource.sorting(self))
    }
    
    public func toogle(in controller: UIViewController) {
        display(in: controller, visible: !isVisible)
    }
    
    public func display(in controller: UIViewController, visible: Bool) {
        if isVisible == visible { return }
        
        if visible {
            controller.view.addSubview(self)
            
            translatesAutoresizingMaskIntoConstraints = false
            
            heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            let guide = controller.view.safeAreaLayoutGuide
            
            topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
            rightAnchor.constraint(equalTo: guide.rightAnchor).isActive = true
            leftAnchor.constraint(equalTo: guide.leftAnchor).isActive = true
            
            setNeedsLayout()
            layoutIfNeeded()
        }
        animate(visible: visible)
    }
    
    private func animate(visible: Bool) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
        
        switch visible {
        case false:
            animator.addAnimations {
                self.transform = .init(translationX: 0, y: -self.frame.height)
            }
            
            animator.addCompletion { position in
                guard position == .end else { return }
                self.removeFromSuperview()
            }
        case true:
            transform = .init(translationX: 0, y: -frame.height)
            
            animator.addAnimations {
                self.transform = .identity
            }
        }
        animator.startAnimation()
    }
    
    private func select(sorting: ScheduleTableType, animated: Bool = true) {
        viewsWithType(description: "UIButton").forEach {
            deselect($0, animated: animated)
        }
        select(view: resolveView(for: sorting), animated: animated)
    }
    
    private func resolveView(for sorting: ScheduleTableType) -> UIButton {
        switch sorting {
        case .schedule:
            return sortByDate
        case .project:
            return sortByList
        case .flat:
            return sortByComp
        }
    }
    
    private func select(view: UIView, animated: Bool = true) {
        if animated {
            let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
                view.alpha = 1
            }
            animator.startAnimation()
        } else {
            view.alpha = 1
        }
    }

    private func deselect(_ view: UIView, animated: Bool = true) {
        if animated {
            let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
                view.alpha = 0.4
            }
            animator.startAnimation()
        } else {
            view.alpha = 0.4
        }
    }
}
