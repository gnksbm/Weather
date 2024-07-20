//
//  ThreeHourForecast.swift
//  Weather
//
//  Created by gnksbm on 7/20/24.
//

import Foundation

struct ThreeHourForecast: Hashable {
    let time: Date
    let iconRequest: OpenWeatherIconRequest
    let temperature: Double
    
    var iconEndpoint: OpenWeatherIconEndpoint {
        OpenWeatherIconEndpoint(request: iconRequest)
    }
}
