//
//  CurrentWeatherRepository.swift
//  Weather
//
//  Created by gnksbm on 7/17/24.
//

import Foundation
import Combine

import Alamofire

final class CurrentWeatherRepository {
    static let shared = CurrentWeatherRepository()
    
    private init() { }
    
    func fetchCurrentWeatherItems(
        request: OWLocationRequest
    ) -> Future
    <[WeatherSummaryViewController.CollectionViewItem], Error> {
        Future { promise in
            AF.request(CurrentWeatherEndpoint(request: request))
                .responseDecodable(of: CurrentWeatherDTO.self) { response in
                    let result = response.result
                        .map { dto in
                            dto.toWeatherConditionItems() +
                            [dto.toLocationItem()]
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
