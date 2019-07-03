////
////  RescheduleViewModelFactory.swift
////  TaskemFoundation
////
////  Created by Wilson on 8/22/18.
////  Copyright © 2018 Wilson. All rights reserved.
////

extension ReschedulePresenter: ViewModelFactory {
    
    public func produce<T>(from context: ReschedulePresenter.Context) -> T? {
        switch true {
        case T.self == RescheduleListViewModel.self:
            let value: RescheduleListViewModel = produce(from: context)
            return value as? T
            
        case T.self == [RescheduleViewModel].self:
            let value: [RescheduleViewModel] = produce(from: context)
            return value as? T
            
        default:
            return nil
        }
    }
    
    public struct Context: Equatable, CustomInitial {
        public var tasks: [TaskModel] = []
        public var skip: [EntityId] = []
        public var toolbar: RescheduleListViewModel.Toolbar = .edit
        
        public init() {}
    }
    
    private func produce(from context: Context) -> RescheduleListViewModel {
        return .init(cards: produce(from: context),
                     toolbar: context.toolbar)
    }
    
    private func produce(from context: Context) -> [RescheduleViewModel] {
        return context.tasks
            .sort(by: sortDescriptor)
            .filter { $0.completionDate == nil }
            .filter { $0.estimateDate != nil }
            .filter { !context.skip.contains($0.id) }
            .map { .init(model: $0) }
    }
    
    private var sortDescriptor: SortDescriptor<TaskModel> {
        return { lhs, rhs in
            guard lhs.estimateDate != nil, rhs.estimateDate != nil else { return nil }
            
            let dateComparison = lhs.estimateDate!.compare(rhs.estimateDate!)
            guard dateComparison == .orderedSame else {
                return dateComparison == .orderedAscending
            }
            return lhs.name < rhs.name
        }
    }
}
