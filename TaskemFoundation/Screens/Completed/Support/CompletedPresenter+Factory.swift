//
//  CompletedViewModelFactory.swift
//  TaskemFoundation
//
//  Created by Wilson on 7/22/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol CompletedCellConvertible {
    var convertToCompleted: CompletedViewModel { get }
}

public typealias CompletedCellsConvertible = [CompletedCellConvertible]

extension CompletedViewModel: CompletedCellConvertible {
    public var convertToCompleted: CompletedViewModel {
        return self
    }
}

extension TaskModel: CompletedCellConvertible {
    public var convertToCompleted: CompletedViewModel {
        return .init(model: self)
    }
}

extension CompletedPresenter: ViewModelFactory {
    public func produce<T>(from context: CompletedPresenter.Context) -> T? {
        switch context {
        case .list(let data):
            return list(data) as? T
        case .sections(let data):
            return sections(data) as? T
        case .cells(let data):
            return cells(data) as? T
        }
    }
    
    public enum Context {
        case list(CompletedCellsConvertible)
        case sections(CompletedCellsConvertible)
        case cells(CompletedCellsConvertible)
    }
}

private extension CompletedPresenter {
    func list(_ data: CompletedCellsConvertible) -> CompletedListViewModel {
        return CompletedListViewModel(sections: sections(data))
    }
    
    func sections(_ data: CompletedCellsConvertible) -> [CompletedSectionViewModel] {
        let cells = self.cells(data)
        return CompletedStatus.allCases.reduce(into: []) { result, status in
            let content = cells
                .filter(filter(status: status))
                .sorted(by: sorting)
            
            guard !cells.isEmpty else { return }
            result.append(CompletedSectionViewModel(cells: content, status: status))
        }
    }
    
    func cells(_ data: CompletedCellsConvertible) -> [CompletedViewModel] {
        return data.map { $0.convertToCompleted }
    }
}
