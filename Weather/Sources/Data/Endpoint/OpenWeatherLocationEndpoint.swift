//
//  OpenWeatherLocationEndpoint.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import Foundation

protocol OpenWeatherLocationEndpoint: OpenWeatherEndpoint {
    var request: OWLocationRequest { get }
}

extension OpenWeatherLocationEndpoint {
    var queries: [String : String]? {
        [
            "lat": "\(request.latitude)",
            "lon": "\(request.longitude)"
        ]
    }
}
