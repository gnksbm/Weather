//
//  ToastView.swift
//  Weather
//
//  Created by gnksbm on 7/17/24.
//

import UIKit

import SnapKit
import Neat

final class ToastView: BaseView {
    private let messageLabel = UILabel().nt.configure {
        $0.font(.boldSystemFont(ofSize: 15))
            .backgroundColor(.systemBackground)
            .clipsToBounds(true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    func updateMessage(_ message: String) {
        messageLabel.text = message
    }
    
    override func configureUI() {
        backgroundColor = .systemBackground
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
        alpha = 0
    }
    
    override func configureLayout() {
        [messageLabel].forEach { addSubview($0) }
        
        messageLabel.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(15)
        }
    }
}

