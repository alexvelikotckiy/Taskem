//
//  GroupPopupInteractorDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/23/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class GroupPopupInteractorSpy: GroupPopupInteractor {
    var invokedInteractorDelegateSetter = false
    var invokedInteractorDelegateSetterCount = 0
    var invokedInteractorDelegate: GroupPopupInteractorOutput?
    var invokedInteractorDelegateList = [GroupPopupInteractorOutput?]()
    var invokedInteractorDelegateGetter = false
    var invokedInteractorDelegateGetterCount = 0
    var stubbedInteractorDelegate: GroupPopupInteractorOutput!
    var interactorDelegate: GroupPopupInteractorOutput? {
        set {
            invokedInteractorDelegateSetter = true
            invokedInteractorDelegateSetterCount += 1
            invokedInteractorDelegate = newValue
            invokedInteractorDelegateList.append(newValue)
        }
        get {
            invokedInteractorDelegateGetter = true
            invokedInteractorDelegateGetterCount += 1
            return stubbedInteractorDelegate
        }
    }
    var invokedSourceGroupsGetter = false
    var invokedSourceGroupsGetterCount = 0
    var stubbedSourceGroups: GroupSource!
    var sourceGroups: GroupSource {
        invokedSourceGroupsGetter = true
        invokedSourceGroupsGetterCount += 1
        return stubbedSourceGroups
    }
    var invokedInteractorGroupsDelegateGetter = false
    var invokedInteractorGroupsDelegateGetterCount = 0
    var stubbedInteractorGroupsDelegate: GroupSourceInteractorOutput!
    var interactorGroupsDelegate: GroupSourceInteractorOutput? {
        invokedInteractorGroupsDelegateGetter = true
        invokedInteractorGroupsDelegateGetterCount += 1
        return stubbedInteractorGroupsDelegate
    }
    var invokedStart = false
    var invokedStartCount = 0
    func start() {
        invokedStart = true
        invokedStartCount += 1
    }
    var invokedRestart = false
    var invokedRestartCount = 0
    func restart() {
        invokedRestart = true
        invokedRestartCount += 1
    }
    var invokedStop = false
    var invokedStopCount = 0
    func stop() {
        invokedStop = true
        invokedStopCount += 1
    }
    var invokedFetchGroups = false
    var invokedFetchGroupsCount = 0
    var stubbedFetchGroupsPredicateResult: (Group, Void)?
    var stubbedFetchGroupsCompletionResult: ([Group], Void)?
    func fetchGroups(_ predicate: @escaping (Group) -> Bool,
    _ completion: @escaping ([Group]) -> Void) {
        invokedFetchGroups = true
        invokedFetchGroupsCount += 1
        if let result = stubbedFetchGroupsPredicateResult {
            _ = predicate(result.0)
        }
        if let result = stubbedFetchGroupsCompletionResult {
            completion(result.0)
        }
    }
    var invokedInsertGroups = false
    var invokedInsertGroupsCount = 0
    var invokedInsertGroupsParameters: (groups: [Group], Void)?
    var invokedInsertGroupsParametersList = [(groups: [Group], Void)]()
    func insertGroups(_ groups: [Group]) {
        invokedInsertGroups = true
        invokedInsertGroupsCount += 1
        invokedInsertGroupsParameters = (groups, ())
        invokedInsertGroupsParametersList.append((groups, ()))
    }
    var invokedUpdateGroups = false
    var invokedUpdateGroupsCount = 0
    var invokedUpdateGroupsParameters: (groups: [Group], Void)?
    var invokedUpdateGroupsParametersList = [(groups: [Group], Void)]()
    func updateGroups(_ groups: [Group]) {
        invokedUpdateGroups = true
        invokedUpdateGroupsCount += 1
        invokedUpdateGroupsParameters = (groups, ())
        invokedUpdateGroupsParametersList.append((groups, ()))
    }
    var invokedRemoveGroups = false
    var invokedRemoveGroupsCount = 0
    var invokedRemoveGroupsParameters: (byIds: [EntityId], Void)?
    var invokedRemoveGroupsParametersList = [(byIds: [EntityId], Void)]()
    func removeGroups(_ byIds: [EntityId]) {
        invokedRemoveGroups = true
        invokedRemoveGroupsCount += 1
        invokedRemoveGroupsParameters = (byIds, ())
        invokedRemoveGroupsParametersList.append((byIds, ()))
    }
    var invokedSetDefaultGroup = false
    var invokedSetDefaultGroupCount = 0
    var invokedSetDefaultGroupParameters: (id: EntityId, Void)?
    var invokedSetDefaultGroupParametersList = [(id: EntityId, Void)]()
    func setDefaultGroup(_ id: EntityId) {
        invokedSetDefaultGroup = true
        invokedSetDefaultGroupCount += 1
        invokedSetDefaultGroupParameters = (id, ())
        invokedSetDefaultGroupParametersList.append((id, ()))
    }
    var invokedReorderGroup = false
    var invokedReorderGroupCount = 0
    var invokedReorderGroupParameters: (byId: EntityId, source: Int, destination: Int)?
    var invokedReorderGroupParametersList = [(byId: EntityId, source: Int, destination: Int)]()
    func reorderGroup(_ byId: EntityId, source: Int, destination: Int) {
        invokedReorderGroup = true
        invokedReorderGroupCount += 1
        invokedReorderGroupParameters = (byId, source, destination)
        invokedReorderGroupParametersList.append((byId, source, destination))
    }
    var invokedSourceDidChangeState = false
    var invokedSourceDidChangeStateCount = 0
    var invokedSourceDidChangeStateParameters: (source: GroupSource, Void)?
    var invokedSourceDidChangeStateParametersList = [(source: GroupSource, Void)]()
    func sourceDidChangeState(_ source: GroupSource) {
        invokedSourceDidChangeState = true
        invokedSourceDidChangeStateCount += 1
        invokedSourceDidChangeStateParameters = (source, ())
        invokedSourceDidChangeStateParametersList.append((source, ()))
    }
    var invokedSourceDidAdd = false
    var invokedSourceDidAddCount = 0
    var invokedSourceDidAddParameters: (source: GroupSource, groups: [Group])?
    var invokedSourceDidAddParametersList = [(source: GroupSource, groups: [Group])]()
    func source(_ source: GroupSource, didAdd groups: [Group]) {
        invokedSourceDidAdd = true
        invokedSourceDidAddCount += 1
        invokedSourceDidAddParameters = (source, groups)
        invokedSourceDidAddParametersList.append((source, groups))
    }
    var invokedSourceDidUpdate = false
    var invokedSourceDidUpdateCount = 0
    var invokedSourceDidUpdateParameters: (source: GroupSource, groups: [Group])?
    var invokedSourceDidUpdateParametersList = [(source: GroupSource, groups: [Group])]()
    func source(_ source: GroupSource, didUpdate groups: [Group]) {
        invokedSourceDidUpdate = true
        invokedSourceDidUpdateCount += 1
        invokedSourceDidUpdateParameters = (source, groups)
        invokedSourceDidUpdateParametersList.append((source, groups))
    }
    var invokedSourceDidRemove = false
    var invokedSourceDidRemoveCount = 0
    var invokedSourceDidRemoveParameters: (source: GroupSource, ids: [EntityId])?
    var invokedSourceDidRemoveParametersList = [(source: GroupSource, ids: [EntityId])]()
    func source(_ source: GroupSource, didRemove ids: [EntityId]) {
        invokedSourceDidRemove = true
        invokedSourceDidRemoveCount += 1
        invokedSourceDidRemoveParameters = (source, ids)
        invokedSourceDidRemoveParametersList.append((source, ids))
    }
    var invokedSourceDidUpdateOrderSequence = false
    var invokedSourceDidUpdateOrderSequenceCount = 0
    var invokedSourceDidUpdateOrderSequenceParameters: (source: GroupSource, ids: [EntityId])?
    var invokedSourceDidUpdateOrderSequenceParametersList = [(source: GroupSource, ids: [EntityId])]()
    func source(_ source: GroupSource, didUpdateOrderSequence ids: [EntityId]) {
        invokedSourceDidUpdateOrderSequence = true
        invokedSourceDidUpdateOrderSequenceCount += 1
        invokedSourceDidUpdateOrderSequenceParameters = (source, ids)
        invokedSourceDidUpdateOrderSequenceParametersList.append((source, ids))
    }
}

