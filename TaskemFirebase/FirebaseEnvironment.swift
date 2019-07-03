//
//  FirebaseEnvironment.swift
//  Taskem
//
//  Created by Wilson on 1/30/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore

public typealias User = TaskemFoundation.User
public typealias FIRUser = FirebaseAuth.User

#if DEBUG
let firebaseInfo = "GoogleService-Info-Development"
#else
let firebaseInfo = "GoogleService-Info-Production"
#endif

public class FirebaseEnvironment {
    
    public class func app() -> FirebaseApp? {
        return FirebaseApp.app()
    }
    
    public class func configure() {
        let firebaseConfig = Bundle.taskemFirebase.path(forResource: firebaseInfo, ofType: "plist") ?? ""
        
        guard let options = FirebaseOptions(contentsOfFile: firebaseConfig) else {
            fatalError("Invalid Firebase configuration file.")
        }
        FirebaseApp.configure(options: options)
        Database.database().isPersistenceEnabled = true
    }
    
    internal static var DB_BASE: DatabaseReference {
        return Database.database().reference()
    }
    internal static var _REF_BASE: DatabaseReference {
        return DB_BASE
    }
    internal static var _REF_GROUPS: DatabaseReference {
        return DB_BASE.child("groups")
    }
    internal static var _REF_TASKS: DatabaseReference {
        return DB_BASE.child("tasks")
    }
    internal static var _REF_USERS: DatabaseReference {
        return DB_BASE.child("users")
    }
}

internal var refBase: DatabaseReference {
    return FirebaseEnvironment._REF_BASE
}

internal var refGroups: DatabaseReference {
    return FirebaseEnvironment._REF_GROUPS
}

internal var refTasks: DatabaseReference {
    return FirebaseEnvironment._REF_TASKS
}

internal var refUsers: DatabaseReference {
    return FirebaseEnvironment._REF_USERS
}
