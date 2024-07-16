//
//  ThreeHoursForecastCVCell.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import UIKit

import Neat
import SnapKit

final class ThreeHoursForecastCVCell: BaseCollectionViewCell {
    private let timeLabel = UILabel().nt.configure {
        $0.textColor(.label)
            .textAlignment(.center)
            .font(WTDesign.Font.regular)
    }
    
    private let iconImageView = UIImageView().nt.configure {
        $0.contentMode(.scaleAspectFit)
    }
    
    private let tempLabel = UILabel().nt.configure {
        $0.textColor(.label)
            .textAlignment(.center)
            .font(WTDesign.Font.medium.with(weight: .medium))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [timeLabel, tempLabel].forEach { $0.text = nil }
        iconImageView.image = nil
    }
    
    func configureCell(
        item: WeatherSummaryViewController.CollectionViewItem.ThreeHourForecast
    ) {
        timeLabel.text = item.time.formatted(dateFormat: .onlyTime) + "시"
        iconImageView.setImageWithCahe(with: item.iconEndpoint)
        tempLabel.text = "\(item.temperature.removeDecimal())◦"
    }
    
    override func configureLayout() {
        [timeLabel, iconImageView, tempLabel].forEach {
            contentView.addSubview($0)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(20)
            make.centerX.equalTo(contentView)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(40)
            make.center.equalTo(contentView)
            make.bottom.equalTo(tempLabel.snp.top).offset(-40)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(20)
        }
    }
}
