//
//  WeatherSummaryViewController+PlaceHolder.swift
//  Weather
//
//  Created by gnksbm on 7/17/24.
//

import Foundation

extension WeatherSummaryViewController.CollectionViewItem {
    private static let currentWeatherPlaceholder = [
        WeatherSummaryViewController.CollectionViewItem.currentWeather(
            CurrentWeather(
                area: "위치 정보 가져오는 중....",
                temperature: 0,
                description: nil,
                minTemperature: 0,
                maxTemperature: 0
            )
        )
    ]
    private static let threeHourPlaceholder = (0...4).map { index in
        WeatherSummaryViewController.CollectionViewItem.threeHours(
            ThreeHourForecast(
                time: .now.addingTimeInterval(3600.f * 3 * index.f),
                iconRequest: .default,
                temperature: 0
            )
        )
    }
    private static let fiveDayPlaceholder = (1...5).map { index in
        WeatherSummaryViewController.CollectionViewItem.fiveDays(
            FiveDayForecast(
                dayOfWeek: Weekday(rawValue: index).toString,
                iconRequest: .default,
                minTemperature: 0,
                maxTemperature: 0
            )
        )
    }
    private static let locationPlaceholder = [
        WeatherSummaryViewController.CollectionViewItem.location(
            WeatherLocationInfo(latitude: 35.702069, longitude: 139.775327)
        )
    ]
    private static let weatherConditionPlaceholder = [
        WeatherSummaryViewController.CollectionViewItem.weatherConditions(
            .windSpeed(0)
        ),
        WeatherSummaryViewController.CollectionViewItem.weatherConditions(
            .cloud(0)
        ),
        WeatherSummaryViewController.CollectionViewItem.weatherConditions(
            .pressure(0)
        ),
        WeatherSummaryViewController.CollectionViewItem.weatherConditions(
            .humidity(0)
        ),
    ]
    static let placeholder = [
        currentWeatherPlaceholder,
        threeHourPlaceholder,
        fiveDayPlaceholder,
        locationPlaceholder,
        weatherConditionPlaceholder
    ].flatMap { $0 }
}
