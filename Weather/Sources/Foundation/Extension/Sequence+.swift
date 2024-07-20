//
//  Sequence+.swift
//  Weather
//
//  Created by gnksbm on 7/20/24.
//

import Foundation

extension Sequence {
    func mostPopularValue<Property: Hashable>(
        keyPath: KeyPath<Element, Property>
    ) -> Property? {
        var dic = [Property: Int]()
        forEach { dic[$0[keyPath: keyPath], default: 0] += 1 }
        return dic.sorted { $0.value > $1.value }.first?.key
    }
}
