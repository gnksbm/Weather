//
//  City.swift
//  Weather
//
//  Created by gnksbm on 7/21/24.
//

import Foundation

struct City: Decodable, Hashable {
    let id: Int
    let name: String
    let state: String
    let country: String
    let coord: Coordinate
    
    struct Coordinate: Decodable, Hashable {
        let lon: Double
        let lat: Double
    }
}
