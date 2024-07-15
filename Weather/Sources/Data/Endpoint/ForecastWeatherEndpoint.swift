//
//  ForecastWeatherEndpoint.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import Foundation

struct ForecastWeatherEndpoint: OpenWeatherLocationEndpoint {
    let request: OWLocationRequest
    var externalPath: String { "forecast" }
}
