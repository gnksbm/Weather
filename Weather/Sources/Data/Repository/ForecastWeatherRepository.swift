//
//  ForecastWeatherRepository.swift
//  Weather
//
//  Created by gnksbm on 7/17/24.
//

import Foundation

import Alamofire

final class ForecastWeatherRepository {
    static let shared = ForecastWeatherRepository()
    
    private init() { }
    
    func fetchForecastWeather(
        request: OWLocationRequest,
        _ completion: @escaping
    (Result<[WeatherSummaryViewController.CollectionViewItem], Error>) -> Void
    ) {
        AF.request(ForecastWeatherEndpoint(request: request))
            .responseDecodable(of: ForecastWeatherDTO.self) { response in
                completion(
                    response.result
                        .map { dto in
                            dto.toThreeHourItems() +
                            dto.toFiveDaysItems()
                        }
                        .mapError({ $0 as Error })
                )
            }
    }
}
