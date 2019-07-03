//
//  TableView+Getters.swift
//  Taskem
//
//  Created by Wilson on 11.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

extension UITableView {

    func register<T: UITableViewCell>(cell: T.Type, bundle: Bundle? = nil) {
        self.register(UINib(nibName: "\(cell)", bundle: bundle), forCellReuseIdentifier: "\(cell)")
    }

    func dequeueReusableCell<T: UITableViewCell>() -> T {
        return self.dequeueReusableCell(T.self)
    }

    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type) -> T {
        return self.dequeueReusableCell(withIdentifier: "\(T.self)") as! T
    }

    func register<T: UITableViewHeaderFooterView>(header: T.Type, bundle: Bundle? = nil) {
        self.register(UINib(nibName: "\(header)", bundle: bundle), forHeaderFooterViewReuseIdentifier: "\(header)")
    }

    func dequeueReusableHeader<T: UITableViewHeaderFooterView>() -> T {
        return self.dequeueReusableHeader(T.self)
    }

    func dequeueReusableHeader<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: "\(T.self)") as! T
    }

}

extension UITableView {
    var indexesOfTable: [IndexPath] {
        var result: [IndexPath] = []
        for section in 0..<numberOfSections {
            for row in 0..<numberOfRows(inSection: section) {
                result.append(.init(row: row, section: section))
            }
        }
        return result
    }
    
    func deselect(at indexes: [IndexPath], animated: Bool) {
        indexes.forEach { deselectRow(at: $0, animated: animated) }
    }
    
    func select(at indexes: [IndexPath], animated: Bool) {
        indexes.forEach { selectRow(at: $0, animated: animated, scrollPosition: .none) }
    }
}
