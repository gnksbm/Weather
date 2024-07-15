//
//  DateFormat.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import Foundation

enum DateFormat: String {
    case temp = "yyyy.MM.dd (E)"
}
extension DateFormat {
    private static var cachedStorage = [DateFormat: DateFormatter]()
    
    var formatter: DateFormatter {
        if let formatter = Self.cachedStorage[self] {
            return formatter
        } else {
            let newFormatter = DateFormatter()
            newFormatter.dateFormat = rawValue
            newFormatter.locale = Locale(identifier: "ko_KR")
            Self.cachedStorage[self] = newFormatter
            return newFormatter
        }
    }
}

extension String {
    func formatted(dateFormat: DateFormat) -> Date? {
        dateFormat.formatter.date(from: self)
    }
    
    func formatted(input: DateFormat, output: DateFormat) -> String? {
        input.formatter.date(from: self)?.formatted(dateFormat: output)
    }
}

extension Date {
    func formatted(dateFormat: DateFormat) -> String {
        dateFormat.formatter.string(from: self)
    }
}

