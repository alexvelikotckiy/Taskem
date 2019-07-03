//
//  SettingsInteractor.swift
//  Taskem
//
//  Created by Wilson on 24/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol SettingsInteractorOutput: class {
    func settingsInteractorDidUpdateSettings()
}

public protocol SettingsInteractor: UserObserver, GroupSourceObserver {
    var delegate: SettingsInteractorOutput? { get set }
    
    var currentUser: User? { get }
    var defaultGroup: Group? { get }
    
    func start()
}

public class SettingsDefaultInteractor: SettingsInteractor {
    public weak var delegate: SettingsInteractorOutput?
    private let userService: UserService
    private let groupSource: GroupSource

    public init(userService: UserService,
                groupSource: GroupSource) {
        self.userService = userService
        self.groupSource = groupSource
    }
    
    deinit {
        userService.removeObserver(self)
        groupSource.removeObserver(self)
    }
    
    public func start() {
        userService.addObserver(self)
        groupSource.addObserver(self)
    }
    
    public var currentUser: User? {
        return userService.user
    }
    
    public var defaultGroup: Group? {
        return groupSource.defaultGroup
    }
}

extension SettingsDefaultInteractor: UserObserver {
    public func didUpdateUser(_ user: User?) {
        delegate?.settingsInteractorDidUpdateSettings()
    }
}

extension SettingsDefaultInteractor: GroupSourceObserver {
    public func sourceDidChangeState(_ source: GroupSource) {
        guard source.state == .loaded else { return }
        delegate?.settingsInteractorDidUpdateSettings()
    }
    
    public func source(_ source: GroupSource, didAdd groups: [Group]) {
        
    }
    
    public func source(_ source: GroupSource, didUpdate groups: [Group]) {
        guard let defaultGroup = source.defaultGroup,
            groups.contains(defaultGroup) else { return }
        delegate?.settingsInteractorDidUpdateSettings()
    }
    
    public func source(_ source: GroupSource, didRemove ids: [EntityId]) {
        
    }
    
    public func source(_ source: GroupSource, didUpdateOrderSequence ids: [EntityId]) {
        
    }
}
