//
//  EndpointError.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import Foundation

enum EndpointError: LocalizedError {
    case invalidURL
    case invalidURLRequest
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "유효하지 않은 URL"
        case .invalidURLRequest:
            "유효하지 않은 URLRequest"
        }
    }
}
