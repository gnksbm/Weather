//
//  CurrentWeatherEndpoint.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import Foundation

struct CurrentWeatherEndpoint: OpenWeatherLocationEndpoint {
    let request: OWLocationRequest
    var externalPath: String { "weather" }
}
