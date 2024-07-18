//
//  UIKit+Combine.swift
//  Weather
//
//  Created by gnksbm on 7/18/24.
//

import Combine
import UIKit

extension UITableView {
    var didSelectRowEvent: AnyPublisher<IndexPath, Never> {
        UITableViewDelegateProxy(self).eraseToAnyPublisher()
    }
}

extension UICollectionView {
    var didSelectItemEvent: AnyPublisher<IndexPath, Never> {
        UICollectionViewDelegateProxy(self).eraseToAnyPublisher()
    }
}

extension UIButton {
    var tapEvent: AnyPublisher<Void, Never> {
        ControlEventPublisher(control: self, event: .touchUpInside)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}

extension UITextField {
    var textChangeEvent: AnyPublisher<String, Never> {
        ControlEventPublisher(control: self, event: .editingChanged)
            .compactMap(\.text)
            .eraseToAnyPublisher()
    }
}

extension UIDatePicker {
    var dateChangeEvent: AnyPublisher<Date, Never> {
        ControlEventPublisher(control: self, event: .valueChanged)
            .map(\.date)
            .eraseToAnyPublisher()
    }
}
