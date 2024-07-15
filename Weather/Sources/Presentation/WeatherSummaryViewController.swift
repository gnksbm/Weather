//
//  WeatherSummaryViewController.swift
//  Weather
//
//  Created by gnksbm on 7/13/24.
//

import UIKit
import CoreLocation

class WeatherSummaryViewController: BaseViewController {
    private let collectionView = UICollectionView()
}

extension WeatherSummaryViewController {
    enum CollectionViewSection {
        case threeHours, fiveDays, location, weatherConditions
    }
    
    enum CollectionViewItem: Hashable {
        case threeHours(ThreeHourForecast)
        case fiveDays(FiveDayForecast)
        case location(WeatherLocationInfo)
        case weatherConditions(WeatherCondition)
        
        struct ThreeHourForecast: Hashable {
            let time: Date
            let icon: OpenWeatherIconRequest
            let temperature: Double
        }

        struct FiveDayForecast: Hashable {
            let dayOfWeek: String
            let icon: OpenWeatherIconRequest
            let minTemperature: Double
            let maxTemperature: Double
        }

        struct WeatherLocationInfo: Hashable {
            let latitude: CGFloat
            let longitude: CGFloat
        }

        enum WeatherCondition: Hashable {
            case windSpeed(Double), cloud(Int), pressure(Int), humidity(Int)
        }
    }
    
    typealias DataSource =
    UICollectionViewDiffableDataSource
    <CollectionViewSection, CollectionViewItem>
    
    typealias Snapshot =
    NSDiffableDataSourceSnapshot<CollectionViewSection, CollectionViewItem>
}
