//
//  Weekday.swift
//  Weather
//
//  Created by gnksbm on 7/20/24.
//

import Foundation

enum Weekday: Int {
    case monday = 1,
         tuesday,
         wednesday,
         thursday,
         friday,
         saturday,
         sunday,
         none
    
    init(rawValue: Int) {
        switch rawValue {
        case 1:
            self = .monday
        case 2:
            self = .tuesday
        case 3:
            self = .wednesday
        case 4:
            self = .thursday
        case 5:
            self = .friday
        case 6:
            self = .saturday
        case 7:
            self = .sunday
        default:
            self = .none
        }
    }
}

extension Weekday {
    var toString: String {
        if Calendar.current.component(.weekday, from: .now) == rawValue {
            "오늘"
        } else {
            switch self {
            case .monday:
                "월"
            case .tuesday:
                "화"
            case .wednesday:
                "수"
            case .thursday:
                "목"
            case .friday:
                "금"
            case .saturday:
                "토"
            case .sunday:
                "일"
            case .none:
                "알 수 없는 요일"
            }
        }
    }
}

extension Weekday: Comparable {
    struct CurrentWeekdayComparator: SortComparator {
        var order: SortOrder
        
        init(order: SortOrder = .forward) {
            self.order = order
        }
        
        func compare(
            _ lhs: Weekday,
            _ rhs: Weekday
        ) -> ComparisonResult {
            let today = Calendar.current.component(.weekday, from: .now)
            let lhsDistance = (lhs.rawValue - today + 7) % 7
            let rhsDistance = (rhs.rawValue - today + 7) % 7
            
            return switch order {
            case .forward:
                if lhsDistance < rhsDistance {
                    .orderedAscending
                } else {
                    if lhsDistance > rhsDistance {
                        .orderedDescending
                    } else {
                        .orderedSame
                    }
                }
            case .reverse:
                if lhsDistance > rhsDistance {
                    .orderedAscending
                } else {
                    if lhsDistance < rhsDistance {
                        .orderedDescending
                    } else {
                        .orderedSame
                    }
                }
            }
        }
    }
    
    static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
