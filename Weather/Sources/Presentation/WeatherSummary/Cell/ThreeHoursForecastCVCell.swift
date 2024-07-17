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
    private var imageFetchTask: URLSessionTask?
    
    private let timeLabel = UILabel().nt.configure {
        $0.textColor(.label)
            .textAlignment(.center)
            .font(WTDesign.Font.label2)
    }
    
    private let iconImageView = UIImageView().nt.configure {
        $0.tintColor(.label)
            .contentMode(.scaleAspectFit)
    }
    
    private let tempLabel = UILabel().nt.configure {
        $0.textColor(.label)
            .textAlignment(.center)
            .font(WTDesign.Font.label1.with(weight: .medium))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [timeLabel, tempLabel].forEach { $0.text = nil }
        iconImageView.image = nil
        imageFetchTask?.cancel()
        imageFetchTask = nil
    }
    
    func configureCell(
        item: WeatherSummaryViewController.CollectionViewItem.ThreeHourForecast
    ) {
        timeLabel.text = item.time.formatted(dateFormat: .onlyTime) + "시"
        imageFetchTask = iconImageView.setImageWithCahe(
            with: item.iconEndpoint,
            placeHolder: UIImage(
                systemName: "sun.max.trianglebadge.exclamationmark"
            )
        )
        tempLabel.text = "\(item.temperature.removeDecimal())°"
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
            make.center.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.5)
            make.height.equalTo(iconImageView.snp.width)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(20)
        }
    }
}
