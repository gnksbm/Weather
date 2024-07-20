//
//  Date+.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import Foundation

extension Date {
    var isToday: Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "KST") ?? .current
        return calendar.isDateInToday(self)
    }
    
    var weekday: Weekday {
        Weekday(rawValue: Calendar.current.component(.weekday, from: self))
    }
}
