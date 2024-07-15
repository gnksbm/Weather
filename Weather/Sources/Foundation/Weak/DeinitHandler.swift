//
//  DeinitHandler.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import Foundation

final class DeinitHandler {
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    deinit {
        action()
    }
}
