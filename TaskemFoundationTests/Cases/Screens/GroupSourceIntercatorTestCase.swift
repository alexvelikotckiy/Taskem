//
//  GroupSourceIntercatorTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/18/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class GroupSourceIntercatorTestCase: XCTestCase {

    var interactor: GroupSourceInteractorDummy!
    
    var interactorSpy: GroupSourceInteractorObserverSpy!
    var sourceSpy: GroupSourceSpy!
    
    var factoryGroups: GroupFactory!
    
    override func setUp() {
        super.setUp()
        
        factoryGroups = .init()
        let groupOne = factoryGroups.make { $0.id = "group_id_1" }
        let groupTwo = factoryGroups.make { $0.id = "group_id_2" }
        
        sourceSpy = .init([groupOne, groupTwo])
        interactorSpy = .init()
        interactor = .init(sourceGroups: sourceSpy)
        interactor.delegate = interactorSpy
    }
    
    func testShouldNotifyOnChangeSourceState() {
        sourceSpy.state = .loading
        
        interactor.sourceDidChangeState(sourceSpy)
        
        expect(self.interactorSpy.lastState) == .loading
    }
    
    func testShouldNotifyOnAdd() {
        let groups = sourceSpy.allGroups
        
        interactor.source(sourceSpy, didAdd: groups)
        
        expect(self.interactorSpy.added) == groups
    }
    
    func testShouldNotifyOnUpdate() {
        let groups = sourceSpy.allGroups
        
        interactor.source(sourceSpy, didUpdate: groups)
        
        expect(self.interactorSpy.updated) == groups
    }
    
    func testShouldNotifyOnRemove() {
        let ids = sourceSpy.allGroups.map { $0.id }
        
        interactor.source(sourceSpy, didRemove: ids)
        
        expect(self.interactorSpy.removed) == ids
    }
    
    func testShouldNotifyOnReorder() {
        let ids = sourceSpy.allGroups.map { $0.id }
        
        interactor.source(sourceSpy, didUpdateOrderSequence: ids)
        
        expect(self.interactorSpy.ordered) == ids
    }
    
    func testShouldAddGroups() {
        let groupOne = factoryGroups.make()
        let groupTwo = factoryGroups.make()
        
        interactor.insertGroups([groupOne, groupTwo])
        
        expect(self.sourceSpy.addedGroups) == [groupOne, groupTwo]
    }
    
    func testShouldUpdateGroups() {
        let groupOne = factoryGroups.make()
        let groupTwo = factoryGroups.make()
        
        interactor.updateGroups([groupOne, groupTwo])
        
        expect(self.sourceSpy.updatedGroups) == [groupOne, groupTwo]
    }
    
    func testShouldRemoveGroups() {
        let idOne = sourceSpy.allGroups[0].id
        let idTwo = sourceSpy.allGroups[1].id

        interactor.removeGroups([idOne, idTwo])

        expect(self.sourceSpy.removedGroups) == [idOne, idTwo]
    }

    func testShouldSetDefaultGroup() {
        let id = sourceSpy.allGroups.first!.id
        
        interactor.setDefaultGroup(id)
        
        expect(self.sourceSpy.lastDefaultGroup) == id
    }
    
    func testShouldReorder() {
        let id = sourceSpy.allGroups.first!.id
        let source = 0
        let destination = 1
        
        interactor.reorderGroup(id, source: source, destination: destination)
        
        expect(self.sourceSpy.lastReorderGroup) == id
        expect(self.sourceSpy.lastReorderSource) == source
        expect(self.sourceSpy.lastReorderDestination) == destination
    }
    
    func testShouldFetchGroups() {
        let predicate: (Group) -> Bool = { $0.id == "group_id_1" }
        
        interactor.fetchGroups(predicate) { result in
            expect(result.count) == 1
            expect(result.first?.id) == "group_id_1"
        }
    }
    
}
