//
//  WeatherSummaryViewController.swift
//  Weather
//
//  Created by gnksbm on 7/13/24.
//

import UIKit

import SnapKit

class WeatherSummaryViewController: BaseViewController {
    private var dataSource: DataSource!
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        configureDefaultSnapshot()
        updateSnapshot(dataSources: CollectionViewDataSource.mock)
    }
    
    override func configureLayout() {
        [collectionView].forEach { view.addSubview($0) }
        
        let safeArea = view.safeAreaLayoutGuide
        collectionView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(safeArea)
            make.horizontalEdges.equalTo(safeArea).inset(20)
        }
    }
}

extension WeatherSummaryViewController {
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let threeHoursSection = makeThreeHoursSection()
        let locationSection = makeLocationSection()
        let fiveDaysSection = makeFiveDaysSection()
        let weatherConditionsSection = makeWeatherConditionsSection()
        
        return UICollectionViewCompositionalLayout { section, env in
            let sectionKind = CollectionViewSection.allCases[section]
            let section = switch sectionKind {
            case .threeHours:
                threeHoursSection
            case .fiveDays:
                fiveDaysSection
            case .location:
                locationSection
            case .weatherConditions:
                weatherConditionsSection
            }
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 10,
                leading: 0,
                bottom: 0,
                trailing: 0
            )
            return section
        }
    }
    
    private func makeThreeHoursSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/5),
                heightDimension: .fractionalHeight(1)
            )
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1/2)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        return section
    }
    
    private func makeFiveDaysSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/5)
            )
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1)
            ),
            subitems: [item]
        )
        return NSCollectionLayoutSection(group: group)
    }
    
    private func makeLocationSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(4/5)
            ),
            subitems: [item]
        )
        return NSCollectionLayoutSection(group: group)
    }
    
    private func makeWeatherConditionsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .fractionalHeight(1)
            )
        )
        item.contentInsets = .same(equal: 5)
        let hGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/2)
            ),
            subitems: [item]
        )
        let vGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1)
            ),
            subitems: [hGroup]
        )
        return NSCollectionLayoutSection(group: vGroup)
    }
    
    private func configureDataSource() {
        let threeHoursRegistration = makeThreeHoursRegistration()
        let fiveDaysRegistration = makeFiveDaysRegistration()
        let locationRegistration = makeLocationRegistration()
        let weatherConditionsRegistration = makeWeatherConditionsRegistration()
        
        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            switch CollectionViewSection.allCases[indexPath.section] {
            case .threeHours:
                collectionView.dequeueConfiguredReusableCell(
                    using: threeHoursRegistration,
                    for: indexPath,
                    item: item
                )
            case .fiveDays:
                collectionView.dequeueConfiguredReusableCell(
                    using: fiveDaysRegistration,
                    for: indexPath,
                    item: item
                )
            case .location:
                collectionView.dequeueConfiguredReusableCell(
                    using: locationRegistration,
                    for: indexPath,
                    item: item
                )
            case .weatherConditions:
                collectionView.dequeueConfiguredReusableCell(
                    using: weatherConditionsRegistration,
                    for: indexPath,
                    item: item
                )
            }
        }
    }
    
    private func configureDefaultSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(CollectionViewSection.allCases)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func makeThreeHoursRegistration() -> ThreeHoursRegistration {
        ThreeHoursRegistration { cell, indexPath, cellData in
            if case .threeHours(let item) = cellData {
                cell.configureCell(item: item)
            }
        }
    }
    
    private func makeFiveDaysRegistration() -> FiveDaysRegistration {
        FiveDaysRegistration { cell, indexPath, itemIdentifier in
            
        }
    }
    
    private func makeLocationRegistration() -> LocationRegistration {
        LocationRegistration { cell, indexPath, itemIdentifier in
            
        }
    }
    
    private func makeWeatherConditionsRegistration(
    ) -> WeatherConditionsRegistration {
        WeatherConditionsRegistration { cell, indexPath, itemIdentifier in
            
        }
    }
    
    private func updateSnapshot(dataSources: [CollectionViewDataSource]) {
        var snapshot = Snapshot()
        dataSources.forEach { dataSource in
            snapshot.appendSections([dataSource.section])
            snapshot.appendItems(
                dataSource.items,
                toSection: dataSource.section
            )
        }
        dataSource.apply(snapshot)
    }
    
    struct CollectionViewDataSource {
        let section: CollectionViewSection
        let items: [CollectionViewItem]
    }
    
    enum CollectionViewSection: CaseIterable {
        case threeHours, fiveDays, location, weatherConditions
    }
    
    enum CollectionViewItem: Hashable {
        case threeHours(ThreeHourForecast)
        case fiveDays(FiveDayForecast)
        case location(WeatherLocationInfo)
        case weatherConditions(WeatherCondition)
        
        struct ThreeHourForecast: Hashable {
            let time: Date
            let iconRequest: OpenWeatherIconRequest
            let temperature: Double
            
            var iconEndpoint: OpenWeatherIconEndpoint {
                OpenWeatherIconEndpoint(request: iconRequest)
            }
        }

        struct FiveDayForecast: Hashable {
            let dayOfWeek: String
            let iconRequest: OpenWeatherIconRequest
            let minTemperature: Double
            let maxTemperature: Double
        }

        struct WeatherLocationInfo: Hashable {
            let latitude: CGFloat
            let longitude: CGFloat
        }

        enum WeatherCondition: Hashable {
            case windSpeed(Double), cloud(Int), pressure(Int), humidity(Int)
        }
    }
    
    typealias DataSource =
    UICollectionViewDiffableDataSource
    <CollectionViewSection, CollectionViewItem>
    
    typealias Snapshot =
    NSDiffableDataSourceSnapshot<CollectionViewSection, CollectionViewItem>
    
    typealias ThreeHoursRegistration =
    UICollectionView.CellRegistration
    <ThreeHoursForecastCVCell, CollectionViewItem>
    typealias FiveDaysRegistration =
    UICollectionView.CellRegistration
    <FiveDaysForecastCVCell, CollectionViewItem>
    typealias LocationRegistration =
    UICollectionView.CellRegistration<WeatherLocationCVCell, CollectionViewItem>
    typealias WeatherConditionsRegistration =
    UICollectionView.CellRegistration
    <WeatherConditionCVCell, CollectionViewItem>
}

