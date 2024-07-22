//
//  ResourceStorage.swift
//  Weather
//
//  Created by gnksbm on 7/21/24.
//

import Foundation

enum ResourceStorage {
    static func loadData(
        resourceName: String?,
        resourceType: String?
    ) throws -> Data {
        guard let url = Bundle.main.url(
            forResource: resourceName,
            withExtension: resourceType
        ) else { throw ResourceError.fileNotFound }
        do {
            return try Data(contentsOf: url)
        } catch {
            throw error
        }
    }
    
    enum ResourceError: Error {
        case fileNotFound
    }
}
