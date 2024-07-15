//
//  OpenWeatherEndpoint.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import Foundation

import Alamofire

protocol OpenWeatherEndpoint: EndpointRepresentable {
    var externalPath: String { get }
}

extension OpenWeatherEndpoint {
    var httpMethod: HTTPMethod { .get }
    var scheme: String { "https" }
    var host: String { "api.openweathermap.org" }
    var path: String { "/data/\(version)/\(externalPath)" }
    var version: CGFloat { 2.5 }
    
    func toURL() -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.port = port
        components.queryItems = queries?.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        components.queryItems?.append(
            URLQueryItem(name: "appid", value: .openWeatherApiKey)
        )
        return components.url
    }
}
