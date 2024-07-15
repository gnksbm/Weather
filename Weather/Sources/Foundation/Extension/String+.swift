//
//  String+.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import Foundation

extension String {
    static let bundleIdentifier = Bundle.main.bundleIdentifier ?? "Weather"
    static var openWeatherApiKey: String {
        guard let apiKey = Bundle.main.object(
            forInfoDictionaryKey: "OPEN_WEATHER_API_KEY"
        ) as? String else { fatalError("Open Weather 찾을 수 없음") }
        return apiKey
    }
}
