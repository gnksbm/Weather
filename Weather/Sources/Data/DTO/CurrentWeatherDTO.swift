//
//  CurrentWeatherDTO.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import Foundation

import Foundation

struct CurrentWeatherDTO: Decodable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let rain: Rain?
    let snow: Snow?
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

extension CurrentWeatherDTO {
    func toLocationItem(
    ) -> WeatherSummaryViewController.CollectionViewItem {
        .location(
            WeatherLocationInfo(
                latitude: coord.lat,
                longitude: coord.lon
            )
        )
    }
    
    func toWeatherConditionItems(
    ) -> [WeatherSummaryViewController.CollectionViewItem] {
        [
            .weatherConditions(.windSpeed(wind.speed)),
            .weatherConditions(.cloud(clouds.all)),
            .weatherConditions(.pressure(main.pressure)),
            .weatherConditions(.humidity(main.humidity)),
        ]
    }
}

extension CurrentWeatherDTO {
    struct Coord: Decodable {
        let lon: Double
        let lat: Double
    }
    
    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Decodable {
        let temp: Double
        let feelsLike: Double
        let pressure: Int
        let humidity: Int
        let tempMin: Double
        let tempMax: Double
        let seaLevel: Int?
        let grndLevel: Int?
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case pressure
            case humidity
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
        }
    }
    
    struct Wind: Decodable {
        let speed: Double
        let deg: Int
        let gust: Double?
    }
    
    struct Clouds: Decodable {
        let all: Int
    }
    
    struct Rain: Decodable {
        let oneHour: Double?
        let threeHour: Double?
        
        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
            case threeHour = "3h"
        }
    }
    
    struct Snow: Decodable {
        let oneHour: Double?
        let threeHour: Double?
        
        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
            case threeHour = "3h"
        }
    }
    
    struct Sys: Decodable {
        let type: Int?
        let id: Int?
        let message: Double?
        let country: String
        let sunrise: Int
        let sunset: Int
    }
}
