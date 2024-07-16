//
//  CacheConfiguration.swift
//  Weather
//
//  Created by gnksbm on 7/16/24.
//

import Foundation

struct CacheConfiguration {
    static let `default` = CacheConfiguration(
        totalCostLimit: DataSize(amount: 0),
        countLimit: 0
    )
    
    let totalCostLimit: Int
    let countLimit: Int
    
    init(totalCostLimit: DataSize, countLimit: Int) {
        self.totalCostLimit = totalCostLimit.toBytes
        self.countLimit = countLimit
    }
}
