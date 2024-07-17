//
//  WeatherSummaryViewModel.swift
//  Weather
//
//  Created by gnksbm on 7/17/24.
//

import Foundation
import Combine

final class WeatherSummaryViewModel: ViewModel {
    private let currentWeatherRepository = CurrentWeatherRepository.shared
    private let forecastWeatherRepository = ForecastWeatherRepository.shared
    private let locationService = LocationService.shared
    
    private var cancelBag = CancelBag()
    
    func transform(input: Input) -> Output {
        let output = Output(
            collectionViewItem: PassthroughSubject
            <[WeatherSummaryViewController.CollectionViewItem], Error>()
        )
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .flatMap { vm, _ in
                vm.locationService.requestLocation()
            }
            .prefix(1)
            .withUnretained(self)
            .flatMap { vm, location in
                Publishers.CombineLatest(
                    vm.currentWeatherRepository.fetchCurrentWeatherItems(
                        request: OWLocationRequest(location: location)
                    ),
                    vm.forecastWeatherRepository.fetchForecastWeatherItems(
                        request: OWLocationRequest(location: location)
                    )
                )
                .map { currentResult, forecastResult in
                    currentResult + forecastResult
                }
                .eraseToAnyPublisher()
            }
            .sink { failure in
                output.collectionViewItem.send(completion: failure)
            } receiveValue: { items in
                output.collectionViewItem.send(items)
            }
            .store(in: &cancelBag)


        return output
    }
}

extension WeatherSummaryViewModel {
    struct Input { 
        let viewWillAppearEvent: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let collectionViewItem: PassthroughSubject
        <[WeatherSummaryViewController.CollectionViewItem], Error>
    }
}
