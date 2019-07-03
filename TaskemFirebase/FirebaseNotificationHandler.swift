//
//  FirebaseNotificationHandler.swift
//  TaskemFirebase
//
//  Created by Wilson on 8/24/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import FirebaseAuth
import FirebaseDatabase

public class FirebaseNotificationHandler: NotificationHandlerDataUpdater {
    
    private let coder: _FirebaseTaskCoder = .init()
    
    public init() {
        
    }
    
    public func setTaskAsComplete(by id: EntityId, _ completion: @escaping (() -> Void)) {
        refTasksCurrentUser?.child(id).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let strongSelf = self,
                var task: Task = strongSelf.coder.decode(snapshot) else { return }
            
            task.modify(complete: !task.isComplete)
            refTasksCurrentUser?.updateChildValues(strongSelf.coder.encode([task]))
            completion()
        }
    }
    
    public func setTaskRemindInHour(by id: EntityId, _ completion: @escaping (() -> Void)) {
        
    }
}
