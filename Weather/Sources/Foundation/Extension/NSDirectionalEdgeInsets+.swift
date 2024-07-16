//
//  NSDirectionalEdgeInsets+.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import UIKit

extension NSDirectionalEdgeInsets {
    static func same(equal: CGFloat) -> Self {
        NSDirectionalEdgeInsets(
            top: equal,
            leading: equal,
            bottom: equal,
            trailing: equal
        )
    }
}
