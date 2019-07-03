//
//  ListTestDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/28/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

struct ListCellDoubles: Identifiable {
    var id: EntityId = .auto()
    var value: Int = 0
    
    var isEven: Bool {
        return value % 2 == 0
    }
    
    init(value: Int) {
        self.value = value
    }
    
    init(id: EntityId, value: Int) {
        self.id = id
        self.value = value
    }
}

class ListSectionDoubles: Section {
    typealias T = ListCellDoubles
    
    var cells: [ListCellDoubles] = []
    var id: EntityId = .auto()
    var sectionType: SectionType!
    
    init() {
        
    }
    
    init(cells: [T]) {
        self.cells = cells
    }
    
    init(cells: [T], type: SectionType) {
        self.cells = cells
        self.sectionType = type
    }
    
    enum SectionType: Int {
        case even = 0
        case odd
                
        static func resolveType(_ value: Int) -> SectionType {
            if value % 2 == 0 {
                return .even
            } else {
                return .odd
            }
        }
    }
}

class ListDoubles: List {
    typealias T = ListCellDoubles
    typealias U = ListSectionDoubles
    
    var sections: [ListSectionDoubles] = []
    
    init(sections: [U]) {
        self.sections = sections
    }
}

class ListDoublesStub {
    static func makeFullList() -> ListDoubles {
        let firstCell = ListCellDoubles(value: 1)
        let secondCell = ListCellDoubles(value: 2)
        let thirdCell = ListCellDoubles(value: 3)
        let fourthCell = ListCellDoubles(value: 4)
        
        let firstSection = ListSectionDoubles(cells: [secondCell, fourthCell], type: .even)
        let secondSection = ListSectionDoubles(cells: [firstCell, thirdCell], type: .odd)
        
        return ListDoubles(sections: [firstSection, secondSection])
    }
    
    static func makeEvenList() -> ListDoubles {
        let firstCell = ListCellDoubles(value: 2)
        let secondCell = ListCellDoubles(value: 4)
        
        let section = ListSectionDoubles(cells: [firstCell, secondCell], type: .even)
        
        return ListDoubles(sections: [section])
    }
    
    static func makeOddList() -> ListDoubles {
        let firstCell = ListCellDoubles(value: 1)
        let secondCell = ListCellDoubles(value: 3)
        
        let section = ListSectionDoubles(cells: [firstCell, secondCell], type: .odd)
        
        return ListDoubles(sections: [section])
    }
}
