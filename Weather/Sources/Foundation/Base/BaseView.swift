//
//  BaseView.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import UIKit

class BaseView: UIView {
    init() {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() { }
    func configureLayout() { }
}
