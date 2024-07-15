//
//  WeakStorage.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import Foundation

final class WeakStorage<Key: AnyObject, Value: AnyObject> {
    private var storage = [Weak<Key>: Value]()
    
    func value(key: Key) -> Value? {
        storage[Weak(key)]
    }
    
    func setValue(key: Key, value: Value?) {
        if let value {
            let weakKey = Weak(key)
            storage[weakKey] = value
            let deinitHandeler = DeinitHandler { [weak self] in
                self?.storage.removeValue(forKey: weakKey)
            }
            objc_setAssociatedObject(
                key,
                UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque()),
                deinitHandeler,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        } else {
            storage.removeValue(forKey: Weak(key))
        }
    }
}
