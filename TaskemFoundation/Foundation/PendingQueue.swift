//
//  PendingQueue.swift
//  TaskemFoundation
//
//  Created by Wilson on 11/5/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct PendingQueue {
    public var queue: OperationQueue = .main
    
    public var isPaused: Bool = false
    private var isCached: Bool = false
    
    private var cache: [Operation] = []
    
    init() {
        
    }
    
    public mutating func add(_ block: @escaping () -> Void) {
        add(BlockOperation(block: block))
    }
    
    public mutating func add(_ operation: Operation) {
        if isPaused {
            if isCached {
                cache.append(operation)
            }
        } else {
            queue.addOperation(operation)
        }
    }
    
    public mutating func pause(cacheOperations: Bool) {
        isPaused = true
        isCached = cacheOperations
    }
    
    public mutating func proceed() {
        isPaused = false
        isCached = false
        
        cache.forEach { queue.addOperation($0) }
        cache.removeAll()
    }
}
