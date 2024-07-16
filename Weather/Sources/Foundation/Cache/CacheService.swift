//
//  CacheService.swift
//  Weather
//
//  Created by gnksbm on 7/16/24.
//

import Foundation

protocol CacheService {
    associatedtype Value
    
    func object(url: URL) -> CacheableObject<Value>?
    func setObject(_ object: CacheableObject<Value>, url: URL)
}

final class DefaultCacheService<Value>: CacheService {
    private let memoryStorage = NSCache<NSURL, CacheableObject<Value>>()
    
    init(config: CacheConfiguration = .default) {
        memoryStorage.countLimit = config.countLimit
        memoryStorage.totalCostLimit = config.totalCostLimit
    }
    
    func object(url: URL) -> CacheableObject<Value>? {
        memoryStorage.object(forKey: url as NSURL)
    }
    
    func setObject(_ object: CacheableObject<Value>, url: URL) {
        memoryStorage.setObject(object, forKey: url as NSURL)
    }
}

final class DiskCacheStorage {
    
}
