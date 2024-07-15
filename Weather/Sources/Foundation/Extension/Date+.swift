//
//  Date+.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import Foundation

extension Date {
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
}
