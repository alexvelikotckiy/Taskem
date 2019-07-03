//
//  ScheduleNavigationBar.swift
//  Taskem
//
//  Created by Wilson on 10/2/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

protocol ScheduleNavigationBarDataSource {
    func views(_ navbar: ScheduleNavigationBar) -> [ScheduleNavigationBarCell]
}

@IBDesignable
class ScheduleNavigationBar: UINavigationBar, ThemeObservable {
    
    public var dataSource: ScheduleNavigationBarDataSource?
    
    public var isCustomViewsVisible = true {
        didSet {
            largeContent.isHidden = !isCustomViewsVisible
//            smallContent.isHidden = !isCustomViewsVisible
        }
    }
    
    private lazy var largeContent: ScheduleNavigationBarContentView = {
        return .init(maxWidth: 0)
    }()

//    private lazy var smallContent: ScheduleNavigationBarContentView = {
//        return .init()
//    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutUIIfNeed()
    }
    
    public func applyTheme(_ theme: AppTheme) {
        
    }
    
    public func reloadData() {
        guard let dataSource = dataSource else { return }
        
        largeContent.reload(dataSource.views(self))
//        largeContent.removeAllViews()
//        dataSource.views(self).forEach {
//            largeContent.addView($0)
//        }
        
//        smallContent.removeAllViews()
//        dataSource.views(self).forEach {
//            smallContent.addView($0)
//        }
    }
    
    public func setEditing(_ editing: Bool) {
        
    }
    
    private func setupUI() {
        observeAppTheme()
    }
    
    private func layoutUIIfNeed() {
        guard shouldLayout,
            let titleView = largeTitle else { return }

        setupContentView(in: titleView)
    }
    
    private var shouldLayout: Bool {
        for view in subviews where isLargeTitle(view) {
            if largeContent.superview == nil {
//                || smallContent.superview == nil {
                return true
            }
        }
        return false
    }
    
    private func setupContentView(in view: UIView) {
        guard let largeTitleLabel = view.subviews.first as? UILabel else { return }
        
        largeContent.stackView.maxWidth = frame.width / 3
        largeContent.translatesAutoresizingMaskIntoConstraints = false
        
        largeContent.removeFromSuperview()
        view.addSubview(largeContent)
        
        largeContent.leftAnchor.constraint(equalTo: largeTitleLabel.safeAreaLayoutGuide.rightAnchor).isActive = true
        largeContent.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        largeContent.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
    
    private var largeTitle: UIView? {
        return subviews.first(where: { isLargeTitle($0) })
    }
    
    private func isLargeTitle(_ view: UIView) -> Bool {
        return String(describing: type(of: view)).contains("BarLargeTitleView")
    }
}

class ScheduleNavigationBarItem: UINavigationItem { }
