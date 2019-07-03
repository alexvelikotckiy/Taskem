//
//  ListViewModel.swift
//  TaskemFoundation
//
//  Created by Wilson on 7/14/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol Section: class, AutoEquatable {
    associatedtype T: Identifiable
    
    var cells: [T] { get set }
}

public extension Section {
    subscript(identity: String) -> T? {
        guard let index = index(for: identity) else { return nil }
        return cells[index]
    }
    
    func insert(_ cell: T, at index: Int) {
        cells.insert(cell, at: index)
    }
    
    func replace(_ cell: T, at index: Int) {
        cells[index] = cell
    }
    
    func remove(at index: Int) {
        cells.remove(at: index)
    }
    
    func cells(for filter: (T) -> Bool) -> [T] {
        return cells.filter { filter($0) }
    }
    
    func index(for cell: T) -> Int? {
        return index(for: cell.id)
    }
    
    func containts(_ cell: T) -> Bool {
        return containts(cell.id)
    }
    
    func containts(_ identity: String) -> Bool {
        return cells.contains(where: { $0.id == identity })
    }
    
    func index(for identity: String) -> Int? {
        return cells.firstIndex(where: { $0.id == identity })
    }
    
    func containts(_ predicate: (T) -> Bool) -> Bool {
        return cells.contains(where: predicate)
    }
}

public protocol List: class, AutoEquatable {
    associatedtype T
    associatedtype U: Section where U.T == T
    
    var sections: [U] { get set }
}

public extension List {
    subscript(index: Int) -> U {
        return sections[index]
    }
    
    subscript(index: IndexPath) -> T {
        get {
            return sections[index.section].cells[index.row]
        }
        set {
            sections[index.section].cells[index.row] = newValue
        }
    }
    
    subscript(indexes: [IndexPath]) -> [T] {
        return indexes.map { sections[$0.section].cells[$0.row] }
    }
    
    subscript(filter: (T) -> Bool) -> [T] {
        return cells(for: filter)
    }
    
    subscript(cell: T) -> IndexPath? {
        return index(for: cell)
    }
    
    subscript(identity: String) -> T? {
        guard let index = index(for: identity) else { return nil }
        return sections[index.section].cells[index.row]
    }
    
    subscript(identities: [String]) -> [T] {
        return identities.reduce(into: []) { result, id in
            guard let index = index(for: id) else { return }
            result.append(sections[index.section].cells[index.row])
        }
    }
    
    func ids(for indexes: [IndexPath]) -> [EntityId] {
        return self[indexes].map { $0.id }
    }
    
    var allCells: [T] {
        return sections.flatMap { $0.cells }
    }
    
    var sectionsIndexes: IndexSet {
        return IndexSet(integersIn: 0..<sectionsCount())
    }
    
    func cellsCount() -> Int {
        return sections.map { $0.cells.count }.reduce(0, +)
    }
    
    func sectionsCount() -> Int {
        return sections.count
    }
    
    func removeSections(at indexes: IndexSet) {
        for index in indexes.reversed() {
            sections.remove(at: index)
        }
    }
    
    func removeFirstSections(_ count: Int) {
        sections.removeFirst(count)
    }
    
    func removeLastSections(_ count: Int) {
        sections.removeLast(count)
    }
    
    func insertSection(_ section: U, at index: Int) {
        sections.insert(section, at: index)
    }
    
    func insertCell(_ cell: T, at index: IndexPath) {
        sections[index.section].insert(cell, at: index.row)
    }
    
    func replace(_ cell: T, at index: IndexPath) {
        sections[index.section].replace(cell, at: index.row)
    }
    
    func remove(at index: IndexPath) {
        sections[index.section].remove(at: index.row)
    }
    
    func move(from source: IndexPath, to destination: IndexPath) -> T {
        let cell = self[source]
        remove(at: source)
        insertCell(cell, at: destination)
        return cell
    }
    
    func cells(for filter: (T) -> Bool) -> [T] {
        return allCells.filter { filter($0) }
    }
    
    func first(for filter: (T) -> Bool) -> T? {
        return allCells.filter(filter).first
    }
    
    func contains(at index: IndexPath) -> Bool {
        if sections.count - 1 < index.section {
            return false
        }
        if sections[index.section].cells.count - 1 < index.row {
            return false
        }
        return true
    }
    
    func index(for identity: String) -> IndexPath? {
        if let section = sections.firstIndex(where: { $0.containts(identity) }),
            let row = sections[section].index(for: identity) {
            return .init(row: row, section: section)
        }
        return nil
    }
    
    func index(for cell: T) -> IndexPath? {
        if let section = sections.firstIndex(where: { $0.containts(cell) }),
            let row = sections[section].index(for: cell) {
            return .init(row: row, section: section)
        }
        return nil
    }
    
    func index(_ predicate: (T) -> Bool) -> IndexPath? {
        if let sectionIndex = sections.firstIndex(where: { $0.containts(predicate) }),
            let rowIndex = sections[sectionIndex].cells.firstIndex(where: predicate) {
            return .init(row: rowIndex, section: sectionIndex)
        }
        return nil
    }
}
