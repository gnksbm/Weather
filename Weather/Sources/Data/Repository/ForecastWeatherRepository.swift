//
//  ForecastWeatherRepository.swift
//  Weather
//
//  Created by gnksbm on 7/17/24.
//

import Foundation
import Combine

import Alamofire

final class ForecastWeatherRepository {
    static let shared = ForecastWeatherRepository()
    
    private init() { }
    
    func fetchForecastWeather(
        request: OWLocationRequest
    ) -> Future
    <[WeatherSummaryViewController.CollectionViewItem], Error> {
        Future { promise in
            AF.request(ForecastWeatherEndpoint(request: request))
                .responseDecodable(of: ForecastWeatherDTO.self) { response in
                    let result = response.result
                        .map { dto in
                            dto.toThreeHourItems() + dto.toFiveDaysItems()
                        }
                        .mapError({ $0 as Error })
                    switch result {
                    case .success(let success):
                        promise(.success(success))
                    case .failure(let failure):
                        promise(.failure(failure))
                    }
                }
        }
    }
}
