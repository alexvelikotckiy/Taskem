//
//  ViewModelFactory.swift
//  TaskemFoundation
//
//  Created by Wilson on 1/3/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation

public protocol ViewModelFactory: class {
    associatedtype Context
    
    func produce<T>(from context: Context) -> T?
}

public extension ViewModelFactory {
    func produceAsync<T>(from context: Context, completion: @escaping (T?) -> Void) {
        let dispatchGroup = DispatchGroup()
        var viewModel: T?
        DispatchQueue.global().async(group: dispatchGroup) { [weak self] in
            viewModel = self?.produce(from: context)
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion(viewModel)
        }
    }
}
