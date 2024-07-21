//
//  BaseCollectionView.swift
//  Weather
//
//  Created by gnksbm on 7/21/24.
//

import UIKit

class BaseCollectionView: UICollectionView {
    override init(
        frame: CGRect,
        collectionViewLayout layout: UICollectionViewLayout
    ) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
