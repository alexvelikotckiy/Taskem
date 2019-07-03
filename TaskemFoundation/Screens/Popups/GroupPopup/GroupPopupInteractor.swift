//
//  GroupPopupInteractor.swift
//  Taskem
//
//  Created by Wilson on 24/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

public protocol GroupPopupInteractorOutput: GroupSourceInteractorOutput {
    
}

public protocol GroupPopupInteractor: GroupSourceInteractor {
    var interactorDelegate: GroupPopupInteractorOutput? { get set }
}

public extension GroupPopupInteractor {
    var interactorGroupsDelegate: GroupSourceInteractorOutput? {
        return interactorDelegate
    }
}

public class GroupPopupDefaultInteractor: GroupPopupInteractor {    
    public weak var interactorDelegate: GroupPopupInteractorOutput?
    
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
