//
//  GroupSourceIntercatorDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/18/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class GroupSourceInteractorDummy: GroupSourceInteractor {
    weak var delegate: GroupSourceInteractorObserverSpy?
    
    var sourceGroups: GroupSource
    
    init(sourceGroups: GroupSource) {
        self.sourceGroups = sourceGroups
    }
    
    var interactorGroupsDelegate: GroupSourceInteractorOutput? {
        return delegate
    }
    
    func start() {
        
    }
    
    func restart() {
        
    }
    
    func stop() {
        
    }
}

//protocol GroupSourceInteractorSpy: GroupSourceInteractor {
//    var didStartCall: Int { get set }
//    var didRestartCall: Int { get set }
//    var didStopCall: Int { get set }
//
//    var insertedGroups: [Group] { get set }
//    var updatedGroups: [Group] { get set }
//    var removedGroups: [EntityId] { get set }
//    var lastDefaultGroup: EntityId? { get set }
//    var lastReorderGroup: EntityId? { get set }
//    var lastReorderGroupSource: Int? { get set }
//    var lastReorderGroupDestination: Int? { get set }
//}
//
//extension GroupSourceInteractorSpy {
//    func start() {
//        didStartCall += 1
//    }
//
//    func restart() {
//        didRestartCall += 1
//    }
//
//    func stop() {
//        didStopCall += 1
//    }
//
//    func insertGroups(_ groups: [Group]) {
//        insertedGroups = groups
//    }
//
//    func updateGroups(_ groups: [Group]) {
//        updatedGroups = groups
//    }
//
//    func removeGroups(_ byIds: [EntityId]) {
//        removedGroups = byIds
//    }
//
//    func setDefaultGroup(_ id: EntityId) {
//        lastDefaultGroup = id
//    }
//
//    func reorderGroup(_ byId: EntityId, source: Int, destination: Int) {
//        lastReorderGroup = byId
//        lastReorderGroupSource = source
//        lastReorderGroupDestination = destination
//    }
//}

class GroupSourceInteractorObserverSpy: GroupSourceInteractorOutput {
    var lastState: DataState!
    var added: [Group] = []
    var updated: [Group] = []
    var removed: [EntityId] = []
    var ordered: [EntityId] = []
    
    func interactorDidChangeStateGroups(_ interactor: GroupSourceInteractor, state: DataState) {
        lastState = state
    }
    
    func interactor(_ interactor: GroupSourceInteractor, didAdd groups: [Group]) {
        added = groups
    }
    
    func interactor(_ interactor: GroupSourceInteractor, didUpdate groups: [Group]) {
        updated = groups
    }
    
    func interactor(_ interactor: GroupSourceInteractor, didRemoveGroups ids: [EntityId]) {
        removed = ids
    }
    
    func interactor(_ interactor: GroupSourceInteractor, didUpdateGroupsOrder ids: [EntityId]) {
        ordered = ids
    }
}
