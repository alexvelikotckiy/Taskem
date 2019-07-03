//
//  FirebaseUserServise.swift
//  TaskemFoundation
//
//  Created by Wilson on 6/12/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import TaskemFoundation
import GoogleSignIn

public class FirebaseUserServise: UserService {
    
    public var observers: ObserverCollection<UserObserver> = .init()
    
    private var listener: AuthStateDidChangeListenerHandle?
    
    public var user: User? {
        didSet {
            notifyDidUpdateUser(user: user)
        }
    }
    
    private let coder: _FirebaseUserCoder = .init()
    
    public init() {
        
    }

    deinit {
        stop()
    }
    
    public func start() {
        if let authUser = Auth.auth().currentUser {
            user = User(authUser: authUser)
        }
        
        listener = auth.addStateDidChangeListener { [weak self] _, authUser in
            guard let strongSelf = self else { return }
            if let authUser = authUser {
                let user = User(authUser: authUser)
                if user != strongSelf.user {
                    strongSelf.user = user
                }
            } else {
                if strongSelf.user != nil {
                    strongSelf.user = nil
                }
            }
        }
        
//        signOut { _ in }
//        deleteUser { _ in }
    }

    public func stop() {
        guard let listener = listener else { return }
        auth.removeStateDidChangeListener(listener)
    }

    private var auth: Auth {
        return Auth.auth()
    }
    
    public func signInAnonymously(_ completion: @escaping (Result<User, UserError>) -> Void) {
        auth.signInAnonymously { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                completion(.failure(UserError(rawValue: error._code)))
            } else if let authResult = authResult {
                strongSelf.verifyIsNewUser(authResult) { user in
                    if user.isNew! { strongSelf.configureNewUser(authResult.user) }
                    completion(.success(user))
                }
            }
        }
    }

    public func signIn(_ bean: UserBean, _ completion: @escaping (Result<User, UserError>) -> Void) {
        auth.signIn(withEmail: bean.email, password: bean.pass) { authResult, error in
            if let error = error {
                completion(.failure(UserError(rawValue: error._code)))
            } else if let authResult = authResult {
                completion(.success(.init(authUser: authResult.user)))
            }
        }
    }

    public func signIn(_ user: GIDGoogleUser, _ completion: @escaping (Result<User, UserError>) -> Void) {
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(
            withIDToken: authentication.idToken,
            accessToken: authentication.accessToken
        )
        signIn(with: credential, completion)
    }

    private func signIn(with credential: AuthCredential, _ completion: @escaping (Result<User, UserError>) -> Void) {
        auth.signInAndRetrieveData(with: credential) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                completion(.failure(UserError(rawValue: error._code)))
            } else if let authResult = authResult {
                strongSelf.verifyIsNewUser(authResult) { user in
                    if user.isNew ?? true { strongSelf.configureNewUser(authResult.user) }
                    completion(.success(user))
                }
            }
        }
    }

    public func signUp(_ bean: UserBean, _ completion: @escaping (Result<User, UserError>) -> Void) {
        auth.createUser(withEmail: bean.email, password: bean.pass) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                completion(.failure(UserError(rawValue: error._code)))
            } else if let authResult = authResult {
                strongSelf.verifyIsNewUser(authResult) { user in
                    if user.isNew! { strongSelf.configureNewUser(authResult.user) }
                    strongSelf.changeProfileInfo(authResult.user, bean)
                    completion(.success(user))
                }
            }
        }
    }

    public func resetPassword(_ email: String, _ completion: @escaping (UserError?) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                 completion(UserError(rawValue: error._code))
            } else {
                completion(nil)
            }
        }
    }

    public func signOut(_ completion: @escaping (UserError?) -> Void) {
        do {
            try auth.signOut()
        } catch let signOutError {
            completion(UserError(rawValue: signOutError._code))
        }
    }

    public func deleteUser(_ completion: @escaping (UserError?) -> Void) {
        let userId = auth.currentUser?.uid ?? ""
        auth.currentUser?.delete { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                completion(UserError(rawValue: error._code))
            } else {
                strongSelf.removeAllData(userId)
                completion(nil)
            }
        }
    }

    private func changeProfileInfo(_ authUser: FIRUser, _ bean: UserBean) {
        let request = authUser.createProfileChangeRequest()
        request.displayName = bean.name
        request.commitChanges { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.updateUserInfo(authUser)
            
            let user = User(authUser: authUser)
            if user != strongSelf.user {
                strongSelf.user = user
            }
        }
    }

    private func verifyIsNewUser(_ authResult: AuthDataResult, _ completion: @escaping (User) -> Void) {
        refUsers.child(authResult.user.uid).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                completion(.init(authUser: authResult.user, isNew: false))
            } else {
                completion(.init(authUser: authResult.user, isNew: true))
            }
        }
    }

    private func configureNewUser(_ authUser: FIRUser) {
        authUser.sendEmailVerification()
        fillDefaultData(authUser)
    }
    
    private func updateUserInfo(_ authUser: FIRUser) {
        let data = coder.encode(authUser)
        refUsers.child(authUser.uid).updateChildValues(data)
    }
    
    private func fillDefaultData(_ authUser: FIRUser) {
        let data = coder.encode(new: authUser)
        refBase.updateChildValues(data)
    }
    
    private func removeAllData(_ userId: String) {
        let data = coder.encodeEmpty(id: userId)
        refBase.updateChildValues(data)
    }
}

fileprivate class _FirebaseUserCoder: _FirebaseEncoder, _FirebaseDecoder {
    func encodeEmpty(id userId: String) -> [String: Any] {
        return [
            "/groups/\(userId)/" : NSNull(),
            "/tasks/\(userId)/"  : NSNull(),
            "/users/\(userId)/"  : NSNull()
        ]
    }
    
    func encode(new authUser: FIRUser) -> [String: Any] {
        var user = encode(authUser)
        user["created"] = String(Date().timeIntervalSince1970)
        
        return [
            "/users/\(authUser.uid)/" : user
        ]
    }
    
    func encode(_ authUser: FIRUser) -> [String: Any] {
        return [
            "email": authUser.email ?? "",
            "name": authUser.displayName ?? ""
        ]
    }
}

private extension User {
    init(authUser: FIRUser, isNew: Bool = false) {
        self.init(
            id: authUser.uid,
            name: authUser.displayName,
            email: authUser.email,
            creationDate: authUser.metadata.creationDate,
            isAnonymous: authUser.isAnonymous,
            isVerifiedEmail: authUser.isEmailVerified,
            isNew: isNew
        )
    }
}
