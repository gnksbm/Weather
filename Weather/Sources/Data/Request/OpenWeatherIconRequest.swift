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
}
