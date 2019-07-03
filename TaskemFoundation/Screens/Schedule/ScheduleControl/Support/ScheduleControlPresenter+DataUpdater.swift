//
//  ScheduleControlDataUpdater.swift
//  TaskemFoundation
//
//  Created by Wilson on 8/11/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

extension ScheduleControlPresenter: CollectionDataUpdater {
    
    public var list: ScheduleControlListViewModel {
        get { return view?.viewModel ?? .init() }
        set { view?.viewModel = newValue }
    }
    
    public func insertSection<T>(for cell: T) -> Int? {
        return nil
    }
    
    public func removeEmptySections() -> IndexSet? {
        return nil
    }
    
    public func contain<T>(_ cell: T) -> Bool {
        return false
    }
    
    public func shouldInsert<T>(_ cell: T) -> Bool {
        return false
    }
    
    public func shouldUpdate<T>(_ cell: T) -> Bool {
        return false
    }
    
    public func index<T>(for cell: T) -> IndexPath? {
        return nil
    }
    
    public func insert<T>(_ cell: T) -> IndexPath? {
        return nil
    }
    
    public func update<T>(_ cell: T) -> IndexPath? {
        return nil
    }
    
    public func move<T>(_ cell: T) -> (IndexPath, IndexPath)? {
        return nil
    }
    
    public func remove<T>(_ cell: T) -> IndexPath? {
        return nil
    }
    
    public func remove<T>(next predicate: @escaping (T) -> Bool) -> IndexPath? {
        return nil
    }
}
