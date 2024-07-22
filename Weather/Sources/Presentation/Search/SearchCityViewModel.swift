//
//  SearchCityViewModel.swift
//  Weather
//
//  Created by gnksbm on 7/21/24.
//

import Combine
import Foundation

import Alamofire

final class SearchCityViewModel: ViewModel {
    private let cityRepository = CityRepository.shared
    
    private var cancelBag = CancelBag()
    
    func transform(input: Input) -> Output {
        let output = Output(cityList: PassthroughSubject<[City], Never>())
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .sink { vm, _ in
                output.cityList.send(vm.cityRepository.fetchCityList())
            }
            .store(in: &cancelBag)
        
        input.itemSelectEvent
            .withUnretained(self)
            .sink { vm, item in
            }
            .store(in: &cancelBag)
        
        return output
    }
}

extension SearchCityViewModel {
    struct Input { 
        let viewDidLoadEvent: AnyPublisher<Void, Never>
        let searchTextChangeEvent: AnyPublisher<String, Never>
        let itemSelectEvent: AnyPublisher<City, Never>
    }
    
    struct Output {
        let cityList: PassthroughSubject<[City], Never>
    }
}
