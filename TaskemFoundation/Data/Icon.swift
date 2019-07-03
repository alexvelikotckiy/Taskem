//
//  Icon.swift
//  TaskemFoundation
//
//  Created by Wilson on 07.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct Icon {
    public let name: String
    public let bundle: Bundle

    public init(name: String) {
        self.name = name
        self.bundle = .taskemFoundation
    }
}

extension Icon: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    public init(stringLiteral value: StringLiteralType) {
        self.init(name: value)
    }
}

extension Icon: Equatable {
    public static func == (lhs: Icon, rhs: Icon) -> Bool {
        return lhs.name == rhs.name && lhs.bundle == lhs.bundle
    }
}

extension Icon: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decode(String.self, forKey: .name)
        self.bundle = .taskemFoundation
    }

    public enum CodingKeys: String, CodingKey {
        case name
    }
}

extension Icon {
    public init(_ image: ImageAsset) {
        self.init(name: image.name)
    }
}

extension ImageAsset {
    public var icon: Icon {
        return .init(self)
    }
}

extension Icon {
    public static let defaultIcon = Icon(Images.Lists.icEmailinbox)
}
