//
//  DefaultGroupPickerInteractor.swift
//  Taskem
//
//  Created by Wilson on 27/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol DefaultGroupPickerInteractorOutput: GroupSourceInteractorOutput {
    
}

public protocol DefaultGroupPickerInteractor: GroupSourceInteractor {
    var interactorDelegate: DefaultGroupPickerInteractorOutput? { get set }
}

public extension DefaultGroupPickerInteractor {
    var interactorGroupsDelegate: GroupSourceInteractorOutput? {
        return interactorDelegate
    }
}

public class DefaultGroupPickerDefaultInteractor: DefaultGroupPickerInteractor {    
    public weak var interactorDelegate: DefaultGroupPickerInteractorOutput?
    
    public let sourceGroups: GroupSource

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
