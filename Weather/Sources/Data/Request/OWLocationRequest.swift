//
//  OWLocationRequest.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import Foundation
import CoreLocation

struct OWLocationRequest {
    let latitude: CGFloat
    let longitude: CGFloat
    
    init(latitude: CGFloat, longitude: CGFloat) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(location: CLLocation) {
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
}