#if DEBUG
extension WeatherSummaryViewController.CollectionViewDataSource {
    static let mock: [Self] = [
        .init(
            section: .threeHours,
            items: [
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
                .threeHours(
                    .init(
                        time: .now,
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        temperature: .random(in: 0...1)
                    )
                ),
            ]
        ),
        .init(
            section: .fiveDays,
            items: [
                .fiveDays(
                    .init(
                        dayOfWeek: "",
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        minTemperature: .random(in: 0...1),
                        maxTemperature: .random(in: 0...1)
                    )
                ),
                .fiveDays(
                    .init(
                        dayOfWeek: "",
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        minTemperature: .random(in: 0...1),
                        maxTemperature: .random(in: 0...1)
                    )
                ),
                .fiveDays(
                    .init(
                        dayOfWeek: "",
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        minTemperature: .random(in: 0...1),
                        maxTemperature: .random(in: 0...1)
                    )
                ),
                .fiveDays(
                    .init(
                        dayOfWeek: "",
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        minTemperature: .random(in: 0...1),
                        maxTemperature: .random(in: 0...1)
                    )
                ),
                .fiveDays(
                    .init(
                        dayOfWeek: "",
                        iconRequest: OpenWeatherIconRequest(iconCode: ""),
                        minTemperature: .random(in: 0...1),
                        maxTemperature: .random(in: 0...1)
                    )
                ),
            ]
        ),
        .init(
            section: .location,
            items: [
                .location(.init(latitude: 0, longitude: 0))
            ]
        ),
        .init(
            section: .weatherConditions,
            items: [
                .weatherConditions(.windSpeed(0)),
                .weatherConditions(.cloud(0)),
                .weatherConditions(.pressure(0)),
                .weatherConditions(.humidity(0)),
            ]
        )
    ]
}
#endif
