//
//  FiveDayForecast.swift
//  Weather
//
//  Created by gnksbm on 7/20/24.
//

import Foundation

struct FiveDayForecast: Hashable {
    let dayOfWeek: String
    let iconRequest: OpenWeatherIconRequest
    let minTemperature: Double
    let maxTemperature: Double
    
    var iconEndpoint: OpenWeatherIconEndpoint {
        OpenWeatherIconEndpoint(request: iconRequest)
    }
}
