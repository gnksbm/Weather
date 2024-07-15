//
//  ViewModel.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import Foundation

protocol ViewModel: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
