//
//  WeatherCondition.swift
//  Weather
//
//  Created by gnksbm on 7/20/24.
//

import Foundation

enum WeatherCondition: Hashable {
    case windSpeed(Double), cloud(Int), pressure(Int), humidity(Int)
    
    var iconName: String {
        switch self {
        case .windSpeed:
            "wind"
        case .cloud:
            "drop.fill"
        case .pressure:
            "thermometer.medium"
        case .humidity:
            "humidity"
        }
    }
    
    var title: String {
        switch self {
        case .windSpeed:
            "바람 속도"
        case .cloud:
            "구름"
        case .pressure:
            "기압"
        case .humidity:
            "습도"
        }
    }
    
    var condition: String {
        switch self {
        case .windSpeed(let speed):
            String(format: "%.2fm/s", speed)
        case .cloud(let percent), .humidity(let percent):
            "\(percent)%"
        case .pressure(let value):
            "\(value.formatted())hpa"
        }
    }
}
