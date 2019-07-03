//
//  TaskTableUpdateSourceDelegate.swift
//  TaskemFoundation
//
//  Created by Wilson on 30.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol ObservableTableAdapterDelegate: class {
    func didBeginTaskTableUpdate()
    func didEndTaskTableUpdate()
    func willBeginTaskTableUpdate(at index: IndexPath)
    func reloadTaskTableSections(at indexes: IndexSet)
    func insertTaskTableSections(at indexes: IndexSet)
    func insertTaskTableRows(at indexes: [IndexPath])
    func updateTaskTableRows(at indexes: [IndexPath])
    func deleteTaskTableRows(at indexes: [IndexPath])
    func moveTaskTableRow(from: IndexPath, to index: IndexPath)
    func deleteTaskTableSections(indexes: IndexSet)
}

public protocol ObservableList {
    associatedtype Element
}

protocol ObservableSection: ObservableList {
    var cellCount: Int { get }
    var taskCells: [Element] { get }

    func cells(for filter: (Element) -> Bool) -> [Element]
    func insert(_ cell: Element, at index: Int)
    func replace(_ cell: Element, at index: Int)
    func remove(at index: Int)
}

protocol ObservableListData: ObservableList {
    var cellCount: Int { get }

    func cell(for indexPath: IndexPath) -> Element
    func cells(for indexes: [IndexPath]) -> [Element]
    func cells(for filter: (Element) -> Bool) -> [Element]
    func insert(cell: Element, at index: IndexPath)
    func replace(cell: Element, at index: IndexPath)
    func remove(cell atIndex: IndexPath)

    var sectionCount: Int { get }
    var taskSections: [ObservableSection] { get }

    func section(for index: Int) -> ObservableSection
    func append(section: ObservableSection)
    func insert(section: ObservableSection, at index: Int)
    func removeSections(at indexes: IndexSet)
}
