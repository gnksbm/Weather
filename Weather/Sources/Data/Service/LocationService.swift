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
}

final class LocationService: NSObject {
    static let shared = LocationService()
    
    private var cancelBag = CancelBag()
    
    private lazy var locationManager = CLLocationManager().nt.configure {
        $0.delegate(self)
    }
    
    private lazy var authStatus = PassthroughSubject
    <CLAuthorizationStatus, Never>()
    private let currentLocation = PassthroughSubject<CLLocation, Error>()
    
    private override init() { }
    
    func requestLocation() -> AnyPublisher<CLLocation, Error> {
        locationManager.requestWhenInUseAuthorization()
        authStatus.withUnretained(self)
            .dropFirst()
            .prefix(1)
            .sink { service, status in
                if status != .authorizedAlways, status != .authorizedWhenInUse {
                    service.currentLocation.send(
                        completion: .failure(
                            LocationServiceError.notAuthorized
                        )
                    )
                } else {
                    service.locationManager.requestLocation()
                }
            }
            .store(in: &cancelBag)
        return currentLocation.eraseToAnyPublisher()
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
            currentLocation.send(location)
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: any Error
    ) {
        currentLocation.send(completion: .failure(error))
    }
}
