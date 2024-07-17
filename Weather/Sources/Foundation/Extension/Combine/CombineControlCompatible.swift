//
//  CombineControlCompatible.swift
//  Weather
//
//  Created by gnksbm on 7/17/24.
//

import UIKit
import Combine

protocol CombineControlCompatible { }

extension UIControl: CombineControlCompatible { }

extension CombineControlCompatible where Self: UIControl {
    func publisher(
        for event: UIControl.Event
    ) -> ControlEventPublisher<Self> {
        ControlEventPublisher(control: self, event: event)
    }
}

extension CombineControlCompatible where Self: UIButton {
    var tapEvent: AnyPublisher<Void, Never> {
        publisher(for: .touchUpInside)
            .map { _ in }
            .eraseToAnyPublisher()
            .eraseToAnyPublisher()
    }
}

extension CombineControlCompatible where Self: UITextField {
    var textChangeEvent: AnyPublisher<String, Never> {
        publisher(for: .editingChanged)
            .compactMap(\.text)
            .eraseToAnyPublisher()
            .eraseToAnyPublisher()
    }
}

extension CombineControlCompatible where Self: UIDatePicker {
    var dateChangeEvent: AnyPublisher<Date, Never> {
        publisher(for: .valueChanged)
            .map(\.date)
            .eraseToAnyPublisher()
            .eraseToAnyPublisher()
    }
}
