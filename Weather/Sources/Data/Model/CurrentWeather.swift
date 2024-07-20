//
//  CurrentWeather.swift
//  Weather
//
//  Created by gnksbm on 7/20/24.
//

import Foundation

struct CurrentWeather: Hashable {
    let area: String
    let temperature: Double
    let description: String?
    let minTemperature: Double
    let maxTemperature: Double
}
