//
//  CurrentWeatherRepository.swift
//  Weather
//
//  Created by gnksbm on 7/17/24.
//

import Foundation

import Alamofire

final class CurrentWeatherRepository {
    static let shared = CurrentWeatherRepository()
    
    private init() { }
    
    func fetchCurrentWeather(
        request: OWLocationRequest,
        _ completion: @escaping
    (Result<[WeatherSummaryViewController.CollectionViewItem], Error>) -> Void
    ) {
        AF.request(CurrentWeatherEndpoint(request: request))
            .responseDecodable(of: CurrentWeatherDTO.self) { response in
                completion(
                    response.result
                        .map { dto in
                            dto.toWeatherConditionItems() + 
                            [dto.toLocationItem()]
                        }
                        .mapError({ $0 as Error })
                )
            }
    }
}