class GroupPopupInteractorObserverSpy: GroupPopupInteractorOutput {
    var invokedInteractorDidChangeStateGroups = false
    var invokedInteractorDidChangeStateGroupsCount = 0
    var invokedInteractorDidChangeStateGroupsParameters: (interactor: GroupSourceInteractor, state: DataState)?
    var invokedInteractorDidChangeStateGroupsParametersList = [(interactor: GroupSourceInteractor, state: DataState)]()
    func interactorDidChangeStateGroups(_ interactor: GroupSourceInteractor, state: DataState) {
        invokedInteractorDidChangeStateGroups = true
        invokedInteractorDidChangeStateGroupsCount += 1
        invokedInteractorDidChangeStateGroupsParameters = (interactor, state)
        invokedInteractorDidChangeStateGroupsParametersList.append((interactor, state))
    }
    var invokedInteractorDidAdd = false
    var invokedInteractorDidAddCount = 0
    var invokedInteractorDidAddParameters: (interactor: GroupSourceInteractor, groups: [Group])?
    var invokedInteractorDidAddParametersList = [(interactor: GroupSourceInteractor, groups: [Group])]()
    func interactor(_ interactor: GroupSourceInteractor, didAdd groups: [Group]) {
        invokedInteractorDidAdd = true
        invokedInteractorDidAddCount += 1
        invokedInteractorDidAddParameters = (interactor, groups)
        invokedInteractorDidAddParametersList.append((interactor, groups))
    }
    var invokedInteractorDidUpdate = false
    var invokedInteractorDidUpdateCount = 0
    var invokedInteractorDidUpdateParameters: (interactor: GroupSourceInteractor, groups: [Group])?
    var invokedInteractorDidUpdateParametersList = [(interactor: GroupSourceInteractor, groups: [Group])]()
    func interactor(_ interactor: GroupSourceInteractor, didUpdate groups: [Group]) {
        invokedInteractorDidUpdate = true
        invokedInteractorDidUpdateCount += 1
        invokedInteractorDidUpdateParameters = (interactor, groups)
        invokedInteractorDidUpdateParametersList.append((interactor, groups))
    }
    var invokedInteractorDidRemoveGroups = false
    var invokedInteractorDidRemoveGroupsCount = 0
    var invokedInteractorDidRemoveGroupsParameters: (interactor: GroupSourceInteractor, ids: [EntityId])?
    var invokedInteractorDidRemoveGroupsParametersList = [(interactor: GroupSourceInteractor, ids: [EntityId])]()
    func interactor(_ interactor: GroupSourceInteractor, didRemoveGroups ids: [EntityId]) {
        invokedInteractorDidRemoveGroups = true
        invokedInteractorDidRemoveGroupsCount += 1
        invokedInteractorDidRemoveGroupsParameters = (interactor, ids)
        invokedInteractorDidRemoveGroupsParametersList.append((interactor, ids))
    }
    var invokedInteractorDidUpdateGroupsOrder = false
    var invokedInteractorDidUpdateGroupsOrderCount = 0
    var invokedInteractorDidUpdateGroupsOrderParameters: (interactor: GroupSourceInteractor, ids: [EntityId])?
    var invokedInteractorDidUpdateGroupsOrderParametersList = [(interactor: GroupSourceInteractor, ids: [EntityId])]()
    func interactor(_ interactor: GroupSourceInteractor, didUpdateGroupsOrder ids: [EntityId]) {
        invokedInteractorDidUpdateGroupsOrder = true
        invokedInteractorDidUpdateGroupsOrderCount += 1
        invokedInteractorDidUpdateGroupsOrderParameters = (interactor, ids)
        invokedInteractorDidUpdateGroupsOrderParametersList.append((interactor, ids))
    }
}
