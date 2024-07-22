//
//  CityRepository.swift
//  Weather
//
//  Created by gnksbm on 7/21/24.
//

import Foundation

final class CityRepository {
    static let shared = CityRepository()
    
    private var cityList = [City]()
    
    private init() {
        do {
            cityList = try loadCityList()
        } catch {
            Logger.error(error)
        }
    }
    
    func searchCity(term: String) -> [City] {
        cityList.filter { $0.name.localizedCaseInsensitiveContains("term") }
    }
    
    func fetchCityList() -> [City] {
        cityList
    }
    
    private func loadCityList() throws -> [City] {
        let data = try ResourceStorage.loadData(
            resourceName: "CityList",
            resourceType: "json"
        )
        return try JSONDecoder().decode([City].self, from: data)
    }
}
