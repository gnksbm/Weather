//
//  ForecastWeatherDTO.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import Foundation

struct ForecastWeatherDTO: Decodable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [Forecast]
    let city: City
}

extension ForecastWeatherDTO {
    func toThreeHourItems(
    ) -> [WeatherSummaryViewController.CollectionViewItem] {
        list.map { forecast in
            return .threeHours(
                WeatherSummaryViewController.CollectionViewItem
                    .ThreeHourForecast(
                    time: forecast.date,
                    iconRequest: forecast.iconRequest,
                    temperature: forecast.main.temp.kelvinToCelsius()
                )
            )
        }
    }
    
    func toFiveDaysItems(
    ) -> [WeatherSummaryViewController.CollectionViewItem] {
        var dic = [Weekday: [Forecast]]()
        list.forEach { forecast in
            dic[
                forecast.date.weekday,
                default: []
            ].append(forecast)
        }
        return dic
            .sorted { lhs, rhs in
                Weekday.CurrentWeekdayComparator()
                    .compare(lhs.key, rhs.key) == .orderedAscending
            }
            .map { weekday, forecast in
                let iconRequest = forecast.mostPopularValue(
                    keyPath: \.iconRequest
                )
                let minTemp = forecast.getAverage(keyPath: \.main.tempMin)
                let maxTemp = forecast.getAverage(keyPath: \.main.tempMax)
                return .fiveDays(
                    .init(
                        dayOfWeek: weekday.toString,
                        iconRequest: iconRequest ?? .empty,
                        minTemperature: minTemp.kelvinToCelsius(),
                        maxTemperature: maxTemp.kelvinToCelsius()
                    )
                )
            }
    }
}

extension ForecastWeatherDTO {
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
        
        var iconRequest: OpenWeatherIconRequest {
            var dic = [String: Int]()
            weather.forEach { dic[$0.icon, default: 0] += 1 }
            let iconCode =
            dic.sorted { $0.value > $1.value }.first?.key ?? "01n"
            return OpenWeatherIconRequest(
                iconCode: iconCode
            )
        }
        
        var date: Date {
            Date(timeIntervalSince1970: TimeInterval(dt))
        }
        
        enum CodingKeys: String, CodingKey {
            case dt, main, weather, clouds, wind, visibility, pop 
            case rain, snow, sys
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
