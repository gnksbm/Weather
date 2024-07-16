//
//  FloatLiteralType+.swift
//  Weather
//
//  Created by gnksbm on 7/16/24.
//

import Foundation

extension FloatLiteralType {
    func removeDecimal(decimalCount: Int = 1) -> CVarArg {
        if self == Self(Int(self)) {
            return Int(self)
        } else {
            return String(format: "%.\(decimalCount)f", self)
        }
    }
}
