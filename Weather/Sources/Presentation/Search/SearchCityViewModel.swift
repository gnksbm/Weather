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
    private var cancelBag = CancelBag()
    
    func transform(input: Input) -> Output {
        let output = Output(dataList: PassthroughSubject<[String], Never>())
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .sink { vm, _ in
                
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
        let itemSelectEvent: AnyPublisher<String, Never>
    }
    
    struct Output {
        let dataList: PassthroughSubject<[String], Never>
    }
}
