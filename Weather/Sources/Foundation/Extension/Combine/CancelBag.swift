//
//  CancelBag.swift
//  Weather
//
//  Created by gnksbm on 7/17/24.
//

import Combine

typealias CancelBag = Set<AnyCancellable>

extension CancelBag {
    func cancel() {
        forEach {
            $0.cancel()
        }
    }
}
