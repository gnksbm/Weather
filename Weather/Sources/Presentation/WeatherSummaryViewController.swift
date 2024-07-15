//
//  WeatherSummaryViewController.swift
//  Weather
//
//  Created by gnksbm on 7/13/24.
//

import UIKit

class WeatherSummaryViewController: BaseViewController {
    private let collectionView = UICollectionView()
}

extension WeatherSummaryViewController {
    enum CollectionViewSection {
        case threeHours, fiveDays, location, weatherConditions
    }
    
    typealias DataSource =
    UICollectionViewDiffableDataSource<CollectionViewSection, String>
    
    typealias Snapshot =
    NSDiffableDataSourceSnapshot<CollectionViewSection, String>
}
