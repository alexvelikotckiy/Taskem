//
//  UserProfilePresenter.swift
//  Taskem
//
//  Created by Wilson on 25/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class UserProfilePresenter: UserProfileViewDelegate {
    
    public unowned var view: UserProfileView
    public var router: UserProfileRouter
    public var interactor: UserProfileInteractor

    public init(
        view: UserProfileView,
        router: UserProfileRouter,
        interactor: UserProfileInteractor
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        //
        self.interactor.delegate = self
        self.view.delegate = self
    }

    public func onSelect(at index: IndexPath) {
        switch view.viewModel[index].item {
        case .name, .email:
            break
            
        case .deleteAccount:
            router.alertDestructive(
            title: "Delete account?",
            message: "You will delete all you tasks and information about them. This action can't be undone.") { [weak self] confirmation in
                guard let strongSelf = self, confirmation else { return }
                strongSelf.refreshState(.loading)
                strongSelf.interactor.deleteAccount()
            }
            
        case .resetPass:
            router.alertDefault(
            title: "Reset password",
            message: "Continue and we will send on your email recover instructions.") { [weak self] confirmation in
                guard let strongSelf = self, confirmation else { return }
                strongSelf.refreshState(.loading)
                strongSelf.interactor.resetPassword()
            }
            
        case .signOut:
            router.alertDestructive(
            title: "Sign Out",
            message: "Sign out from Taskem?") { [weak self] confirmation in
                guard let strongSelf = self, confirmation else { return }
                strongSelf.refreshState(.loading)
                strongSelf.interactor.signOut()
            }
        }
    }
    
    public func onViewWillAppear() {
        reloadAll()
    }

    private func display(_ viewModel: UserProfileListViewModel) {
        view.display(viewModel)
    }
    
    private func reloadAll() {
        guard let user = interactor.currentUser() else { return }
        let viewModel = produceViewModel(user: user)
        display(viewModel)
    }
}

private extension UserProfilePresenter {
    func produceViewModel(user: User) -> UserProfileListViewModel {
        let name = UserProfileViewModel(
            item: .name,
            title: "Login",
            accessory: .none,
            icon: .init(Images.Foundation.icUserprofileLogin),
            description: user.name ?? ""
        )
        
        let email = UserProfileViewModel(
            item: .email,
            title: "Email",
            accessory: .none,
            icon: .init(Images.Foundation.icUserprofileEmail),
            description: user.email ?? ""
        )
        
        let deleteAccount = UserProfileViewModel(
            item: .deleteAccount,
            title: "Delete account",
            accessory: .none,
            icon: .init(Images.Foundation.icUserprofileDeleteAccount)
        )
        
        let resetPass = UserProfileViewModel(
            item: .resetPass,
            title: "Reset password",
            accessory: .none,
            icon: .init(Images.Foundation.icUserprofileResetPass)
        )
        
        let signOut = UserProfileViewModel(
            item: .signOut,
            title: "Sign out",
            accessory: .none,
            icon: .init(Images.Foundation.icUserprofileSignOut)
        )
        
        let dateFomatter = DateFormatter()
        dateFomatter.timeStyle = .none
        dateFomatter.dateStyle = .long
        var infoFooter = ""
        if let creationDate = user.creationDate {
            let dateString = dateFomatter.string(from: creationDate)
            infoFooter = "Account created at \(dateString)."
        }
        
        let infoSection = UserProfileSectionViewModel(
            title: "Info",
            footer: infoFooter,
            cells: [name, email]
        )
        
        let accountSection = UserProfileSectionViewModel(
            title: "Acount",
            footer: "",
            cells: [deleteAccount, resetPass, signOut]
        )
        
        return .init(sections: [infoSection, accountSection])
    }
}

fileprivate extension UserProfilePresenter {
    enum State: Int {
        case loading
        case loaded
    }
    
    func refreshState(_ state: State) {
        switch state {
        case .loading:
            view.displaySpinner(true)
        case .loaded:
            view.displaySpinner(false)
        }
    }
}

extension UserProfilePresenter: UserProfileInteractorOutput {
    public func userprofileInteractorDidSignOut(_ interactor: UserProfileInteractor) {
        refreshState(.loaded)
    }
    
    public func userprofileInteractorDidDeleteAccount(_ interactor: UserProfileInteractor) {
        refreshState(.loaded)
    }
    
    public func userprofileInteractorDidSendPasswordReset(_ interactor: UserProfileInteractor) {
        refreshState(.loaded)
    }
    
    public func userprofileInteractorDidFail(_ interactor: UserProfileInteractor, didFailSignOut error: String) {
        refreshState(.loaded)
        router.alert(title: "Did fail to sign out", message: error.description)
    }
    
    public func userprofileInteractorDidFail(_ interactor: UserProfileInteractor, didFailDeleteAccount error: String) {
        refreshState(.loaded)
        router.alert(title: "Did fail to delete account", message: error.description)
    }
    
    public func userprofileInteractorDidFail(_ interactor: UserProfileInteractor, didFailResetPass error: String) {
        refreshState(.loaded)
        router.alert(title: "Did fail to reset password", message: error.description)
    }
}
