//
//  UserProfileViewModel.swift
//  Taskem
//
//  Created by Wilson on 25/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct UserProfileViewModel: Identifiable, Equatable {
    public var item: Item
    public var title: String
    public var description: String?
    public var accessory: Accessory
    public var icon: Icon
    
    public init(item: Item,
                title: String,
                accessory: Accessory,
                icon: Icon,
                description: String? = nil) {
        self.title = title
        self.description = description
        self.item = item
        self.accessory = accessory
        self.icon = icon
    }
    
    public var id: EntityId {
        return "\(item.rawValue)"
    }
}

public extension UserProfileViewModel {
    enum Accessory: Int {
        case none
        case present
        case checked
    }
}

public extension UserProfileViewModel {
    enum Item: Int {
        case name
        case email
        case deleteAccount
        case resetPass
        case signOut
    }
}

public class UserProfileSectionViewModel: Section {
    public typealias T = UserProfileViewModel
    
    public var title: String
    public var footer: String
    
    public var cells: [UserProfileViewModel]
    
    public init(title: String,
                footer: String,
                cells: [UserProfileViewModel]) {
        self.title = title
        self.footer = footer
        self.cells = cells
    }
}

public class UserProfileListViewModel: List {
    public typealias T = UserProfileViewModel
    public typealias U = UserProfileSectionViewModel
    
    public var sections: [UserProfileSectionViewModel]
    
    public init() {
        self.sections = []
    }
    
    public init(sections: [UserProfileSectionViewModel]) {
        self.sections = sections
    }
}
