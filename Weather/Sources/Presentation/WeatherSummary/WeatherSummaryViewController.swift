//
//  WeatherSummaryViewController.swift
//  Weather
//
//  Created by gnksbm on 7/13/24.
//

import UIKit
import Combine

import SnapKit

class WeatherSummaryViewController: BaseViewController, View {
    private var dataSource: DataSource!
    
    private let viewWillAppearEvent = PassthroughSubject<Void, Never>()
    private var cancelBag = CancelBag()
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        configureDefaultSnapshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearEvent.send(())
    }
    
    func bind(viewModel: WeatherSummaryViewModel) {
        let output = viewModel.transform(
            input: WeatherSummaryViewModel.Input(
                viewWillAppearEvent: viewWillAppearEvent
            )
        )
        
        output.collectionViewItem
            .withUnretained(self)
            .sink { error in
                error
            } receiveValue: { vc, items in
                vc.updateSnapshot(items: items)
            }
            .store(in: &cancelBag)
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
                heightDimension: .fractionalWidth(5/7)
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
        FiveDaysRegistration { cell, indexPath, cellData in
            if case .fiveDays(let item) = cellData {
                cell.configureCell(item: item)
            }
        }
    }
    
    private func makeLocationRegistration() -> LocationRegistration {
        LocationRegistration { cell, indexPath, cellData in
            if case .location(let item) = cellData {
                cell.configureCell(item: item)
            }
        }
    }
    
    private func makeWeatherConditionsRegistration(
    ) -> WeatherConditionsRegistration {
        WeatherConditionsRegistration { cell, indexPath, cellData in
            if case .weatherConditions(let item) = cellData {
                cell.configureCell(item: item)
            }
        }
    }
    
    private func updateSnapshot(items: [CollectionViewItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections(CollectionViewSection.allCases)
        items.forEach { item in
            switch item {
            case .threeHours:
                snapshot.appendItems(
                    [item],
                    toSection: .threeHours
                )
            case .fiveDays:
                snapshot.appendItems(
                    [item],
                    toSection: .fiveDays
                )
            case .location:
                snapshot.appendItems(
                    [item],
                    toSection: .location
                )
            case .weatherConditions:
                snapshot.appendItems(
                    [item],
                    toSection: .weatherConditions
                )
            }
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
            
            var iconEndpoint: OpenWeatherIconEndpoint {
                OpenWeatherIconEndpoint(request: iconRequest)
            }
        }

        struct WeatherLocationInfo: Hashable {
            let latitude: CGFloat
            let longitude: CGFloat
        }

        enum WeatherCondition: Hashable {
            case windSpeed(Double), cloud(Int), pressure(Int), humidity(Int)
            
            var iconName: String {
                switch self {
                case .windSpeed:
                    "wind"
                case .cloud:
                    "drop.fill"
                case .pressure:
                    "thermometer.medium"
                case .humidity:
                    "humidity"
                }
            }
            
            var title: String {
                switch self {
                case .windSpeed:
                    "바람 속도"
                case .cloud:
                    "구름"
                case .pressure:
                    "기압"
                case .humidity:
                    "습도"
                }
            }
            
            var condition: String {
                switch self {
                case .windSpeed(let speed):
                    String(format: "%.2fm/s", speed)
                case .cloud(let percent), .humidity(let percent):
                    "\(percent)%"
                case .pressure(let value):
                    "\(value.formatted())hpa"
                }
            }
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
