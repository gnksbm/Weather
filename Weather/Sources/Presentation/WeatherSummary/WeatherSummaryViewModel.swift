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
            <[WeatherSummaryViewController.CollectionViewItem], Never>(),
            locationFailure: PassthroughSubject
            <LocationServiceError, Never>(),
            networkingFailure: PassthroughSubject<Error, Never>(),
            startMapFlow: PassthroughSubject<Void, Never>(),
            startListFlow: PassthroughSubject<Void, Never>()
        )
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .flatMap { vm, _ in
                vm.locationService.requestLocation()
            }
            .withUnretained(self)
            .flatMap { vm, result in
                switch result {
                case .success(let location):
                    return Publishers.CombineLatest(
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
                case .failure(let error):
                    output.locationFailure.send(error)
                    return Future
                    <[WeatherSummaryViewController.CollectionViewItem], Error> {
                        promise in
                        promise(.success([]))
                    }
                    .eraseToAnyPublisher()
                }
            }
            .sink { completion in
                Logger.debug(
                    String(describing: Self.self) +
                    "viewWillAppearEvent 스트림 종료"
                )
            } receiveValue: { items in
                output.collectionViewItem.send(items)
            }
            .store(in: &cancelBag)

        input.mapButtonTapEvent
            .sink { _ in
                output.startMapFlow.send(())
            }
            .store(in: &cancelBag)
        
        input.listButtonTapEvent
            .sink { _ in
                output.startListFlow.send(())
            }
            .store(in: &cancelBag)
        
        return output
    }
}

extension WeatherSummaryViewModel {
    struct Input { 
        let viewWillAppearEvent: PassthroughSubject<Void, Never>
        let mapButtonTapEvent: AnyPublisher<Void, Never>
        let listButtonTapEvent: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let collectionViewItem: PassthroughSubject
        <[WeatherSummaryViewController.CollectionViewItem], Never>
        let locationFailure: PassthroughSubject<LocationServiceError, Never>
        let networkingFailure: PassthroughSubject<Error, Never>
        let startMapFlow: PassthroughSubject<Void, Never>
        let startListFlow: PassthroughSubject<Void, Never>
    }
}
