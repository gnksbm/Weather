//
//  WeatherConditionCVCell.swift
//  Weather
//
//  Created by gnksbm on 7/15/24.
//

import UIKit

import Neat
import SnapKit

final class WeatherConditionCVCell: BaseCollectionViewCell {
    private let iconImageView = UIImageView().nt.configure {
        $0.tintColor(.secondaryLabel)
            .contentMode(.scaleAspectFit)
            .preferredSymbolConfiguration(
                UIImage.SymbolConfiguration(font: (WTDesign.Font.caption))
            )
    }
    
    private let titleLabel = UILabel().nt.configure {
        $0.textColor(.secondaryLabel)
            .font(WTDesign.Font.caption)
    }
    
    private let conditionLabel = UILabel().nt.configure {
        $0.textColor(.label)
            .font(WTDesign.Font.subtitle2)
    }
    
    func configureCell(
        item: WeatherCondition
    ) {
        iconImageView.image = UIImage(systemName: item.iconName)
        titleLabel.text = item.title
        conditionLabel.text = item.condition
    }
    
    override func configureLayout() {
        [iconImageView, titleLabel, conditionLabel].forEach {
            contentView.addSubview($0)
        }
        
        let spacing = 20.f
        
        iconImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(spacing)
            make.height.equalTo(titleLabel)
            make.width.equalTo(iconImageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView)
            make.leading.equalTo(iconImageView.snp.trailing).offset(spacing)
            make.trailing.equalTo(contentView).inset(spacing)
        }
        
        conditionLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(spacing)
            make.leading.equalTo(iconImageView)
            make.trailing.equalTo(contentView).inset(spacing)
        }
    }
}
