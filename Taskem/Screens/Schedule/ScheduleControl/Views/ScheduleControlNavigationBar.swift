//
//  ScheduleControlNavigationBar.swift
//  Taskem
//
//  Created by Wilson on 10/6/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

protocol ScheduleControlNavigationBarDataSource {
    func views(_ navbar: ScheduleControlNavigationBar) -> [ScheduleNavigationBarCell]
    func subtitle(_ navbar: ScheduleControlNavigationBar) -> String
}

class ScheduleControlNavigationBar: UINavigationBar, ThemeObservable {
    
    public var dataSource: ScheduleControlNavigationBarDataSource?
    
    public var isCustomViewsVisible = true {
        didSet {
            contentView.isHidden = !isCustomViewsVisible
            subtitle.isHidden    = !isCustomViewsVisible
        }
    }
    
    public var contentView: ScheduleControlNavigationBarContentView = {
        return .init(maxWidth: 0)
    }()
    
    public var subtitle: UILabel = {
       let label = UILabel()
        label.font = .avenirNext(ofSize: 14, weight: .demiBold)
        return label
    }()
  
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
        subtitle.textColor = theme.navBarTitle
    }
    
    public func setEditing(_ editing: Bool) {
        contentView.alpha = editing ? 0 : 1
        contentView.alpha = editing ? 0 : 1
        subtitle.alpha = editing ? 0 : 1
    }
    
    private func setupUI() {
        observeAppTheme()
    }
    
    public func reloadData() {
        guard let dataSource = dataSource else { return }
        
        subtitle.text = dataSource.subtitle(self)

        contentView.reload(dataSource.views(self))
    }

    private func layoutUIIfNeed() {
        guard shouldLayout,
            let titleView = largeTitle else { return }
        
        titleView.clipsToBounds = false
        setupSubtitle(in: titleView)
        setupContentView(in: titleView)
    }
    
    private var shouldLayout: Bool {
        for view in subviews where isLargeTitle(view) {
            if view.clipsToBounds == true ||
                subtitle.superview == nil ||
                contentView.superview == nil {
                return true
            }
        }
        return false
    }
    
    private func setupContentView(in view: UIView) {
        let isHidden = contentView.isHidden
        contentView.isHidden = true
        
        contentView.stackView.maxWidth = frame.width / 3
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.removeFromSuperview()
        view.addSubview(contentView)
        
        contentView.leftAnchor.constraint(equalTo: subtitle.safeAreaLayoutGuide.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        contentView.heightAnchor.constraint(equalToConstant: view.frame.height)
        
        contentView.isHidden = isHidden
    }
    
    private func setupSubtitle(in view: UIView) {
        guard let largeTitleLabel = view.subviews.first as? UILabel else { return }
        
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        
        subtitle.removeFromSuperview()
        view.addSubview(subtitle)
        
        subtitle.leftAnchor.constraint(equalTo: largeTitleLabel.safeAreaLayoutGuide.leftAnchor).isActive = true
        subtitle.bottomAnchor.constraint(equalTo: largeTitleLabel.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    private var largeTitle: UIView? {
        return subviews.first(where: { isLargeTitle($0) })
    }
    
    private func isLargeTitle(_ view: UIView) -> Bool {
        return String(describing: type(of: view)).contains("BarLargeTitleView")
    }
}
