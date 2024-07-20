//
//  CurrentWeatherCVCell.swift
//  Weather
//
//  Created by gnksbm on 7/20/24.
//

import UIKit

import Neat
import SnapKit

final class CurrentWeatherCVCell: BaseCollectionViewCell {
    private var imageFetchTask: URLSessionTask?
    
    private let areaLabel = UILabel().nt.configure {
        $0.textColor(.label)
            .textAlignment(.center)
            .font(WTDesign.Font.subtitle1.with(weight: .light))
    }
    
    private let tempLabel = UILabel().nt.configure {
        $0.textColor(.label)
            .textAlignment(.center)
            .font(WTDesign.Font.heading1.with(weight: .thin))
    }
    
    private let descriptionLabel = UILabel().nt.configure {
        $0.textColor(.label)
            .textAlignment(.center)
            .font(WTDesign.Font.body1)
    }
    
    private let minMaxTempLabel = UILabel().nt.configure {
        $0.textColor(.label)
            .textAlignment(.center)
            .font(WTDesign.Font.label1)
    }
    
    private lazy var stackView = UIStackView(
        arrangedSubviews: [
            areaLabel, tempLabel, descriptionLabel, minMaxTempLabel
        ]
    ).nt.configure {
        $0.axis(.vertical)
            .distribution(.equalSpacing)
            .spacing(0)
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        [areaLabel, tempLabel, descriptionLabel, minMaxTempLabel].forEach {
            $0.text = nil
        }
    }
    
    func configureCell(
        item: CurrentWeather
    ) {
        areaLabel.text = item.area
        tempLabel.text = item.temperature.toTemperature()
        descriptionLabel.text = item.description
        let tempStr = [
            "최고: " + item.maxTemperature.toTemperature(),
            "최저: " + item.minTemperature.toTemperature()
        ]
        minMaxTempLabel.text = tempStr.joined(separator: " | ")
    }
    
    override func configureLayout() {
        [stackView].forEach { contentView.addSubview($0) }
        
        stackView.snp.makeConstraints { make in
            make.center.equalTo(contentView)
        }
    }
}
