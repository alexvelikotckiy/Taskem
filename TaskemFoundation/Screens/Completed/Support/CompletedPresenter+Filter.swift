//
//  CompletedFilterProducer.swift
//  TaskemFoundation
//
//  Created by Wilson on 7/23/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

extension CompletedPresenter {
    public func filter(status: CompletedStatus) -> (CompletedViewModel) -> Bool {
        return { $0.model.completedStatus == status }
    }
    
    public func sorting(_ lhs: CompletedViewModel, _ rhs: CompletedViewModel) -> Bool {
        return Task.compareByCompletion(lhs: lhs.model.task, rhs: rhs.model.task)
    }
}
