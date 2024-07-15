//
//  ForecastWeatherResponse.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import Foundation

struct ForecastResponse: Decodable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [Forecast]
    let city: City
}

extension ForecastResponse {
    struct Forecast: Decodable {
        let dt: Int
        let main: MainClass
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let visibility: Int
        let pop: Double
        let rain: Rain?
        let snow: Snow?
        let sys: Sys
        let dtTxt: String
        
        enum CodingKeys: String, CodingKey {
            case dt, main, weather, clouds, wind, visibility, pop, rain, snow, sys
            case dtTxt = "dt_txt"
        }
    }
    
    struct MainClass: Decodable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let seaLevel: Int?
        let grndLevel: Int?
        let humidity: Int
        let tempKf: Double
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
            case humidity
            case tempKf = "temp_kf"
        }
    }
    
    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Clouds: Decodable {
        let all: Int
    }
    
    struct Wind: Decodable {
        let speed: Double
        let deg: Int
        let gust: Double?
    }
    
    struct Rain: Decodable {
        let threeHour: Double?
        
        enum CodingKeys: String, CodingKey {
            case threeHour = "3h"
        }
    }
    
    struct Snow: Decodable {
        let threeHour: Double?
        
        enum CodingKeys: String, CodingKey {
            case threeHour = "3h"
        }
    }
    
    struct Sys: Decodable {
        let pod: String
    }
    
    struct City: Decodable {
        let id: Int
        let name: String
        let coord: Coord
        let country: String
        let population: Int
        let timezone: Int
        let sunrise: Int
        let sunset: Int
    }
    
    struct Coord: Decodable {
        let lat: Double
        let lon: Double
    }
}
