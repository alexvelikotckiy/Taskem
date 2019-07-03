//
//  ListTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/28/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class ListTestCase: XCTestCase {

    private var list: ListDoubles!
    
    override func setUp() {
        super.setUp()
    
        continueAfterFailure = false
        
        list = ListDoublesStub.makeFullList()
    }

    func testSectionSubscript() {
        let firstSection = list[0]
        
        expect(firstSection.id) == list.sections[0].id
    }
    
    func testCellGetSubscript() {
        let firstCell = list[IndexPath(row: 0, section: 0)]
        
        expect(firstCell.id) == list.sections[0].cells[0].id
    }
    
    func testCellSetSubscript() {
        let newCell = ListCellDoubles(value: 5)
        
        list[IndexPath(row: 0, section: 0)] = newCell
        
        expect(newCell.id) == list.sections[0].cells[0].id
    }
    
    func testCellsBySubscript() {
        let indexes = [IndexPath(row: 0, section: 0), IndexPath(row: 0, section: 1)]
        
        let cells = list[indexes]
        
        expect(cells[0].id) == list.sections[0].cells[0].id
        expect(cells[1].id) == list.sections[1].cells[0].id
    }
    
    func testCellByIndexPathSubcript() {
        let cell = list.sections[0].cells[0]
        
        let index = list[cell]!
        
        expect(index) == IndexPath(row: 0, section: 0)
    }
    
    func testCellsByPredicateSubscript() {
        let predicate: ((ListCellDoubles) -> Bool) = { $0.value == 2 }
        
        let cells = list[predicate]
        
        expect(cells.count) == 1
        expect(cells[0].id) == list.sections[0].cells[0].id
    }
    
    func testCellByIdentitySubscript() {
        let id = list.sections[1].cells[0].id
        
        let cellOnList = list[id]!
        let cellOnSection = list.sections[1][id]!
        
        expect(cellOnList.id) == id
        expect(cellOnSection.id) == id
    }
    
    func testCellsByIdentitySubscript() {
        let ids = [list.sections[1].cells[0].id, list.sections[0].cells[0].id]
        
        let cells = list[ids]
        
        expect(cells.count) == 2
        expect(cells[0].id) == ids[0]
        expect(cells[1].id) == ids[1]
    }
    
    func testSectionRemoveLast() {
        list.removeLastSections(1)
        
        expect(self.list.sectionsCount()) == 1
        expect(self.list.cellsCount()) == 2
    }
    
    func testSectionRemoveFirst() {
        list.removeFirstSections(1)
        
        expect(self.list.sectionsCount()) == 1
        expect(self.list.cellsCount()) == 2
    }
    
    func testContainAtIndex() {
        let validIndex = IndexPath(row: 0, section: 0)
        let wrongIndex = IndexPath(row: 5, section: 4)
        
        let containtsValid = list.contains(at: validIndex)
        let containtsWong = list.contains(at: wrongIndex)
        
        expect(containtsValid) == true
        expect(containtsWong) == false
    }
    
    func testDataActions() {
        let newCell = ListCellDoubles(value: 5)
        let newSection = ListSectionDoubles(cells: [])
        
        list.insertSection(newSection, at: 2)
        expect(self.list.sections.count) == 3
        expect(self.list.sections[2].id) == newSection.id
        
        list.insertCell(newCell, at: .init(row: 0, section: 2))
        expect(self.list[.init(row: 0, section: 2)].id) == newCell.id
        
        list.replace(newCell, at: .init(row: 0, section: 0))
        expect(self.list[.init(row: 0, section: 0)].id) == newCell.id
        
        list.remove(at: .init(row: 0, section: 0))
        expect(self.list[0].cells.count) == 1
    }
    
    func testMoveRows() {
        let idCell = list[.init(row: 0, section: 0)].id
        
        let moved = list.move(from: .init(row: 0, section: 0), to: .init(row: 0, section: 1))
        
        expect(self.list.sections[0].cells.count) == 1
        expect(self.list.sections[1].cells.count) == 3
        expect(self.list.sections[1].cells[0].id) == idCell
        expect(moved.id) == idCell
    }
    
    func testIndexForPredicate() {
        let predicate: ((ListCellDoubles) -> Bool) = { $0.value == 1 }
        
        let index = list.index(predicate)!
        
        expect(index) == .init(row: 0, section: 1)
    }
    
    func testCellsForPredicate() {
        let predicate: ((ListCellDoubles) -> Bool) = { $0.value == 2 }
        
        let cellOnList = list.first(for: predicate)!
        let cellsOnSection = list.sections[0].cells(for: predicate)
        
        expect(cellOnList.value) == 2
        expect(cellsOnSection.count) == 1
        expect(cellsOnSection[0].value) == 2
    }
    
}
