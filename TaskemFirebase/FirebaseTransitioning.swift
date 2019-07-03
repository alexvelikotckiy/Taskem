//
//  FirebaseTransitioning.swift
//  TaskemFoundation
//
//  Created by Wilson on 6/14/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import FirebaseDatabase
import TaskemFoundation
import CodableFirebase

internal protocol _FirebaseEncoder { }

extension _FirebaseEncoder {
    func encode<T: Encodable>(_ ecodable: T) -> Any? {
        do {
            return try FirebaseEncoder().encode(ecodable)
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}

internal protocol _FirebaseDecoder {}

extension _FirebaseDecoder {
    func decode<T: Decodable>(_ snapshot: DataSnapshot) -> T? {
        guard snapshot.exists(), let value = snapshot.value as? [String: Any] else { return nil }
        do {
            return try FirebaseDecoder().decode(T.self, from: value)
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}
