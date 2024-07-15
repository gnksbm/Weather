//
//  ViewModelStorage.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import Foundation

enum ViewModelStorage {
    typealias View = AnyObject
    typealias ViewModel = AnyObject
    
    static var storage = WeakStorage<View, ViewModel>()
}
