//
//  IOSThemeManager.swift
//  Taskem
//
//  Created by Wilson on 12/9/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class IOSThemeManager: ThemeManager {
    
    internal var observers: ObserverCollection<ThemeObservable> = .init()
    
    init() {
        
    }
    
    deinit {
        stop()
    }
    
    public func start() {
        registerAppearance(theme: currentTheme)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleThemeChange),
            name: .UserPreferencesDidChangeAppTheme,
            object: nil
        )
    }
    
    public func stop() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleThemeChange() {
        registerAppearance(theme: currentTheme)
        notifyDidChangeTheme(currentTheme)
    }
    
    private func registerAppearance(theme: AppTheme) {
        registerNavBar(theme: theme)
        registerTabBar(theme: theme)
        registerToobar(theme: theme)
        registerSearchBar(theme: theme)
        registerSystemViews(theme: theme)
        registerTableView(theme: theme)
        registerCollectionView(theme: theme)
        invalidateViews()
    }
    
    private func registerNavBar(theme: AppTheme) {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.tintColor = theme.navBarItem
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = theme.navbar
        navigationBar.barStyle = theme == .light ? .default : .black
        navigationBar.prefersLargeTitles = false
//        navigationBar.shadowImage = UIImage()
        
        let font: UIFont = .avenirNext(ofSize: 18, weight: .bold)
        navigationBar.titleTextAttributes = [
            .font: font,
            .foregroundColor: theme.navBarTitle
        ]
        
        let largeFont: UIFont = .avenirNext(ofSize: 25, weight: .demiBold)
        navigationBar.prefersLargeTitles = true
        navigationBar.largeTitleTextAttributes = [
            .foregroundColor: theme.navBarTitle,
            .font: largeFont
        ]
        
        let navigationItemFont: UIFont = .avenirNext(ofSize: 16, weight: .medium)
        let navigationItem = UIBarButtonItem.appearance()
        navigationItem.setTitleTextAttributes(
            [
                .font: navigationItemFont,
                .foregroundColor: theme.navBarItemDisabled
            ],
            for: .disabled
        )
        navigationItem.setTitleTextAttributes(
            [
                .font: navigationItemFont,
                .foregroundColor: theme.navBarItem
            ],
            for: .normal
        )
        navigationItem.setTitleTextAttributes(
            [
                .font: navigationItemFont,
                .foregroundColor: theme.navBarItemHighlighted
            ],
            for: .highlighted
        )
    }
    
    private func registerTabBar(theme: AppTheme) {
        let tabbar = UITabBar.appearance()
        tabbar.shadowImage = UIImage()
        tabbar.isTranslucent = false
        tabbar.barTintColor = theme.navbar
        tabbar.barStyle = theme == .light ? .default : .black
        tabbar.barTintColor = theme.navbar
        tabbar.tintColor = theme.iconHighlightedTint
        tabbar.unselectedItemTintColor = theme.iconTint
//        tabbar.backgroundImage = UIImage()
        
        let tabbarItemFont: UIFont = .avenirNext(ofSize: 10, weight: .medium)
        let tabbarItem = UITabBarItem.appearance()
        tabbarItem.setTitleTextAttributes(
            [
                .font: tabbarItemFont,
            ],
            for: .normal
        )
    }
    
    private func registerToobar(theme: AppTheme) {
        let toolbar = UIToolbar.appearance()
        toolbar.backgroundColor = theme.toolbar
        toolbar.tintColor = theme.navBarItem
        toolbar.isTranslucent = false
        toolbar.barTintColor = theme.navbar
        toolbar.barStyle = theme == .light ? .default : .black
    }
    
    private func registerTableView(theme: AppTheme) {
        let tableview = UITableView.appearance()
        tableview.backgroundView?.backgroundColor = theme.background
        tableview.separatorColor = theme.separatorSecond
        
        let cell = UITableViewCell.appearance()
        cell.backgroundView?.backgroundColor = theme.background
        cell.contentView.backgroundColor = theme.background
        
        let header = UITableViewHeaderFooterView.appearance()
        header.contentView.backgroundColor = theme.background
    }
    
    private func registerCollectionView(theme: AppTheme) {
        let collection = UICollectionView.appearance()
        collection.backgroundView?.backgroundColor = theme.background
        
        let cell = UICollectionViewCell.appearance()
        cell.backgroundView?.backgroundColor = theme.background
        cell.contentView.backgroundColor = theme.background
    }
    
    private func registerSearchBar(theme: AppTheme) {
        let searchBar = UISearchBar.appearance()
        searchBar.tintColor = theme.navBarItem
        searchBar.backgroundColor = theme.background
        searchBar.isTranslucent = false
        searchBar.barStyle = theme == .light ? .default : .black
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = theme.background
        searchBar.searchBarStyle = .minimal
        
        let searchItem = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        let searchItemFont: UIFont = .avenirNext(ofSize: 16, weight: .medium)
        searchItem.setTitleTextAttributes(
            [
                .font: searchItemFont,
                .foregroundColor: theme.navBarItemDisabled
            ],
            for: .disabled
        )
        searchItem.setTitleTextAttributes(
            [
                .font: searchItemFont,
                .foregroundColor: theme.navBarItem
            ],
            for: .normal
        )
        searchItem.setTitleTextAttributes(
            [
                .font: searchItemFont,
                .foregroundColor: theme.navBarItemHighlighted
            ],
            for: .highlighted
        )
        
        let searchTextFieldFont: UIFont = .avenirNext(ofSize: 16, weight: .medium)
        let searchTextFieldApeparance = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        searchTextFieldApeparance.defaultTextAttributes = [
            .font: searchTextFieldFont,
            .foregroundColor: theme.navbar
        ]
        searchTextFieldApeparance.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: theme.textViewPlaceholder]
        )
        searchTextFieldApeparance.textColor = theme.secondTitle
        searchTextFieldApeparance.backgroundColor = theme.navbar
    }
    
    private func registerSystemViews(theme: AppTheme) {

    }
    
    private func invalidateViews() {
        UIApplication.shared.windows.forEach { window in
            window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
            window.rootViewController?.children.forEach({ $0.setNeedsStatusBarAppearanceUpdate() })
            
            window.subviews.forEach { view in
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
    }
}
