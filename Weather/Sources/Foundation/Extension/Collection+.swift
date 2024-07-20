//
//  Collection+.swift
//  Weather
//
//  Created by gnksbm on 7/20/24.
//

import Foundation

extension Collection {
    func getAverage<Property: BinaryInteger>(
        keyPath: KeyPath<Element, Property>
    ) -> Property {
        reduce(0) { $0 + $1[keyPath: keyPath] } / Property(count)
    }
    
    func getAverage<Property: BinaryFloatingPoint>(
        keyPath: KeyPath<Element, Property>
    ) -> Property {
        reduce(0) { $0 + $1[keyPath: keyPath] } / Property(count)
    }
}
