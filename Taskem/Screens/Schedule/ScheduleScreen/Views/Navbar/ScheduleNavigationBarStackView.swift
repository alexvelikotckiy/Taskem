//
//  ScheduleNavigationBarStackView.swift
//  Taskem
//
//  Created by Wilson on 2/17/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class ScheduleNavigationBarStackView: UIStackView {
    
    public var maxWidth: CGFloat = 0
    
    private let defaultSpacing: CGFloat = -15
    
    private var currentCells: [ScheduleNavigationBarCell] {
        return arrangedSubviews as? [ScheduleNavigationBarCell] ?? []
    }
    
    private var currentCellsIds: Set<EntityId> {
        return currentCells.map { $0.id }.set
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        satisfySpacing()
    }
    
    public func reload(_ cells: [ScheduleNavigationBarCell]) {
        let ids = cells.map { $0.id }.set
        
        deletion(from: ids).forEach {
            guard let cell = find($0) else { return }
            removeArrangedSubview(cell)
            cell.removeFromSuperview()
        }
        
        update(from: ids).forEach {
            guard let cell = find($0) else { return }
            reloadIfNeed(cell)
        }
        
        insertion(from: ids).forEach {
            guard let cell = find($0, in: cells) else { return }
            addArrangedSubview(cell)
        }
    }
    
    public func removeAllViews() {
        arrangedSubviews.forEach { removeArrangedSubview($0); $0.removeFromSuperview() }
    }
    
    private func deletion(from ids: Set<EntityId>) -> Set<EntityId> {
        return currentCellsIds.subtracting(ids)
    }
    
    private func insertion(from ids: Set<EntityId>) -> Set<EntityId> {
        return ids.subtracting(currentCellsIds)
    }
    
    private func update(from ids: Set<EntityId>) -> Set<EntityId> {
        return currentCellsIds.intersection(ids)
    }
    
    private func reloadIfNeed(_ cell: ScheduleNavigationBarCell) {
        guard let index = indexOfCell(cell),
            currentCells[index].data != cell.data else { return }
        
        currentCells[index].reload(data: cell.data)
    }
    
    private func find(_ id: EntityId) -> ScheduleNavigationBarCell? {
        return currentCells.first(where: { $0.id == id })
    }
    
    private func find(_ id: EntityId, in array: [ScheduleNavigationBarCell]) -> ScheduleNavigationBarCell? {
        return array.first(where: { $0.id == id })
    }
    
    private func indexOfCell(_ cell: ScheduleNavigationBarCell) -> Int? {
        return currentCells.firstIndex(where: { $0.id == cell.id })
    }
    
    private func isContainCell(_ cell: ScheduleNavigationBarCell) -> Bool {
        return currentCells.contains(where: { $0.id == cell.id })
    }
    
    private func satisfySpacing() {
        let contentSize: CGFloat = CGFloat(currentCells.count) * ScheduleNavigationBarCell.size
        let contentCount: CGFloat = CGFloat(currentCells.count)
        let spacing: CGFloat = -((contentSize - maxWidth) / contentCount)
        let satisfiedSpacing = spacing < defaultSpacing ? spacing : defaultSpacing
        
        guard satisfiedSpacing != self.spacing else { return }
        
        self.spacing = satisfiedSpacing
    }
}
