//
//  String+Helpers.swift
//  Taskem
//
//  Created by Wilson on 16.12.2017.
//  Copyright © 2017 Wilson. All rights reserved.
//

import Foundation

public extension String {
    var byLines: [String] {
        var byLines: [String] = []
        enumerateSubstrings(in: startIndex..<endIndex, options: .byLines) {
            guard let line = $0 else { return }
            print($1, $2, $3)
            byLines.append(line)
        }
        return byLines
    }

    func firstLine(_ max: Int) -> [String] {
        return Array(byLines.prefix(max))
    }

    var firstLine: String {
        return byLines.first ?? ""
    }

    func lastLine(_ max: Int) -> [String] {
        return Array(byLines.suffix(max))
    }

    var lastLine: String {
        return byLines.last ?? ""
    }

    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)
    }

    static func validatePass(_ pass: String) -> Bool {
        return pass.count >= 6
    }
    
    static func validateMail(_ mail: String) -> Bool {
        let format = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", format)
        return predicate.evaluate(with: mail)
    }
    
    static func validateName(_ name: String) -> Bool {
        let format = "[A-Za-z]{1,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", format)
        return predicate.evaluate(with: name)
    }
}
