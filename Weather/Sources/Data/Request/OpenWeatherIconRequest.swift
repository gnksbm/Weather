//
//  OpenWeatherIconRequest.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import Foundation

struct OpenWeatherIconRequest: Hashable {
    let id = UUID()
    let iconCode: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension OpenWeatherIconRequest {
    static let `default` = OpenWeatherIconRequest(iconCode: "01d")
}
