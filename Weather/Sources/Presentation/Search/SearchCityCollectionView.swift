//
//  SearchCityCollectionView.swift
//  Weather
//
//  Created by gnksbm on 7/21/24.
//

import UIKit

final class SearchCityCollectionView: BaseCollectionView {
    var diffableDataSource: DataSource!
    
    init() {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        super.init(
            frame: .zero,
            collectionViewLayout:
                UICollectionViewCompositionalLayout.list(using: config)
        )
        configureDataSource()
    }
    
    func updateSnapshot(items: [String]) {
        var snapshot = Snapshot()
        let allSection = CollectionViewSection.allCases
        snapshot.appendSections(allSection)
        allSection.forEach { section in
            switch section {
            case .main:
                snapshot.appendItems(items, toSection: section)
            }
        }
        diffableDataSource.apply(snapshot)
    }
    
    func getItem(indexPath: IndexPath) -> String {
        diffableDataSource
            .snapshot(for: CollectionViewSection.allCases[indexPath.section])
            .items[indexPath.row]
    }
    
    private func configureDataSource() {
        let cellRegistration = makeCellRegistration()
        diffableDataSource = DataSource(
            collectionView: self
        ) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }
    }
    
    private func makeCellRegistration() -> CellRegistration {
        CellRegistration { cell, indexPath, item in
            var config = UIListContentConfiguration.cell()
            config.text = item
            cell.contentConfiguration = config
        }
    }
}

extension SearchCityCollectionView {
    enum CollectionViewSection: CaseIterable {
        case main
    }
    
    typealias DataSource =
    UICollectionViewDiffableDataSource<CollectionViewSection, String>
    
    typealias Snapshot =
    NSDiffableDataSourceSnapshot<CollectionViewSection, String>
    
    typealias CellRegistration =
    UICollectionView.CellRegistration<UICollectionViewCell, String>
}
