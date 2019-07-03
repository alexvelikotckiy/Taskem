//
//  GroupOverviewInteractor.swift
//  Taskem
//
//  Created by Wilson on 21/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol GroupOverviewInteractorOutput: GroupSourceInteractorOutput {
    
}

public protocol GroupOverviewInteractor: GroupSourceInteractor {
    var delegate: GroupOverviewInteractorOutput? { get set }
    
}

extension GroupOverviewInteractor {
    public var interactorGroupsDelegate: GroupSourceInteractorOutput? {
        return delegate
    }
}

public class GroupOverviewDefaultInteractor: GroupOverviewInteractor {
    
    public weak var delegate: GroupOverviewInteractorOutput?
    
    public var sourceGroups: GroupSource
    
    public init(sourceGroups: GroupSource) {
        self.sourceGroups = sourceGroups
    }
    
    public func start() {
        sourceGroups.addObserver(self)
    }
    
    public func restart() {
        DispatchQueue.global().async {
            self.sourceGroups.restart()
        }
    }
    
    public func stop() {
        sourceGroups.removeObserver(self)
    }
}
