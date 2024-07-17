//
//  Publisher+.swift
//  Weather
//
//  Created by gnksbm on 7/17/24.
//

import Combine

extension Publisher {
    func withUnretained<Object: AnyObject>(
        _ object: Object
    ) -> Publishers.CompactMap<Self, (Object, Output)> {
        compactMap { [weak object] output in
            guard let object else { return nil }
            return (object, output)
        }
    }
}
