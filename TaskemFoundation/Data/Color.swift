//
//  Color.swift
//  TaskemFoundation
//
//  Created by Wilson on 06.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct Color: Codable {
    public let red: Int
    public let green: Int
    public let blue: Int

    public init(red: Int, green: Int, blue: Int) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    public enum CodingKeys: String, CodingKey {
        case hex
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let hex = try values.decode(String.self, forKey: .hex)
        self.init(hex: hex)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hex, forKey: .hex)
    }
}

extension Color: Equatable {
    public static func == (color1: Color, color2: Color) -> Bool {
        return color1.red == color2.red &&
            color1.blue == color2.blue &&
            color1.green == color2.green
    }
}

public extension Color {
    static var white: Color {
        return Color(red: 255, green: 255, blue: 255)
    }

    static var black: Color {
        return Color(red: 0, green: 0, blue: 0)
    }
}

extension Color {
    public init(_ color: UIColor) {
        self.init(hex: color.toHexString())
    }
    
    public init(hex hexString: String) {
        var red = 0
        var green = 0
        var blue = 0
        var minusLength = 0

        let normalizedHexString = hexString.lowercased()

        let scanner = Scanner(string: normalizedHexString)

        if normalizedHexString.hasPrefix("#") {
            scanner.scanLocation = 1
            minusLength = 1
        }
        if normalizedHexString.hasPrefix("0x") {
            scanner.scanLocation = 2
            minusLength = 2
        }
        var hexValue: UInt64 = 0
        scanner.scanHexInt64(&hexValue)
        switch hexString.count - minusLength {
        case 6:
            red = Int((hexValue & 0xFF0000) >> 16)
            green = Int((hexValue & 0x00FF00) >> 8)
            blue = Int(hexValue & 0x0000FF)
        default:
            break
        }
        self.init(red: Int(red), green: Int(green), blue: Int(blue))
    }

    public var hex: String {
        return String(format: "%02lX%02lX%02lX", red, green, blue)
    }
}

extension Color: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String

    public init(stringLiteral value: Color.StringLiteralType) {
        self.init(hex: value)
    }
}

extension Color {
    public static let defaultColor = TaskemLists.blue.color
}
