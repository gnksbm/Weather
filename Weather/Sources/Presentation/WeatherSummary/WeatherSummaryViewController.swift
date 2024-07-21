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
    ).nt.configure {
        $0.showsVerticalScrollIndicator(false)
    }
    
    private let mapButton = UIButton().nt.configure {
        $0.setImage(UIImage(systemName: "map"), for: .normal)
            .tintColor(.label)
    }
    
    private let listButton = UIButton().nt.configure {
        $0.setImage(UIImage(systemName: "list.bullet"), for: .normal)
            .tintColor(.label)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearEvent.send(())
        showActivityIndicator()
    }
    
    func bind(viewModel: WeatherSummaryViewModel) {
        let output = viewModel.transform(
            input: WeatherSummaryViewModel.Input(
                viewWillAppearEvent: viewWillAppearEvent,
                mapButtonTapEvent: mapButton.tapEvent,
                listButtonTapEvent: listButton.tapEvent
            )
        )
        
        output.collectionViewItem
            .withUnretained(self)
            .sink { vc, items in
                vc.updateSnapshot(items: items)
                vc.hideActivityIndicator()
            }
            .store(in: &cancelBag)
        
        output.locationFailure
            .withUnretained(self)
            .sink { vc, error in
                switch error {
                case .notAuthorized:
                    vc.showToast(message: "위치 권환을 활성화 해주세요")
                case .locationUpdateFailed:
                    vc.showToast(message: "위치 정보를 가져올 수 없습니다")
                case .unknown, .locationManagerError:
                    Logger.error(error)
                }
            }
            .store(in: &cancelBag)
        
        output.networkingFailure
            .withUnretained(self)
            .sink { vc, error in
                Logger.error(error)
                vc.showToast(message: "네트워크 오류")
            }
            .store(in: &cancelBag)
        
        output.startMapFlow
            .withUnretained(self)
            .sink { vc, _ in
                vc.navigationController?.pushViewController(
                    MapViewController(),
                    animated: true
                )
            }
            .store(in: &cancelBag)
        
        output.startListFlow
            .withUnretained(self)
            .sink { vc, _ in
                vc.navigationController?.pushViewController(
                    SearchCityViewController(),
                    animated: true
                )
            }
            .store(in: &cancelBag)
    }
    
    override func configureUI() {
        toolbarItems = [
            UIBarButtonItem(customView: mapButton),
            UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil,
                action: nil
            ),
            UIBarButtonItem(customView: listButton)
        ]
        navigationController?.isToolbarHidden = false
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
        let currentWeatherSection = makeCurrentWeatherSection()
        let threeHoursSection = makeThreeHoursSection()
        let locationSection = makeLocationSection()
        let fiveDaysSection = makeFiveDaysSection()
        let weatherConditionsSection = makeWeatherConditionsSection()
        
        return UICollectionViewCompositionalLayout { section, env in
            let sectionKind = CollectionViewSection.allCases[section]
            let section = switch sectionKind {
            case .currentWeather:
                currentWeatherSection
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
    
    private func makeCurrentWeatherSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(2/3)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        return section
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
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(10)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
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
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(10)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        return section
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
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(10)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        return section
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
        let currentWeatherRegistration = makeCurrentWeatherRegistration()
        let threeHoursRegistration = makeThreeHoursRegistration()
        let fiveDaysRegistration = makeFiveDaysRegistration()
        let locationRegistration = makeLocationRegistration()
        let weatherConditionsRegistration = makeWeatherConditionsRegistration()
        let headerRegistration = makeHeaderRegistration()
        
        dataSource = DataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            switch CollectionViewSection.allCases[indexPath.section] {
            case .currentWeather:
                collectionView.dequeueConfiguredReusableCell(
                    using: currentWeatherRegistration,
                    for: indexPath,
                    item: item
                )
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
        dataSource.supplementaryViewProvider =
        { collectionView, elementKind, indexPath in
            switch CollectionViewSection.allCases[indexPath.section] {
            case .threeHours, .fiveDays, .location:
                collectionView.dequeueConfiguredReusableSupplementary(
                    using: headerRegistration,
                    for: indexPath
                )
            default:
                nil
            }
        }
        updateSnapshot(items: CollectionViewItem.placeholder)
    }
    
    private func makeCurrentWeatherRegistration() -> CurrentWeatherRegistration {
        CurrentWeatherRegistration { cell, indexPath, cellData in
            if case .currentWeather(let item) = cellData {
                cell.configureCell(item: item)
            }
        }
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
    
    private func makeHeaderRegistration(
    ) -> HeaderRegistration {
        HeaderRegistration(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { view, kind, indexPath in
            var config = UIListContentConfiguration.cell()
            let section = CollectionViewSection.allCases[indexPath.section]
            config.text = section.title
            config.image = section.image
            config.imageToTextPadding = 8
            config.imageProperties.tintColor = .label
            view.contentConfiguration = config
        }
    }
    
    private func updateSnapshot(items: [CollectionViewItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections(CollectionViewSection.allCases)
        items.forEach { item in
            switch item {
            case .currentWeather:
                snapshot.appendItems(
                    [item],
                    toSection: .currentWeather
                )
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
    
    enum CollectionViewSection: CaseIterable {
        case currentWeather, threeHours, fiveDays, location, weatherConditions
        
        var title: String? {
            switch self {
            case .threeHours:
                "3시간 간격의 일기예보"
            case .fiveDays:
                "5일 간의 일기예보"
            case .location:
                "위치"
            default:
                nil
            }
        }
        
        var image: UIImage? {
            switch self {
            case .threeHours, .fiveDays:
                UIImage(systemName: "calendar")
            case .location:
                UIImage(systemName: "thermometer.medium")
            default:
                nil
            }
        }
    }
    
    enum CollectionViewItem: Hashable {
        case currentWeather(CurrentWeather)
        case threeHours(ThreeHourForecast)
        case fiveDays(FiveDayForecast)
        case location(WeatherLocationInfo)
        case weatherConditions(WeatherCondition)
    }
    
    typealias DataSource =
    UICollectionViewDiffableDataSource
    <CollectionViewSection, CollectionViewItem>
    
    typealias Snapshot =
    NSDiffableDataSourceSnapshot<CollectionViewSection, CollectionViewItem>
    
    typealias CurrentWeatherRegistration =
    UICollectionView.CellRegistration
    <CurrentWeatherCVCell, CollectionViewItem>
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
    
    typealias HeaderRegistration =
    UICollectionView.SupplementaryRegistration<UICollectionViewCell>
}
