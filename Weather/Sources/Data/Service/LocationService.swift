//
//  LocationService.swift
//  Weather
//
//  Created by gnksbm on 7/17/24.
//

import Foundation
import Combine
import CoreLocation

import Neat

enum LocationServiceError: Error {
    case notAuthorized
    case locationUpdateFailed
    case unknown
    case locationManagerError(Error)
}

final class LocationService: NSObject {
    static let shared = LocationService()
    
    private var cancelBag = CancelBag()
    
    private lazy var locationManager = CLLocationManager().nt.configure {
        $0.delegate(self)
    }
    
    private lazy var authStatus = PassthroughSubject
    <CLAuthorizationStatus, Never>()
    private let currentLocation =
    PassthroughSubject<Result<CLLocation, LocationServiceError>, Never>()
    
    private override init() { 
        super.init()
        configureLocationManager()
    }
    
    func requestLocation(
    ) -> AnyPublisher<Result<CLLocation, LocationServiceError>, Never> {
        cancelBag.cancel()
        locationManager.requestWhenInUseAuthorization()
        authStatus.withUnretained(self)
            .drop { service, status in
                status == .notDetermined
            }
            .sink { service, status in
                switch status {
                case .authorizedAlways, .authorizedWhenInUse:
                    service.locationManager.requestLocation()
                case .denied, .restricted:
                    service.currentLocation.send(
                        .failure(LocationServiceError.notAuthorized)
                    )
                default:
                    service.currentLocation.send(
                        .failure(LocationServiceError.unknown)
                    )
                }
            }
            .store(in: &cancelBag)
        return currentLocation.eraseToAnyPublisher()
    }
    
    private func configureLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authStatus.send(manager.authorizationStatus)
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            currentLocation.send(.success(location))
        } else {
            currentLocation.send(.failure(.locationUpdateFailed))
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: any Error
    ) {
        currentLocation.send(.failure(.locationManagerError(error)))
    }
}
