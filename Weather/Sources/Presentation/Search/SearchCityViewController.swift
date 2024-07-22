//
//  SearchCityViewController.swift
//  Weather
//
//  Created by gnksbm on 7/21/24.
//

import Combine
import UIKit

import SnapKit

final class SearchCityViewController: BaseViewController, View {
    private let viewDidLoadEvent = PassthroughSubject<Void, Never>()
    private var cancelBag = CancelBag()
    
    private let collectionView = SearchCityCollectionView()
    
    private let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadEvent.send(())
    }
    
    func bind(viewModel: SearchCityViewModel) {
        let output = viewModel.transform(
            input: SearchCityViewModel.Input(
                viewDidLoadEvent: viewDidLoadEvent.eraseToAnyPublisher(),
                searchTextChangeEvent: searchController.searchBar
                    .searchTextField.textChangeEvent,
                itemSelectEvent: collectionView.didSelectItemEvent
                    .withUnretained(self)
                    .map { vc, indexPath in
                        vc.collectionView.getItem(indexPath: indexPath)
                    }
                    .eraseToAnyPublisher()
            )
        )
        
        output.cityList
            .withUnretained(self)
            .sink { vc, dataList in
                vc.collectionView.updateSnapshot(items: dataList)
            }
            .store(in: &cancelBag)
    }
    
    override func configureNavigation() {
        navigationController?.navigationItem.searchController = searchController
    }
    
    override func configureLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
