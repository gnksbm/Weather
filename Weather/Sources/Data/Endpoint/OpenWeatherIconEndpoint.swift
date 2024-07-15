//
//  OpenWeatherIconEndpoint.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import Foundation

import Alamofire

struct OpenWeatherIconEndpoint: EndpointRepresentable {
    let request: OpenWeatherIconRequest
    
    var httpMethod: Alamofire.HTTPMethod { .get }
    
    var scheme: String { "https" }
    
    var host: String { "openweathermap.org" }
    
    var path: String { "/img/wn/\(request.iconCode)@2x.png" }
}
