//
//  WeatherSummaryViewController+Mock.swift
//  Weather
//
//  Created by gnksbm on 7/17/24.
//

import Foundation

#if DEBUG
extension WeatherSummaryViewController.CollectionViewDataSource {
    static let mock: [Self] = [
        .init(
            section: .threeHours,
            items: [
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
            ]
        ),
        .init(
            section: .fiveDays,
            items: [
                .fiveDays(
                    .init(
                        dayOfWeek: "오늘",
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        minTemperature: .random(in: 0...1),
                        maxTemperature: .random(in: 0...1)
                    )
                ),
                .fiveDays(
                    .init(
                        dayOfWeek: "내일",
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        minTemperature: .random(in: 0...1),
                        maxTemperature: .random(in: 0...1)
                    )
                ),
                .fiveDays(
                    .init(
                        dayOfWeek: "",
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        minTemperature: .random(in: 0...1),
                        maxTemperature: .random(in: 0...1)
                    )
                ),
                .fiveDays(
                    .init(
                        dayOfWeek: "",
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        minTemperature: .random(in: 0...1),
                        maxTemperature: .random(in: 0...1)
                    )
                ),
                .fiveDays(
                    .init(
                        dayOfWeek: "",
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        minTemperature: .random(in: 0...1),
                        maxTemperature: .random(in: 0...1)
                    )
                ),
            ]
        ),
        .init(
            section: .location,
            items: [
                .location(.init(latitude: 35.702069, longitude: 139.775327))
            ]
        ),
        .init(
            section: .weatherConditions,
            items: [
                .weatherConditions(.windSpeed(0)),
                .weatherConditions(.cloud(0)),
                .weatherConditions(.pressure(0)),
                .weatherConditions(.humidity(0)),
            ]
        )
    ]
}
#endif
