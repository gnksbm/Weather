//
//  FiveDaysForecastCVCell.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import UIKit

import Neat
import SnapKit

final class FiveDaysForecastCVCell: BaseCollectionViewCell {
    private let dayOfWeekLabel = UILabel().nt.configure {
        $0.textColor(.label)
            .font(WTDesign.Font.body1.with(weight: .light))
    }
    
    private let iconImageView = UIImageView().nt.configure {
        $0.tintColor(.label)
            .contentMode(.scaleAspectFit)
    }
    
    private let minTempLabel = UILabel().nt.configure {
        $0.textColor(.secondaryLabel)
            .font(WTDesign.Font.body2)
    }
    
    private let maxTempLabel = UILabel().nt.configure {
        $0.textColor(.label)
            .textAlignment(.right)
            .font(WTDesign.Font.body2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [dayOfWeekLabel, minTempLabel, maxTempLabel].forEach { $0.text = nil }
        iconImageView.image = nil
    }
    
    func configureCell(
        item: WeatherSummaryViewController.CollectionViewItem.FiveDayForecast
    ) {
        dayOfWeekLabel.text = item.dayOfWeek
        iconImageView.setImageWithCahe(
            with: item.iconEndpoint,
            placeHolder: UIImage(
                systemName: "sun.max.trianglebadge.exclamationmark"
            )
        )
        let format = "%.1f°"
        minTempLabel.text = "최저 \(String(format: format, item.minTemperature))"
        maxTempLabel.text = "최고 \(String(format: format, item.minTemperature))"
    }
    
    override func configureLayout() {
        [
            dayOfWeekLabel,
            iconImageView,
            minTempLabel,
            maxTempLabel
        ].forEach { contentView.addSubview($0) }
        
        let spacing = 20.f
        
        dayOfWeekLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).inset(spacing)
            make.width.equalTo(contentView).multipliedBy(0.2)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(minTempLabel.snp.leading).offset(-spacing)
            make.height.equalTo(contentView).multipliedBy(0.5)
            make.width.equalTo(iconImageView.snp.height)
        }
        
        minTempLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(iconImageView.snp.trailing).offset(-spacing)
            make.width.equalTo(contentView).multipliedBy(0.25)
        }
        
        maxTempLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(minTempLabel.snp.trailing).offset(spacing)
            make.trailing.equalTo(contentView).inset(spacing)
            make.width.equalTo(contentView).multipliedBy(0.25)
        }
    }
}
